# 1 "../tilt_st.st"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "../tilt_st.st"
# 62 "../tilt_st.st"
program tilt_st

%%#include "utilities.h"
%%#include "control.h"

%%#include "tiltSim.h"

%%#include <string.h>

%%#define STATE_TIMEOUT 200


%{



static bitFieldM2 statusWord;
static long receivedCommand;
static long testNow, resetNow, initNow, chopNow;
static int count;
static int topEnd = 0;
static float temperature = 23.4;


}%




int32_t vibControl;
assign vibControl to "{S}vibControl.VAL";



int32_t chopProfile;
assign chopProfile to "{S}mechanism.C";

double chopFrequency;
assign chopFrequency to "{S}mechanism.D";

int32_t chopOn;
assign chopOn to "{S}mechanism.B";

int32_t syncSource;
assign syncSource to "{S}mechanism.E";



evflag scsCommand;

int32_t tiltEnable;
assign tiltEnable to "{S}enable.VAL";

int32_t offLoaders;
assign offLoaders to "{S}offLoaders.VAL";



string tiltState;
assign tiltState to "{S}tiltstate.VAL";



int32_t m2Central;
assign m2Central to "{S}central.VAL";

int32_t m2Deployable;
assign m2Deployable to "{S}deployable.VAL";

int32_t m2Heartbeat;
assign m2Heartbeat to "{S}heartbeat.VAL";
monitor m2Heartbeat;

string m2Health;
assign m2Health to "{S}tilthealth.VAL";
monitor m2Health;



int32_t sensorLimit;
assign sensorLimit to "{S}sensorLimit.VAL";

int32_t actuatorLimit;
assign actuatorLimit to "{S}actuatorLimit.VAL";

int32_t thermalLimit;
assign thermalLimit to "{S}thermalLimit.VAL";

int32_t mirrorDsp;
assign mirrorDsp to "{S}mirrorDsp.VAL";

int32_t vibrationDsp;
assign vibrationDsp to "{S}vibrationDsp.VAL";
# 195 "../tilt_st.st"
ss tiltControl
{
    state initialise
    {
        when ()
        {


            initNow = OFF;
            statusWord.flags.initInProgress = ON;



                strncpy(tiltState, "INITIALISE", MAX_STRING_SIZE - 1);
            tiltEnable = DISABLED;
            offLoaders = DISABLED;
            chopOn = OFF;



            pvPut (tiltState);
            pvPut (tiltEnable);
            pvPut (offLoaders);
            pvPut (chopOn);

            strncpy (m2Health, "GOOD", MAX_STRING_SIZE - 1);
            pvPut (m2Health);



            efClear (scsCommand);

        } state initialise1
    }



    state initialise1
    {


        when (delay (5.0))
        {


            statusWord.flags.initInProgress = OFF;

        } state reset
    }



    state reset
    {




        when ()
        {


            resetNow = OFF;
            statusWord.flags.resetInProgress = ON;



                strncpy(tiltState, "RESET", MAX_STRING_SIZE - 1);
            tiltEnable = DISABLED;
            offLoaders = DISABLED;
            chopOn = OFF;

            pvPut (tiltState);
            pvPut (tiltEnable);
            pvPut (offLoaders);
            pvPut (chopOn);

        } state reset1
    }



    state reset1
    {


        when (delay (5.0))
        {


            statusWord.flags.resetInProgress = OFF;

        } state moving
    }



    state moving
    {


        when ()
        {


                strncpy(tiltState, "MOVING", MAX_STRING_SIZE - 1);
            tiltEnable = ENABLED;
            offLoaders = ENABLED;
            chopOn = OFF;

            pvPut (tiltState);
            pvPut (tiltEnable);
            pvPut (offLoaders);
            pvPut (chopOn);

        } state movingProcessScsCommand
    }



    state movingProcessScsCommand
    {



        when (efTest (scsCommand) && initNow == ON)
        {
            efClear (scsCommand);
        } state initialise

        when (efTest (scsCommand) && resetNow == ON)
        {
            efClear (scsCommand);
        } state reset

        when (efTest (scsCommand) && testNow == ON)
        {
            efClear (scsCommand);
        } state test

        when (efTest (scsCommand) && chopNow == ON)
        {
            efClear (scsCommand);
        } state chopping
    }



    state chopping
    {


        when ()
        {


            statusWord.flags.chopOn = 1;



                strncpy(tiltState, "CHOPPING", MAX_STRING_SIZE - 1);
            tiltEnable = ENABLED;
            offLoaders = ENABLED;
            chopOn = ON;

            pvPut (tiltState);
            pvPut (tiltEnable);
            pvPut (offLoaders);
            pvPut (chopOn);

        } state chopping1
    }



    state chopping1
    {
        when (efTest (scsCommand) && initNow == ON)
        {
            efClear (scsCommand);

            statusWord.flags.chopOn = OFF;

        } state initialise


        when (efTest (scsCommand) && resetNow == ON)
        {
            efClear (scsCommand);

            statusWord.flags.chopOn = OFF;

        } state reset

        when (efTest (scsCommand) && testNow == ON)
        {
            efClear (scsCommand);

            statusWord.flags.chopOn = OFF;

        } state test

        when (efTest (scsCommand) && chopNow == OFF)
        {
            efClear (scsCommand);

            statusWord.flags.chopOn = OFF;

        } state moving
    }



    state test
    {
        when ()
        {


            testNow = OFF;
            statusWord.flags.testInProgress = ON;

                strncpy(tiltState, "TESTING", MAX_STRING_SIZE - 1);
            tiltEnable = ENABLED;
            offLoaders = ENABLED;
            chopOn = OFF;

            pvPut (tiltState);
            pvPut (tiltEnable);
            pvPut (offLoaders);
            pvPut (chopOn);

        } state test1
    }

    state test1
    {


        when (delay (5.0))
        {

            statusWord.flags.testInProgress = OFF;

        } state moving
    }
}



