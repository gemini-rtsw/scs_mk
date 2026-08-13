# 1 "../scs_mon.st"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "../scs_mon.st"
program scs_mon

option -a;
option +c;
option +e;
option +l;
option -r;
option +w;

%%#include "control.h"

%%#include "chop.h"
%%#include "config.h"
%%#include <car.h>

int32_t monitorProcessState;
assign monitorProcessState to "{T}monitorProcessState.VAL";
monitor monitorProcessState;

int32_t coincidence;
assign coincidence to "{T}coincidence.VAL";
monitor coincidence;

int32_t monitorSadState;
assign monitorSadState to "{T}monitorSadState.VAL";
monitor monitorSadState;

string inPositionSad;
assign inPositionSad to "{D}inPosition.VAL";

string deployableSad;
assign deployableSad to "{D}DeployBafflePos.VAL";

string centralSad;
assign centralSad to "{D}CentralBafflePos.VAL";

int32_t moveBaffleCar;
assign moveBaffleCar to "{T}moveBaffleC.IVAL";

double tempSad;
assign tempSad to "{D}temperature.VAL";

string chopping;
assign chopping to "{D}chopping.VAL";




int32_t followS;
assign followS to "{T}followS.VAL";

double xWindup;
assign xWindup to "{T}xWindup.VAL";
double yWindup;
assign yWindup to "{T}yWindup.VAL";
double zWindup;
assign zWindup to "{T}zWindup.VAL";

int32_t source;
assign source to "{T}guideConfig.VALA";





double x[5];
assign x[0] to "{T}xtilt0.VAL";
assign x[1] to "{T}xtilt1.VAL";
assign x[2] to "{T}xtilt2.VAL";
assign x[3] to "{T}xtilt3.VAL";
assign x[4] to "{T}xtilt4.VAL";

double y[5];
assign y[0] to "{T}ytilt0.VAL";
assign y[1] to "{T}ytilt1.VAL";
assign y[2] to "{T}ytilt2.VAL";
assign y[3] to "{T}ytilt3.VAL";
assign y[4] to "{T}ytilt4.VAL";

double z[5];
assign z[0] to "{T}focus0.VAL";
assign z[1] to "{T}focus1.VAL";
assign z[2] to "{T}focus2.VAL";
assign z[3] to "{T}focus3.VAL";
assign z[4] to "{T}focus4.VAL";

double xerr[5];
assign xerr[0] to "{T}xerr0.VAL";
assign xerr[1] to "{T}xerr1.VAL";
assign xerr[2] to "{T}xerr2.VAL";
assign xerr[3] to "{T}xerr3.VAL";
assign xerr[4] to "{T}xerr4.VAL";

double yerr[5];
assign yerr[0] to "{T}yerr0.VAL";
assign yerr[1] to "{T}yerr1.VAL";
assign yerr[2] to "{T}yerr2.VAL";
assign yerr[3] to "{T}yerr3.VAL";
assign yerr[4] to "{T}yerr4.VAL";

double zerr[5];
assign zerr[0] to "{T}zerr0.VAL";
assign zerr[1] to "{T}zerr1.VAL";
assign zerr[2] to "{T}zerr2.VAL";
assign zerr[3] to "{T}zerr3.VAL";
assign zerr[4] to "{T}zerr4.VAL";

