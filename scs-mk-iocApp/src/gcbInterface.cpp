/*
 * @author iarriagada
 * @date 20231016
 */

#include <cstddef>
#include <cstdlib>
#include <cstddef>
#include <memory>
#include <iostream>
#include <string>
#include <cstdio>
#include <iocsh.h>
#include <epicsThread.h>
#include <epicsEvent.h>
#include <epicsExit.h>
#include <pv/lock.h>
#include <pv/pvDatabase.h>
#include <gcbCommand/gcbThread.h>
#include <gcbCommand/gcbCommandRecord.h>
#include <gcbCommand/gcbStatusRecord.h>
#include <gcbCommand/gcbSynchro.h>
#include <shareLib.h>

#include <epicsExport.h>
#include "gcbDefs.h"
#define epicsExportSharedSymbols

using namespace epics::pvDatabase;
using namespace epics::pvData;
using namespace epics::gcb::gcbCommand;
using namespace epics::gcb::gcbStatus;
using namespace epics::gcb::gcbThread;
using std::string;

/* Global pointer to gcb record */
GCBCommandRecordPtr gcb_rec = NULL;
/* Global pointers to GCB internal thread flags */
EpicsEventPtr rtTrigger = EpicsEventPtr(new epics::pvData::Event());
EpicsEventPtr rtStop = EpicsEventPtr(new epics::pvData::Event());

/* Global pointer to Status Monitor */
GCBStatusClientPtr gcb_sts_client = NULL;
statusBlock *page1gcb = new statusBlock();
EpicsEventPtr rxP1Trigger = EpicsEventPtr(new epics::pvData::Event());
EpicsEventPtr extReadThreadExit = EpicsEventPtr(new epics::pvData::Event());
EpicsMutexPtr rwPage1Sem = EpicsMutexPtr(new epicsMutex());
EpicsMutexPtr threadCountSem = EpicsMutexPtr(new epicsMutex());
int threadCounter = 0;
/* Initialize a pvClient using the PVAccess */
PvaClientPtr gcbStsPva = PvaClient::get("pva");

/*
 * @brief Initialize a custom PV GCBCommand Record. A global pointer to 
 * the record will be created.
 * 
 * @param recName: Name of the GCBCommand record.
 * This name can be used to identify the record in the database.
 * */
void initGcbCmdRecord(string recName)
{
    gcb_rec = GCBCommandRecord::create(recName);
    bool result = PVDatabase::getMaster()->addRecord(gcb_rec);
    if(!result) std::cout << string(recName) << " not added" << "\n";
}

/*
 * @brief Initialize client GCB Record. This creates a client type record,
 * with the purpose of monitoring a server GCB Status record. It uses the
 * the global pointer to a pvaClient object that makes the pva connection.
 * It also initializes the semaphore and the monitor flag to be used by the shared
 *
 * @param pvrName the name of the record to be monitored
 * */
/* In the diagram: gcbStsClient() */
void initGCBStatusClientRec(std::string pvrName)
{
    if (gcb_sts_client)
    {
        std::cout << "GCB Monitor has already been initialized...\n";
        return;
    }
    gcb_sts_client  = GCBStatusClient::createClient(pvrName, gcbStsPva);
}

/*
 * @brief Initializes the semaphore, monitor flag and shared page0.
 * After it passes the pointers to the gcbClient to be assigned to
 * the proper attributes.
 * */
int initGCBStatusDataShare()
{
    if(!gcb_sts_client)
    {
        std::cout << "The GCB Status client has not been initialized";
        return 1;
    }
    
    return gcb_sts_client->initDataSharing(page1gcb, rwPage1Sem, rxP1Trigger);
}

/*
 * @brief Start the internal thread from the gcbStatusClient
 * */
void startGCBStatusClientThread()
{
    if(!gcb_sts_client)
    {
        std::cout << "The GCB status client has not been initialized";
        return;
    }
    gcb_sts_client->startThread();
}

/*
 * @brief Execute the gcbCommandRecord method to write
 * the contents of the refMemory structure to the record fields
 **/