ss readRefMem
{



    state waitUpdate
    {
        when(delay(0.2))
        {
            epicsMutexLock(m2MemFree);


                m2Deployable = m2Ptr->page0.deployBaffle;
                m2Central = m2Ptr->page0.centralBaffle;
                chopProfile = m2Ptr->page0.chopProfile;
                chopFrequency = m2Ptr->page0.chopFrequency;

                epicsMutexUnlock(m2MemFree);




                {
                if(epicsMessageQueueTryReceive(receiveQId, &receivedCommand, sizeof (long)) == ERROR)
                    receivedCommand = FAST_ONLY;
                }

                if(receivedCommand == FAST_ONLY)
                {
                    statusWord.flags.diagnosticsAvailable = ON;
                }
                else if(receivedCommand == CHOP_ON)
                {
                    chopNow = ON;
                    statusWord.flags.chopOn = ON;
                }
                else if(receivedCommand == CHOP_OFF)
                {
                    chopNow = OFF;
                    statusWord.flags.chopOn = OFF;
                }
                else if(receivedCommand == SYNC_SOURCE_SCS)
                {
                    syncSource = EXTERNAL;
                    pvPut(syncSource);
                }
                else if(receivedCommand == SYNC_SOURCE_M2)
                {
                    syncSource = INTERNAL;
                    pvPut(syncSource);
                }
                else if(receivedCommand == ACT_PWR_ON)
                {
                    statusWord.flags.powerEnabled = ON;
                }
                else if(receivedCommand == ACT_PWR_OFF)
                {
                    statusWord.flags.powerEnabled = OFF;
                }
                else if(receivedCommand == CMD_INIT)
                {
                    initNow = ON;
                }
                else if(receivedCommand == CMD_RESET)
                {
                    resetNow = ON;
                }
                else if(receivedCommand == CMD_TEST)
                {
                    testNow = ON;
                }
                else if(receivedCommand == MSTART)
                {
                    tiltEnable = ENABLED;
                    statusWord.flags.mirrorControl = ON;
                    statusWord.flags.mirrorMoving = 1;
                    statusWord.flags.mirrorCommanded = 1;
                    statusWord.flags.mirrorResponding = 1;
                }
                else if(receivedCommand == MEND)
                {
                    tiltEnable = DISABLED;
                    statusWord.flags.mirrorControl = OFF;
                    statusWord.flags.mirrorMoving = 0;
                    statusWord.flags.mirrorCommanded = 0;
                    statusWord.flags.mirrorResponding = 0;
                }
                else if(receivedCommand == VIBSTART)
                {
                    vibControl = ENABLED;
                    statusWord.flags.vibControlOn = ON;
                }
                else if(receivedCommand == VEND)
                {
                    vibControl = DISABLED;
                    statusWord.flags.vibControlOn = OFF;
                }
                else if(receivedCommand == MOFFLON)
                {
                    offLoaders = ENABLED;
                    statusWord.flags.offloaders = ON;
                }
                else if(receivedCommand == MOFFLOFF)
                {
                    offLoaders = DISABLED;
                    statusWord.flags.offloaders = OFF;
                }
                else if(receivedCommand == DECS_ON)
                {
                    statusWord.flags.decsOn = ON;
                }
                else if(receivedCommand == DECS_OFF)
                {
                    statusWord.flags.decsOn = OFF;
                }
                else if(receivedCommand == DECS_PAUSE)
                {
                    statusWord.flags.decsPaused = ON;
                }
                else if(receivedCommand == DECS_CONTINUE)
                {
                    statusWord.flags.decsPaused = OFF;
                }
                else if(receivedCommand == DECS_FREEZE)
                {
                    statusWord.flags.decsFrozen = ON;
                }
                else if(receivedCommand == DECS_UNFREEZE)
                {
                    statusWord.flags.decsFrozen = OFF;
                }
                else if(receivedCommand == TILT_SPACE)
                {
                    statusWord.flags.space = 0;
                }
                else if(receivedCommand == ACTUATOR_SPACE)
                {
                    statusWord.flags.space = 1;
                }
                else if(receivedCommand == CHOP_CHANGE)
                {
                    pvPut(chopProfile);
                    pvPut(chopFrequency);
                }
                else if(receivedCommand == DIAGNOSTICS_REQUEST)
                {
                    statusWord.flags.diagnosticsAvailable = OFF;

                    for(count = 0; count < 5; count++)
                    {
                        m2Ptr->testResults.faults[count].index = count;
                        m2Ptr->testResults.faults[count].subsystem = count;
                        m2Ptr->testResults.faults[count].code = count;
                        }
                    m2Ptr->testResults.number = 4;
                }
            efSet(scsCommand);



            pvGet(sensorLimit);
            pvGet(actuatorLimit);
            pvGet(thermalLimit);
            pvGet(mirrorDsp);
            pvGet(vibrationDsp);

            if(sensorLimit > 0)
                statusWord.flags.sensorLimit = ON;
            else
                statusWord.flags.sensorLimit = OFF;

            if(actuatorLimit > 0)
                statusWord.flags.actuatorLimit = ON;
            else
                statusWord.flags.actuatorLimit = OFF;

            if(thermalLimit > 0)
                statusWord.flags.thermalLimit = ON;
            else
                statusWord.flags.thermalLimit = OFF;

            if(mirrorDsp > 0)
                statusWord.flags.mirrorDspInt = ON;
            else
                statusWord.flags.mirrorDspInt = OFF;

            if(vibrationDsp > 0)
                statusWord.flags.vibDspInt = ON;
            else
                statusWord.flags.vibDspInt = OFF;

            if((sensorLimit + actuatorLimit + thermalLimit + mirrorDsp + vibrationDsp) > 0)
                statusWord.flags.health = 1;
            else
                statusWord.flags.health = 0;



            epicsMutexLock(m2MemFree);
                m2Ptr->page1.statusWord.all = statusWord.all;
                m2Ptr->page1.heartbeat = m2Heartbeat;
                m2Ptr->page1.deployBaffle = m2Deployable;
                m2Ptr->page1.centralBaffle = m2Central;
                m2Ptr->page1.enclosureTemp = temperature;
                m2Ptr->page1.topEnd = topEnd;
            epicsMutexUnlock(m2MemFree);

        } state waitUpdate
    }
}