double xRateLimit;
assign xRateLimit to "{T}xRateLimit.VAL";
double yRateLimit;
assign yRateLimit to "{T}yRateLimit.VAL";
double zRateLimit;
assign zRateLimit to "{T}zRateLimit.VAL";
# 149 "../scs_mon.st"
ss monitorProcess {

   state start {

      option -e;
      entry {
        puts("MonitorProcess:updateParameters start");
      }
      when() {
      } state updateParameters
   }

   state updateParameters {

      option +e;
      entry {
        puts("MonitorProcess:updateParameters start");
      }
      when(delay(0.5) ) {
         monitorProcessState = UPDATEPARAMETERS;
         pvPut(monitorProcessState);

         if(refMemFree) {
            epicsMutexLock(refMemFree);

            coincidence = !scsPtr->page1.inPosition;
            epicsMutexUnlock(refMemFree);
         }
         else {
            errorLog ("monitorProcess - refMemFree timeout", 1, ON);
         }

         pvPut(coincidence);

      } state updateParameters
   }

}
# 221 "../scs_mon.st"
ss monitorSad {
   state init {
      when() {
         monitorSadState = MONSADENTRY;
         pvPut(monitorSadState);

      } state updateSad
   }

   state updateSad {
      when(delay(1.0)) {
         monitorSadState = UPDATESAD;
         pvPut(monitorSadState);

         printf("mon:updatesad page1\n");
         %{
            if(refMemFree) {
                 epicsMutexLock(refMemFree);

                 if(scsPtr->page1.inPosition != 0 || followOn || guideOn)
                     strncpy(inPositionSad, "TRUE", MAX_STRING_SIZE - 1);
                 else
                     strncpy(inPositionSad, "FALSE", MAX_STRING_SIZE - 1);







                 if ((scsPtr->page1.deployBaffle == 0) |
                         (scsPtr->page1.deployBaffle == 1) |
                         (scsPtr->page1.deployBaffle == 2) |
                         (scsPtr->page1.deployBaffle == 3)) {
                     strncpy(deployableSad,
                             depBaffle[scsPtr->page1.deployBaffle],
                             MAX_STRING_SIZE - 1);

                     moveBaffleCar = CAR_IDLE;
                 }
                 else {
                     strncpy(deployableSad, "MOVING", MAX_STRING_SIZE - 1);
                     moveBaffleCar = CAR_BUSY;
                 }




                 if ((scsPtr->page1.centralBaffle == 0) |
                         (scsPtr->page1.centralBaffle == 1)) {
                     strncpy(centralSad,
                             cenBaffle[scsPtr->page1.centralBaffle],
                             MAX_STRING_SIZE - 1);

                     moveBaffleCar = CAR_IDLE;
                 }

                 else {
                     strncpy(centralSad, "MOVING", MAX_STRING_SIZE - 1);
                     moveBaffleCar = CAR_BUSY;
                 }

                 tempSad = scsPtr->page1.enclosureTemp;
                 epicsMutexUnlock(refMemFree);
             }
             else
             {
                 errorLog("state updateSad - couldn't obtain refMemFree mutex", 1, ON);
             }
         }%

         printf("mon:updatesad page1\n");
         pvPut(inPositionSad);

         pvPut(deployableSad);
         pvPut(centralSad);
         pvPut(moveBaffleCar);
         pvPut(tempSad);


         if(chopIsOn == ON)
            strncpy(chopping, "YES", MAX_STRING_SIZE - 1);
         else
            strncpy(chopping, "NO", MAX_STRING_SIZE - 1);

         pvPut(chopping);


         followS = followOn;
         pvPut(followS);


         %%checkTiltStatus();


         x[0] = filtered[PWFS1].z1;
         y[0] = filtered[PWFS1].z2;
         z[0] = filtered[PWFS1].z3;
         xerr[0] = filtered[PWFS1].err1;
         yerr[0] = filtered[PWFS1].err2;
         zerr[0] = filtered[PWFS1].err3;

         x[1] = filtered[PWFS2].z1;
         y[1] = filtered[PWFS2].z2;
         z[1] = filtered[PWFS2].z3;
         xerr[1] = filtered[PWFS2].err1;
         yerr[1] = filtered[PWFS2].err2;
         zerr[1] = filtered[PWFS2].err3;

         x[2] = filtered[OIWFS].z1;
         y[2] = filtered[OIWFS].z2;
         z[2] = filtered[OIWFS].z3;
         xerr[2] = filtered[OIWFS].err1;
         yerr[2] = filtered[OIWFS].err2;
         zerr[2] = filtered[OIWFS].err3;

         x[3] = filtered[GAOS].z1;
         y[3] = filtered[GAOS].z2;
         z[3] = filtered[GAOS].z3;
         xerr[3] = filtered[GAOS].err1;
         yerr[3] = filtered[GAOS].err2;
         zerr[3] = filtered[GAOS].err3;

         x[4] = filtered[GYRO].z1;
         y[4] = filtered[GYRO].z2;
         z[4] = filtered[GYRO].z3;
         xerr[4] = filtered[GYRO].err1;
         yerr[4] = filtered[GYRO].err2;
         zerr[4] = filtered[GYRO].err3;

         xWindup = controller[XTILT].sum;
         yWindup = controller[YTILT].sum;
         zWindup = controller[FOCUS].sum;




         pvPut(xWindup);
         pvPut(yWindup);
         pvPut(zWindup);

         printf("mon:updatesad source\n");
         for(source = 0; source < 5; source++) {
            pvPut(x[source]);
            pvPut(y[source]);
            pvPut(z[source]);
            pvPut(xerr[source]);
            pvPut(yerr[source]);
            pvPut(zerr[source]);
         }

      } state updateSad
   }
}
