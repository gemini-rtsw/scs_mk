/* $Id: setup.c,v 1.7 2015/05/01 00:04:02 mrippa Exp $ */
/* ===================================================================== */
/* INDENT OFF */
/*+
 *
 * FILENAME
 * -------- 
 * setup.c
 * 
 * PURPOSE
 * -------
 * 
 * 
 * 
 * FUNCTION NAME(S)
 * ----------------
 * 
 * DEPENDENCIES
 * ------------
 *
 * LIMITATIONS
 * -----------
 * 
 * AUTHOR
 * ------
 * Sean Prior  (srp@roe.ac.uk)
 * 
 * HISTORY
 * -------
 * 
 * 31-Mar-1998: Original (srp)
 * 23-Jun-1998: Create message queue for health reporting
 * 07-May-1999: Added RCS id
 * 05-Dec-2017: Begin conversion to EPICS OSI (mdw)
 *
 * oi
 */
/* INDENT ON */
/* ===================================================================== */

#include <stdlib.h>     /* for malloc() */
#include <string.h>
#include <stdio.h>
#include <iocsh.h>

/* Included for gctb */
#include <epicsThread.h>
#include <epicsEvent.h>
#include <epicsExit.h>
#include <epicsPrint.h>
#include <epicsExport.h>
#include <registryFunction.h>
#include <errlog.h>

#include <dbAccess.h>   /* For dbNameToAddr */
#include <devSup.h>     /* for S_dev_???   */
#include <vmi5588.h>    /* FOr reflective memory card routines */

#include "setup.h"
#include "utilities.h"  /* For errorLog, loadInitFiles, compileStatus,
                           statusCompiled, doPvLoad, pvLoadComplete */
#include "guide.h"      /* For createFilter, setPointFree */
#include "m2Log.h"          /* For cadDirLog */
#include "control.h"    /* For fireLoops, slowTransmit, scsReceive, scsPtr, 
                           scsBase, m2Ptr, m2MemFree, slowUpdate, wfsFree
                           diagnosticsAvailable, scsDataAvailable,
                           scsReceiveNow, commandQId, receiveQId 
                           SYSTEM_CLOCK_RATE */


extern void rmISR2(int);
extern void rmISR3(int);

/********** This section is to setup the gctb interface ***************/
/* Global thread control variables  */
epicsEventId gcbFlag; /* Indicates an interrupt has occurred */
epicsThreadId gcbTID; /* Thread ID for the gcb Interface*/
epicsThreadId gcbMonTID; /* Thread ID for the gcb Interface*/

EVENTPVT gcbRecProcFlag; /* Event object to trigger the Tx Record (needs to be reconsidered) */

int recFlagAcq = 0; /* The record flag has been defined  */


/* Global variables */
int stop = 0;
int start = 0;
float procRate = 5.0;


/* Declare externals */
epicsMessageQueueId  healthQId = NULL;

int  scsConfigureISR(void) {


    int status = ERROR;

    if ( (status = rmIntConnect(2, rmISR2)) != OK) 
        return status;

    if ( (status = rmIntConnect(3, rmISR3)) != OK )
        return status;

    return status;
    
}

/* ===================================================================== */
/* INDENT OFF */
/*
 * Function name:
 * scsInit
 * 
 * Purpose:
 * Create all semaphores and spawn all tasks for the SCS system except
 * for those related to the xycom and chopping, which are done in 
 * chopInit.
 * 
 * Invocation:
 * scsInit
 * 
 * Parameters in:
 * None
 *
 * Parameters out:
 * None
 * 
 * Return value:
 *  < status    int OK or ERROR
 * 
 * Globals: 
 *  External functions:
 *  None
 * 
 *  External variables:
 *      pwfs1Update
 *      pwfs1DataAvailable
 *      pwfs2Update
 *      pwfs2DataAvailable
 *      oiwfsUpdate
 *      oiwfsDataAvailable
 *      gaosUpdate
 *      gaosDataAvailable
 *      gyroUpdate
 *      gyroDataAvailable
 * 
 * Requirements:
 * 
 * Author:
 * Sean Prior  (srp@roe.ac.uk)
 * 
 * History:
 * 15-Oct-1997: Original(srp)
 * 10-Feb-1998: Incorporate spawning of guide handling tasks
 * 05-Dec-2017: Removed scsReady semaphore creation code since the semaphore
 *              wasn't being used anywhere. (mdw)
 */