void gcbProcess(sharedMem *refmem)
{
    if(!gcb_rec) {
        throw std::runtime_error("gcbCommandRecord has not been created");
        return;
    }
    //std::cout << "Writting to GCB record thread\n";
    gcb_rec->processSynch(refmem);
}

/*
 * @brief Mask to be passed to the C infrastucture to wait for
 * a signal to the Write Status method
 * */
int stsBlockEventWait (){
    return rxP1Trigger->wait();
}

/*
 * @brief Mask to be passed to the C infrastucture to lock the R/W
 * semaphore
 * */
void stsBlockMutexLock(){
    rwPage1Sem->lock();
}

/*
 * @brief Mask to be passed to the C infrastucture to unlock the R/W
 * semaphore
 * */
void stsBlockMutexUnlock(){
    rwPage1Sem->unlock();
}

/*
 * @brief Mask to be passed to the C infrastucture for an external
 *  read from page 0 thread to get an exit signal
 * */
int externalReadThreadExitEventWait (){
    return extReadThreadExit->tryWait();
}

/*
 * @brief Mask to be passed to the C infrastucture to lock the thread counter
 * variable
 * */
void threadCntAdd(){
    threadCountSem->lock();
    threadCounter++;
    threadCountSem->unlock();
}

/*
 * @brief Mask to be passed to the C infrastucture to unlock the thread counter
 * variable
 * */
void threadCntSubstract(){
    threadCountSem->lock();
    threadCounter--;
    threadCountSem->unlock();
}

void exitGracefully(){
    extReadThreadExit->signal();
    rxP1Trigger->signal();
    while(threadCounter){
        epicsThreadSleep(0.005);
    }
    //epicsExit(1);
}

/* Define all the EPICS console functions */

static const iocshArg recinitArg0 = { "recordName", iocshArgString };
static const iocshArg *recinitArgs[] = { &recinitArg0 };

static const iocshFuncDef gcbInitRecFuncDef = {
    "gcbInitCmdRecord", 1, recinitArgs};

static void gcbInitRecCallFunc(const iocshArgBuf *args)
{
    PVRecordPtr record;
    std::string recordName = args[0].sval;
    if(!recordName.c_str()) {
        throw std::runtime_error("gcbStarRecThread: invalid number of arguments");
    }
    initGcbCmdRecord(recordName);
}

static const iocshFuncDef gcbInitStatusClientDataSharingFuncDef = {
    "gcbInitStatusClientDataShare", 0, NULL};

static void gcbInitStatusClientDataSharingCallFunc(const iocshArgBuf *args)
{
    initGCBStatusDataShare();
}

static const iocshArg pvcltArg0 = { "pvcltName", iocshArgString };
static const iocshArg *pvcltArgs[] = { &pvcltArg0 };

static const iocshFuncDef gcbInitStsCltFuncDef = {
    "gcbInitStatusPVAClient", 1, pvcltArgs};

static void gcbInitStsCltCallFunc(const iocshArgBuf *args)
{
    char *pvcltName = args[0].sval;
    if(!pvcltName) {
        throw std::runtime_error("gcbInitStatusPVAClient: invalid number of arguments");
    }
    initGCBStatusClientRec(pvcltName);
}

static const iocshFuncDef gcbStartStsClientThreadFuncDef = {
    "gcbStartStatusClientThread", 0, NULL};

static void gcbStartStsClientThreadCallFunc(const iocshArgBuf *args)
{
    startGCBStatusClientThread();
}

static void gcbRegisterCppCommands(void)
{
    static int firstTime = 1;
    if (firstTime) {
        firstTime = 0;
        iocshRegister(&gcbInitRecFuncDef, gcbInitRecCallFunc);
        iocshRegister(&gcbInitStsCltFuncDef, gcbInitStsCltCallFunc);
        iocshRegister(&gcbStartStsClientThreadFuncDef, gcbStartStsClientThreadCallFunc);
        iocshRegister(&gcbInitStatusClientDataSharingFuncDef, gcbInitStatusClientDataSharingCallFunc);
    }
}

extern "C" {
    epicsExportRegistrar(gcbRegisterCppCommands);
}
