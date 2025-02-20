#ifndef GCBDEFS_H
#define GCBDEFS_H

#ifdef __cplusplus
#include <gcbCommand/gcbCommandRecord.h>
#include <gcbCommand/gcbStatusRecord.h>
#include <epicsEvent.h>
#endif
#include <gcbCommand/gcbSynchro.h>

#ifdef __cplusplus
/* The Cpp global variables  */
using namespace epics::gcb::gcbCommand;
using namespace epics::gcb::gcbStatus;

//extern EpicsEventPtr rxTrigger;
extern EpicsEventPtr rxP1Trigger;
//extern EpicsMutexPtr rwMemSemaphore;
extern EpicsMutexPtr rwPage1Sem;
extern EpicsEventPtr extReadThreadExit;
extern EpicsMutexPtr threadCountSem;
#endif


#ifdef __cplusplus
extern "C" {
#endif
    /* Functions and shared memory to be used by Cpp and C stuff  */
    //extern gcbBlock *page0;
    extern int threadCounter;
    extern statusBlock *page1gcb;
    //extern int cmdBlockEventWait();
    //extern void cmdBlockMutexLock();
    //extern void cmdBlockMutexUnlock();
    //extern void gcbStatusProcess(statusBlock *refmem);
    //extern void statusBlockTrigger();
    extern int initGCBStatusDataShare();
    extern int externalReadThreadExitEventWait();
    extern int stsBlockEventWait();
    extern void stsBlockMutexLock();
    extern void startGCBStatusClientThread();
    extern void stsBlockMutexUnlock();
    extern void threadCntAdd();
    extern void threadCntSubstract();
    extern void gcbProcess(sharedMem *refmem);
    extern void exitGracefully();
#ifdef __cplusplus
}
#endif

#endif /* GCBDEFS_H */