/* INDENT ON */
/* ===================================================================== */
static int  mutex15  = 0;
static int  mutex16 = 0;

int scsInit (void)
{
   int source = PWFS1;

   if (scsConfigureISR() != OK) {

       errlogSevPrintf(errlogMajor, "Failed to connect interrupts.\n");
   }

   /* create semaphores to control pvload of initialisation files */
   doPvLoad = epicsEventMustCreate(epicsEventEmpty);
   //pvLoadComplete = epicsEventMustCreate(epicsEventEmpty);

   /* mutex semaphore to prevent multiple access to guide data */
   for (source = PWFS1; source <= GYRO; source++)
   {
      wfsFree[source] = epicsMutexMustCreate();
   }

   /* create dummy filters for each of the guide sources */
   for (source = PWFS1; source <= GYRO; source++)
   {
      createFilter (source, OFF, 200.0, 20.0, 20.0, -2.0, -2.0, -2.0);
   }

   /* create mutex semaphore to protect the set point values */
   setPointFree = epicsMutexCreate();

   /* 
    * The vxWorks code had stacksize for all threads set to 20000,
    * but epicsThreadStackBig is only 11000.
    * 
    * Are such large stack sizes really needed?
    *
    * TODO: Matt, Mike, Ignacio check...
    */
   
   refMemFree = epicsMutexMustCreate();
   eventDataSem = epicsMutexMustCreate();
   m2MemFree = epicsMutexMustCreate();

   scsDataAvailable = epicsEventMustCreate(epicsEventEmpty);
   slowUpdate = epicsEventMustCreate(epicsEventEmpty);
   scsReceiveNow = epicsEventMustCreate(epicsEventEmpty);
   guideUpdateNow = epicsEventMustCreate(epicsEventEmpty);
   diagnosticsAvailable = epicsEventMustCreate(epicsEventEmpty);

   /* spawn task to pvload initialisation data */
   epicsThreadMustCreate("tloadInit", epicsThreadPriorityLow, 
                     epicsThreadGetStackSize(epicsThreadStackBig),
                     (EPICSTHREADFUNC)loadInitFiles, (void *)NULL);

   /* spawn control loop task */
   epicsThreadMustCreate("tslowTx",epicsThreadPriorityLow,
                    epicsThreadGetStackSize(epicsThreadStackBig),
                    (EPICSTHREADFUNC)slowTransmit, (void *)NULL);

   /* M2 simulation pointer always points to the buffer area */
   if ((m2Ptr = (memMap *) malloc (sizeof (memMap))) == NULL)
   {
      printf ("malloc fail on creation of m2Ptr buffer\n");
      return (ERROR);
   }

   if ((scsPtr = (memMap *) malloc (sizeof (memMap))) == NULL)
   {
      printf ("malloc fail on creation of scsPtr buffer\n");
      return (ERROR);
   }
   /* Initialize the GCB memory space */
   if ((gcbSCSBase = (sharedMem *) malloc (sizeof(sharedMem))) == NULL) {
       printf("malloc fail on creation of gcbSCSBase buffer\n");
       return (ERROR);
   }
   /* Initialize the GCB status record client */
   if (!initGCBStatusDataShare()){
       printf("Failed to initialize the GCB status record\n");
       return (ERROR);
   }

   /* if no reflective memory card is present, create an equivalent buffer */
   if(rmStatus(0) != S_dev_NoInit) {
      scsBase = (memMap *) rmPageMemBase();
      printf("Reflective memory available\n");
   }
   else
   {
      printf("Reflective memory card not available\n");

      if ((scsBase = (memMap *) malloc (sizeof (memMap))) == NULL)    
      {
         errlogMessage("malloc fail on creation of scsBase buffer\n");
         return (ERROR);
      }
   }

   printf ("initRefMem, scsPtr = %p, scsBase = %p\n",  scsPtr, scsBase); 
   printf ("initSharedMem, gcbSCSBase = %p\n", scsBase); 

   if ((sbStatus = (SynchroStatus *) malloc (sizeof (SynchroStatus))) ==NULL )
   {
      printf ("malloc fail on creation of sbStatus buffer\n");
      return (ERROR);
   }

   /* create command message queue */
   if ((commandQId = epicsMessageQueueCreate(100, sizeof (long))) == NULL)
   {
      errorLog ("initRefMem(): error in creation of commandQId message queue", 1, ON);
   }
   else
   {
      printf ("iinitRefMem(): commandQId message queue created successfully\n");
   }

   /* create command receiving queue for the simulation */
   if ((receiveQId = epicsMessageQueueCreate(100, sizeof (long))) == NULL)
   {
      errorLog ("initRefMem():  error in creation of receiveQId message queue", 1, ON);
   }
   else
   {
      printf ("initRefMem(): receiveQId message queue created successfully\n");
   }

   /* create health message queue */
   if ((healthQId = epicsMessageQueueCreate(100, sizeof (healthReport))) == NULL)
   {
      errorLog ("initRefMem(): error in creation of healthiQId  message queue", 1, ON);
   }
   else
   {
      printf ("initRefMem(): healthiQId  message queue created successfully\n");
   }

   /* clear buffers */
   epicsMutexLock(refMemFree);
   memset ((void *) scsPtr, 0, sizeof (memMap));
   epicsMutexUnlock(refMemFree);
   mutex15++;
   epicsMutexLock(m2MemFree);
   memset ((void *) m2Ptr, 0, sizeof (memMap));
   epicsMutexUnlock(m2MemFree);
   mutex16++;
   memset ((void *) scsBase, 0, sizeof (memMap));
   memset ((void *) gcbSCSBase, 0, sizeof (sharedMem));
   memset ((void *) sbStatus, 0, sizeof (SynchroStatus));

   /* Do in startup in order that xycom has already been inited.
    * Then, if TIME_LATENCY needed, everything w.r.t. port addresses will
    * have been defined */

   epicsThreadMustCreate("tprocGuides", epicsThreadPriorityHigh,
                    epicsThreadGetStackSize(epicsThreadStackBig),
                    (EPICSTHREADFUNC)processGuides, (void *)NULL);

   /* spawn communication tasks */  
   /* these had been medium priority for GS */
   epicsThreadMustCreate("tscsRx", epicsThreadPriorityHigh,
                  epicsThreadGetStackSize(epicsThreadStackBig),
                  (EPICSTHREADFUNC)scsReceive, (void *)NULL);

   /*
    * Tilt Receive is a simulation thread.... MRIPPA
   epicsThreadMustCreate("ttiltRx", epicsThreadPriorityMedium,
                  epicsThreadGetStackSize(epicsThreadStackBig),
                  (EPICSTHREADFUNC)tiltReceive, (void *)NULL);
   */

   epicsThreadMustCreate("tfireLoops", epicsThreadPriorityLow,
                   epicsThreadGetStackSize(epicsThreadStackSmall),
                   (EPICSTHREADFUNC)fireLoops, (void *)NULL);

   /* Start GCB Status monitor Thread */
   startGCBStatusClientThread();

   return (OK);
}


static const iocshFuncDef scsInitFuncDef ={"scsInit", 0, NULL};
static void scsInitCallFunc(const iocshArgBuf *args)
{
    scsInit();
}

static void scsRegisterCommands(void)
{
    iocshRegister(&scsInitFuncDef, scsInitCallFunc);
}

epicsExportRegistrar(scsRegisterCommands);
/* epicsExportAddress(int, refmem_mon1);  */
epicsExportAddress(int, mutex15);
epicsExportAddress(int, mutex16);
