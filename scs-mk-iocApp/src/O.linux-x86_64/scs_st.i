# 1 "../scs_st.st"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "../scs_st.st"
# 98 "../scs_st.st"
   program scs_st

   option -a;
   option +c;
   option +d;
   option +l;
   option -r;
   option +w;
   option +e;

   %%#include "archive.h"
   %%#include "chop.h"
   %%#include "chopControl.h"
   %%#include "config.h"
   %%#include "control.h"

   %%#include "guide.h"
   %%#include "interp.h"
   %%#include "scs.h"
   %%#include "utilities.h"
   %%#include "eventBus.h"
   %%#include "testFunctions.h"
   %%#include "interlock.h"
   %%#include <vmi5588.h>
   %%#include <epicsThread.h>


   %%#include <stdlib.h>
   %%#include <string.h>
   %%#include <math.h>

   %%#include <car.h>

   %%#define CMD_RESPONSE_TIMEOUT 13.0

   %%#define INIT_COMPLETE_TIMEOUT 400.0

   %%#define TIMEOUT 66.0
   %%#define PARK_TIMEOUT 132.0
   %%#define CHOP_TIMEOUT 33.0
   %%#define MOVE_TIMEOUT 265.0
   %%#define SERVO_OFF_TIMEOUT 3.0

   %%#define COUNTER_LIMIT 1
   %%#define REBOOT_VALUE 1



   %%#define STATUS_OK 0
   %%#define STATUS_WARNING 1
   %%#define STATUS_ERROR 2
   %%enum {NOT_COMPLETE, COMPLETE};

   %{



      int argc;
      char *argv[40];
      char *cmd_argv;
      char *cmds[40];
# 169 "../scs_st.st"
      static struct
      {
         long oldNR;
         long newNR;
         long oldHeartbeat;
         long newHeartbeat;
      }handshake;
# 186 "../scs_st.st"
      static location parkPosition;


      static double xTiltAdef;
      static double yTiltAdef;
      static double xTiltBdef;
      static double yTiltBdef;
      static double xTiltCdef;
      static double yTiltCdef;
      static double zFocusDef;
      static double xPosDef;
      static double yPosDef;
      static double xPosTcsDef;
      static double yPosTcsDef;
      static double xyDeadband;

      static long myOldGuideSimState = 0;
      int loadComplete;

   }%





string scs0name;
assign scs0name to "{I}scs0.ZRST";

string scs0port;
assign scs0port to "{I}scs0.ONST";

string scs0capability;
assign scs0capability to "{I}scs0.TWST";

string ics0name;
assign ics0name to "{I}ics0.ZRST";

string ics0port;
assign ics0port to "{I}ics0.ONST";

string ics0capability;
assign ics0capability to "{I}ics0.TWST";

string ics1name;
assign ics1name to "{I}ics1.ZRST";

string ics1port;
assign ics1port to "{I}ics1.ONST";

string ics1capability;
assign ics1capability to "{I}ics1.TWST";

string ics2name;
assign ics2name to "{I}ics2.ZRST";

string ics2port;
assign ics2port to "{I}ics2.ONST";

string ics2capability;
assign ics2capability to "{I}ics2.TWST";

string ics3name;
assign ics3name to "{I}ics3.ZRST";

string ics3port;
assign ics3port to "{I}ics3.ONST";

string ics3capability;
assign ics3capability to "{I}ics3.TWST";

string ics4name;
assign ics4name to "{I}ics4.ZRST";

string ics4port;
assign ics4port to "{I}ics4.ONST";

string ics4capability;
assign ics4capability to "{I}ics4.TWST";






double tiltSkew;
assign tiltSkew to "{F}tiltSkew.VAL";

double tiltOffsetX;
assign tiltOffsetX to "{F}tiltOffsetX.VAL";

double tiltOffsetY;
assign tiltOffsetY to "{F}tiltOffsetY.VAL";

double posSkew;
assign posSkew to "{F}posSkew.VAL";

double posOffsetX;
assign posOffsetX to "{F}posOffsetX.VAL";

double posOffsetY;
assign posOffsetY to "{F}posOffsetY.VAL";

double gaosSkew;
assign gaosSkew to "{F}gaosSkew.VAL";

double gaosOffsetX;
assign gaosOffsetX to "{F}gaosOffsetX.VAL";

double gaosOffsetY;
assign gaosOffsetY to "{F}gaosOffsetY.VAL";

double gyroSkew;
assign gyroSkew to "{F}gyroSkew.VAL";

double gyroOffsetX;
assign gyroOffsetX to "{F}gyroOffsetX.VAL";

double gyroOffsetY;
assign gyroOffsetY to "{F}gyroOffsetY.VAL";

double focusScaling;
assign focusScaling to "{F}focusScaling.VAL";

double currFocus;




int32_t testResponse;
assign testResponse to "{T}byte0:b5.VAL";
monitor testResponse;

int32_t rebootResponse;
assign rebootResponse to "{T}byte0:b4.VAL";
monitor rebootResponse;

int32_t initResponse;
assign initResponse to "{T}byte0:b3.VAL";
monitor initResponse;

int32_t chopResponse;
assign chopResponse to "{T}byte0:b7.VAL";
monitor chopResponse;

int32_t servoOnStat;
assign servoOnStat to "{T}byte3:b6.VAL";
monitor servoOnStat;

int32_t XYmovingStatus;
assign XYmovingStatus to "{T}byte1:b4.VAL";
monitor XYmovingStatus;
# 348 "../scs_st.st"
int32_t testCadStart;
assign testCadStart to "{T}testP:start.VAL";
monitor testCadStart;

evflag testCadChange;
sync testCadStart to testCadChange;

int32_t testCarIn;
assign testCarIn to "{T}testC.IVAL";

int32_t testCarErrIn;
assign testCarErrIn to "{T}testC.IERR";

string testCarMessIn;
assign testCarMessIn to "{T}testC.IMSS";

string testResultString;
assign testResultString to "{T}fault0.VAL";







int32_t initCadStart;
assign initCadStart to "{T}initP:start.VAL";
monitor initCadStart;

evflag initCadChange;
sync initCadStart to initCadChange;

int32_t initCarIn;
assign initCarIn to "{T}initC.IVAL";

int32_t initCarErrIn;
assign initCarErrIn to "{T}initC.IERR";

string initCarMessIn;
assign initCarMessIn to "{T}initC.IMSS";







int32_t initXYCadStart;
assign initXYCadStart to "{T}initPXY:start.VAL";
monitor initXYCadStart;

evflag initXYCadChange;
sync initXYCadStart to initXYCadChange;

int32_t initXYCarIn;
assign initXYCarIn to "{T}initCXY.IVAL";

int32_t initXYCarErrIn;
assign initXYCarErrIn to "{T}initCXY.IERR";

string initXYCarMessIn;
assign initXYCarMessIn to "{T}initCXY.IMSS";
# 419 "../scs_st.st"
string source0;
assign source0 to "{T}source.ZRST";

string source1;
assign source1 to "{T}source.ONST";

string source2;
assign source2 to "{T}source.TWST";

string source3;
assign source3 to "{T}source.THST";

string source4;
assign source4 to "{T}source.FRST";

string source5;
assign source5 to "{T}source.FVST";

string source6;
assign source6 to "{T}source.SXST";

string inst0;
assign inst0 to "{T}syncsource.ZRST";

string inst1;
assign inst1 to "{T}syncsource.ONST";

string inst2;
assign inst2 to "{T}syncsource.TWST";

string inst3;
assign inst3 to "{T}syncsource.THST";

string inst4;
assign inst4 to "{T}syncsource.FRST";

string inst5;
assign inst5 to "{T}syncsource.FVST";

string inst6;
assign inst6 to "{T}syncsource.SXST";
# 468 "../scs_st.st"
int32_t rebootCadStart;
assign rebootCadStart to "{T}rebootP:start.VAL";
monitor rebootCadStart;

evflag rebootCadChange;
sync rebootCadStart to rebootCadChange;

int32_t rebootCarIn;
assign rebootCarIn to "{T}rebootC.IVAL";

int32_t rebootCarErrIn;
assign rebootCarErrIn to "{T}rebootC.IERR";

string rebootCarMessIn;
assign rebootCarMessIn to "{T}rebootC.IMSS";







int32_t clearGuideFocusCadStart;
assign clearGuideFocusCadStart to "{T}clearGuideFocusP:start.VAL";
monitor clearGuideFocusCadStart;

evflag clearGuideFocusCadChange;
sync clearGuideFocusCadStart to clearGuideFocusCadChange;

int32_t clearGuideFocusCarIn;
assign clearGuideFocusCarIn to "{T}clearGuideFocusC.IVAL";

int32_t clearGuideFocusCarErrIn;
assign clearGuideFocusCarErrIn to "{T}clearGuideFocusC.IERR";

string clearGuideFocusCarMessIn;
assign clearGuideFocusCarMessIn to "{T}clearGuideFocusC.IMSS";
# 515 "../scs_st.st"
int32_t moveCadStart;
assign moveCadStart to "{T}moveP:start.VAL";
monitor moveCadStart;

evflag moveCadChange;
sync moveCadStart to moveCadChange;

int32_t moveCarIn;
assign moveCarIn to "{T}moveC.IVAL";

int32_t moveCarErrIn;
assign moveCarErrIn to "{T}moveC.IERR";

string moveCarMessIn;
assign moveCarMessIn to "{T}moveC.IMSS";

double moveAXTilt;
assign moveAXTilt to "{T}move.VALA";

double moveAYTilt;
assign moveAYTilt to "{T}move.VALB";

double moveBXTilt;
assign moveBXTilt to "{T}move.VALC";

double moveBYTilt;
assign moveBYTilt to "{T}move.VALD";

double moveCXTilt;
assign moveCXTilt to "{T}move.VALE";

double moveCYTilt;
assign moveCYTilt to "{T}move.VALF";

double moveZFocus;
assign moveZFocus to "{T}move.VALG";

double moveXPosition;
assign moveXPosition to "{T}move.VALH";

double moveYPosition;
assign moveYPosition to "{T}move.VALI";

int32_t moveDir;
assign moveDir to "{T}move.DIR";

int32_t moveBaffleDir;
assign moveBaffleDir to "{T}moveBaffle.DIR";

int32_t chopConfigDir;
assign chopConfigDir to "{T}chopConfig.DIR";


double moveXInputPos;
assign moveXInputPos to "{T}move.G";

double moveYInputPos;
assign moveYInputPos to "{T}move.H";




int32_t pidDir;
assign pidDir to "{T}setController.DIR";



int32_t vtkXCtrl;
assign vtkXCtrl to "{T}X:vtkOn.VAL";
int32_t vtkXCtrlDir;
assign vtkXCtrlDir to "{T}X:vtkControl.DIR";

int32_t vtkYCtrl;
assign vtkYCtrl to "{T}Y:vtkOn.VAL";
int32_t vtkYCtrlDir;
assign vtkYCtrlDir to "{T}Y:vtkControl.DIR";

int32_t vtkXDir;
assign vtkXDir to "{T}X:setVTKControl.DIR";

int32_t vtkYDir;
assign vtkYDir to "{T}Y:setVTKControl.DIR";

double vtkXSampleRate;
assign vtkXSampleRate to "{T}X:setVTKControl.VALA";
double vtkXScale;
assign vtkXScale to "{T}X:setVTKControl.VALF";
double vtkXAngle;
assign vtkXAngle to "{T}X:setVTKControl.VALG";

double vtkYSampleRate;
assign vtkYSampleRate to "{T}Y:setVTKControl.VALA";
double vtkYScale;
assign vtkYScale to "{T}Y:setVTKControl.VALF";
double vtkYAngle;
assign vtkYAngle to "{T}Y:setVTKControl.VALG";

int32_t measuredSampleRate;
assign measuredSampleRate to "{T}decimator.VALS";
monitor measuredSampleRate;

evflag vtkChange;
sync measuredSampleRate to vtkChange;



int32_t phasorXDir;
assign phasorXDir to "{T}X:setPhasorControl.DIR";

int32_t phasorYDir;
assign phasorYDir to "{T}Y:setPhasorControl.DIR";





int32_t actuatorCadStart;
assign actuatorCadStart to "{T}moveActuatorP:start.VAL";
monitor actuatorCadStart;

evflag actuatorCadChange;
sync actuatorCadStart to actuatorCadChange;

int32_t actuatorCarIn;
assign actuatorCarIn to "{T}moveActuatorC.IVAL";

int32_t actuatorCarErrIn;
assign actuatorCarErrIn to "{T}moveActuatorC.IERR";

string actuatorCarMessIn;
assign actuatorCarMessIn to "{T}moveActuatorC.IMSS";

double actXTilt;
assign actXTilt to "{T}moveActuator.VALD";

double actYTilt;
assign actYTilt to "{T}moveActuator.VALE";

double actZFocus;
assign actZFocus to "{T}moveActuator.VALF";
# 664 "../scs_st.st"
double atsent;
assign atsent to "{T}followA.VALA";
monitor atsent;

evflag newBeamA;
sync atsent to newBeamA;
# 678 "../scs_st.st"
int32_t followCadStart;
assign followCadStart to "{T}followP:start.VAL";
monitor followCadStart;

evflag followCadChange;
sync followCadStart to followCadChange;

int32_t followCarIn;
assign followCarIn to "{T}followC.IVAL";

int32_t followCarErrIn;
assign followCarErrIn to "{T}followC.IERR";

string followCarMessIn;
assign followCarMessIn to "{T}followC.IMSS";

int32_t arrayS;
assign arrayS to "{T}followA.VALB";

int32_t activeC;
assign activeC to "{T}activeC.IVAL";

int32_t currentId;

int32_t followS;
assign followS to "{T}followS.VAL";
# 712 "../scs_st.st"
int32_t stopCadStart;
assign stopCadStart to "{T}stopP:start.VAL";
monitor stopCadStart;

evflag stopCadChange;
sync stopCadStart to stopCadChange;

int32_t stopCarIn;
assign stopCarIn to "{T}stopC.IVAL";

int32_t stopCarErrIn;
assign stopCarErrIn to "{T}stopC.IERR";

string stopCarMessIn;
assign stopCarMessIn to "{T}stopC.IMSS";







int32_t parkCadStart;
assign parkCadStart to "{T}parkP:start.VAL";
monitor parkCadStart;

evflag parkCadChange;
sync parkCadStart to parkCadChange;

int32_t parkCarIn;
assign parkCarIn to "{T}parkC.IVAL";

int32_t parkCarErrIn;
assign parkCarErrIn to "{T}parkC.IERR";

string parkCarMessIn;
assign parkCarMessIn to "{T}parkC.IMSS";







int32_t guideSimStart;
assign guideSimStart to "{T}guideSimPROC.VALA";
monitor guideSimStart;

evflag guideSimChange;
sync guideSimStart to guideSimChange;

int32_t tiltPidOnSim;
assign tiltPidOnSim to "{T}tiltpidon.VAL";
monitor tiltPidOnSim;

int32_t tiltpidDir;
assign tiltpidDir to "{T}tiltpidControl.DIR";

int32_t focusPidOnSim;
assign focusPidOnSim to "{T}focuspidon.VAL";
monitor focusPidOnSim;

int32_t focuspidDir;
assign focuspidDir to "{T}focuspidControl.DIR";
# 784 "../scs_st.st"
int32_t chopControlCadStart;
assign chopControlCadStart to "{T}chopControlP:start.VAL";
monitor chopControlCadStart;

evflag chopControlCadChange;
sync chopControlCadStart to chopControlCadChange;

int32_t chopControlCarIn;
assign chopControlCarIn to "{T}chopControlC.IVAL";

int32_t chopControlCarErrIn;
assign chopControlCarErrIn to "{T}chopControlC.IERR";

string chopControlCarMessIn;
assign chopControlCarMessIn to "{T}chopControlC.IMSS";

int32_t chopOn;
assign chopOn to "{T}chopControl.VALA";

int32_t chopSwitch;
assign chopSwitch to "{T}chopon.VAL";

int32_t decsOn;
assign decsOn to "{T}chopControl.VALB";

int32_t decsPause;
assign decsPause to "{T}chopControl.VALC";

int32_t decsFreeze;
assign decsFreeze to "{T}chopControl.VALD";

int32_t decsReset;
assign decsReset to "{T}chopControl.VALE";

int32_t profile;
assign profile to "{T}chopConfig.VALA";

int32_t syncSource;
assign syncSource to "{T}chopConfig.VALB";

double dutyCycle;
assign dutyCycle to "{T}chopConfig.VALD";



int32_t guideSwitch;
assign guideSwitch to "{T}guideOn.VAL";

int32_t guideWidget;
assign guideWidget to "{T}guideReset.VAL";
# 842 "../scs_st.st"
int32_t toleranceCadStart;
assign toleranceCadStart to "{T}toleranceP:start.VAL";
monitor toleranceCadStart;

evflag toleranceCadChange;
sync toleranceCadStart to toleranceCadChange;

int32_t toleranceCarIn;
assign toleranceCarIn to "{T}toleranceC.IVAL";

int32_t toleranceCarErrIn;
assign toleranceCarErrIn to "{T}toleranceC.IERR";

string toleranceCarMessIn;
assign toleranceCarMessIn to "{T}toleranceC.IMSS";

double xTiltTol;
assign xTiltTol to "{T}tolerance.VALA";

double yTiltTol;
assign yTiltTol to "{T}tolerance.VALB";

double zFocusTol;
assign zFocusTol to "{T}tolerance.VALC";

double xPosTol;
assign xPosTol to "{T}tolerance.VALD";

double yPosTol;
assign yPosTol to "{T}tolerance.VALE";

double xyPosDeadband;
assign xyPosDeadband to "{T}tolerance.VALF";

double tolDir;
assign tolDir to "{T}tolerance.DIR";

double guideConfReset;
assign guideConfReset to "{T}guideConfigReset.DIR";

double setCont;
assign setCont to "{T}setController.DIR";
# 896 "../scs_st.st"
int32_t bandwidthCadStart;
assign bandwidthCadStart to "{T}servoP:start.VAL";
monitor bandwidthCadStart;

evflag bandwidthCadChange;
sync bandwidthCadStart to bandwidthCadChange;

double bandwidth;
assign bandwidth to "{T}servoBandwidth.VALA";

int32_t bandwidthCarIn;
assign bandwidthCarIn to "{T}servoBandwidthC.IVAL";

int32_t bandwidthCarErrIn;
assign bandwidthCarErrIn to "{T}servoBandwidthC.IERR";

string bandwidthCarMessIn;
assign bandwidthCarMessIn to "{T}servoBandwidthC.IMSS";
# 926 "../scs_st.st"
int32_t source;
assign source to "{T}guideConfig.VALA";

double sampleFrequency;
assign sampleFrequency to "{T}guideConfig.VALB";

int32_t filterType;
assign filterType to "{T}guideConfig.VALC";

double frequency1;
assign frequency1 to "{T}guideConfig.VALD";

double frequency2;
assign frequency2 to "{T}guideConfig.VALE";

double xweight;
assign xweight to "{T}guideConfig.VALF";
# 951 "../scs_st.st"
int32_t scsStateSad;
assign scsStateSad to "{D}state.VAL";

string topEndSad;
assign topEndSad to "{D}topEnd.VAL";

string chopping;
assign chopping to "{D}chopping.VAL";

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
# 1037 "../scs_st.st"
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

double xWindup;
assign xWindup to "{T}xWindup.VAL";
double yWindup;
assign yWindup to "{T}yWindup.VAL";
double zWindup;
assign zWindup to "{T}zWindup.VAL";





int32_t myscsState;


assign myscsState to "{T}scsState.VAL";
monitor myscsState;

int32_t cadProcessorState;
assign cadProcessorState to "{T}cadProcessorState.VAL";
monitor cadProcessorState;

int32_t followDemandState;
assign followDemandState to "{T}followDemandState.VAL";
monitor followDemandState;

int32_t monitorSadState;
assign monitorSadState to "{T}monitorSadState.VAL";
monitor monitorSadState;

int32_t monitorProcessState;
assign monitorProcessState to "{T}monitorProcessState.VAL";
monitor monitorProcessState;

int32_t rebootScsState;
assign rebootScsState to "{T}rebootScsState.VAL";
monitor rebootScsState;





int32_t coincidence;
assign coincidence to "{T}coincidence.VAL";
monitor coincidence;

evflag inPositionChange;
sync coincidence to inPositionChange;



int32_t servoInPosition;
assign servoInPosition to "{T}readRmDiags.VALE";
monitor servoInPosition;
# 1185 "../scs_st.st"
ss CADprocessor {
   state init {

      option +e;
      entry{
        printf("CADprocessor: init\n");
      }

      when() {


         myscsState = SYSTEMIDLE;
         scsState = myscsState;
         pvPut(myscsState);

         cadProcessorState = CADPROCENTRY;
         pvPut(cadProcessorState);



         reportHealth(GOOD, "");



         scsStateSad = BOOTING;
         pvPut(scsStateSad);

      } state clearFlags
   }



   state clearFlags {

      option +e;
      entry{
        printf("CADprocessor: clearFlags\n");
      }

      when() {


         efClear(testCadChange);
         efClear(initCadChange);
         efClear(initXYCadChange);
         efClear(moveCadChange);
         efClear(stopCadChange);
         efClear(parkCadChange);
         efClear(guideSimChange);
         efClear(chopControlCadChange);
         efClear(newBeamA);
         efClear(bandwidthCadChange);
         efClear(toleranceCadChange);
         efClear(inPositionChange);
         efClear(followCadChange);
         efClear(actuatorCadChange);
         efClear(vtkChange);

         puts("Cleared flags, starting INIT in 10.0 secs...");

      } state startInit
   }


   state idle {

      when() {
         cadProcessorState = CADPROCIDLE;
         pvPut(cadProcessorState);


         scsStateSad = RUNNING;
         pvPut(scsStateSad);

      } state waitForCommand
   }



   state waitForCommand {





      when(efTest(testCadChange))
      {

         efClear(testCadChange);

      } state startTestHandshake

      when(efTest(initCadChange))
      {

         efClear(initCadChange);

      } state startInit

      when(efTest(initXYCadChange))
      {

         efClear(initXYCadChange);

      } state startInitXY

      when(efTest(moveCadChange))
      {

         efClear(moveCadChange);

      } state startMove

      when(efTest(actuatorCadChange))
      {

         efClear(actuatorCadChange);

      } state startActuator

      when(efTest(followCadChange))
      {


         efClear(followCadChange);

      } state startFollow

      when(efTest(stopCadChange))
      {


         efClear(stopCadChange);

      } state startStop

      when(efTest(chopControlCadChange))
      {


         efClear(chopControlCadChange);

      } state startChopControl

      when(efTest(parkCadChange))
      {


         efClear(parkCadChange);

      } state startPark

      when(efTest(bandwidthCadChange))
      {


         efClear(bandwidthCadChange);

      } state startBandwidth

      when(efTest(toleranceCadChange))
      {


         efClear(toleranceCadChange);

      } state startTolerance

      when(efTest(guideSimChange))
      {
         efClear(guideSimChange);
      } state startGuideSimChange

      when(efTest(vtkChange))
      {

         efClear(vtkChange);

      } state startVtkChange

   }
# 1393 "../scs_st.st"
   state startTestHandshake
   {

      option +e;
      entry{
        printf("CADprocessor: startTestHandshake\n");
      }

      when()
      {
         cadProcessorState = STARTTESTHANDSHAKE;
         pvPut(cadProcessorState);



         handshake.oldNR = scsPtr->page1.NR;
         handshake.oldHeartbeat = scsPtr->page1.heartbeat;

      } state readAgain
   }

   state readAgain
   {

      option +e;
      entry{
        printf("CADprocessor: readAgain\n");
      }

      when(delay(0.3))
      {
         cadProcessorState = READAGAIN;
         pvPut(cadProcessorState);

         handshake.newNR = scsPtr->page1.NR;
         handshake.newHeartbeat = scsPtr->page1.heartbeat;



         if(handshake.newNR == handshake.oldNR)
         {
            strncpy(testResultString, "M2 not acknowledging command frames", MAX_STRING_SIZE - 1);
            reportHealth(BAD, "M2 not acknowledging command frames");
         }
         else if(handshake.newHeartbeat == handshake.oldHeartbeat)
         {
            strncpy(testResultString, "M2 heartbeat stuck", MAX_STRING_SIZE - 1);
            reportHealth(BAD, "M2 heartbeat stuck");
         }
         else
         {
            strncpy(testResultString, " ", MAX_STRING_SIZE - 1);
         }



         pvPut(testResultString);



         testCarIn = CAR_IDLE;
         pvPut(testCarIn);

      } state idle
   }
# 1488 "../scs_st.st"
   state startInit
   {

      option +e;
      entry{
        printf("CADprocessor: startInit\n");
      }


      when(delay(3.0))
      {
         pvGet(initResponse);
         printf("initResponse is %d\n", initResponse);

         errorLog("state startInit...", 1, ON);
         myscsState = INITIALISING;
         scsState = myscsState;
         pvPut(myscsState);

         cadProcessorState = STARTINIT;
         pvPut(cadProcessorState);

         scsStateSad = INIT;
         pvPut(scsStateSad);

         activeC = CAR_BUSY;
         pvPut(activeC);


         printf("startInit - turn off chop...");

         writeCommand(CHOP_OFF);

         chopSwitch = 0;
         pvPut(chopSwitch);

         chopIsOn = 0;
         printf("chopSwitch and chopIsOn are now 0\n");


         printf("startInit - turn off following...\n");

         followOn = OFF;


         printf("startInit - turn off guiding...\n");

         guideOn = OFF;

         guideSwitch = 0;
         pvPut(guideSwitch);
# 1568 "../scs_st.st"
         eventConfig.m2Power = ON;
         eventConfig.m2Servo = ON;




         epicsEventSignal(doPvLoad);

      } state loadFiles
   }

   state loadFiles
   {

      option +e;
      entry {
        printf("CADprocessor: loadFiles\n");
         printf("CADprocessor:loadFiles 10.0 second timer\n");
      }
      when(delay(3.0) && loadComplete == COMPLETE)
      {
         cadProcessorState = LOADFILES;
         pvPut(cadProcessorState);

         pvGet(initResponse);
         printf("state loadFiles ...initResponse is %d\n", initResponse);



         pvGet(scs0name);
         strncpy(instruments[0].name, scs0name, MAX_STRING_SIZE - 1);

         pvGet(scs0port);
         instruments[0].port = atoi(scs0port);

         pvGet(scs0capability);
         strncpy(instruments[0].capability, scs0capability, MAX_STRING_SIZE - 1);

         pvGet(ics0name);
         strncpy(instruments[1].name, ics0name, MAX_STRING_SIZE - 1);

         pvGet(ics0port);
         instruments[1].port = atoi(ics0port);

         pvGet(ics0capability);
         strncpy(instruments[1].capability, ics0capability, MAX_STRING_SIZE - 1);
         pvGet(ics1name);
         strncpy(instruments[2].name, ics1name, MAX_STRING_SIZE - 1);

         pvGet(ics1port);
         instruments[2].port = atoi(ics1port);

         pvGet(ics1capability);
         strncpy(instruments[2].capability, ics1capability, MAX_STRING_SIZE - 1);
         pvGet(ics2name);
         strncpy(instruments[3].name, ics2name, MAX_STRING_SIZE - 1);

         pvGet(ics2port);
         instruments[3].port = atoi(ics2port);

         pvGet(ics2capability);
         strncpy(instruments[3].capability, ics2capability, MAX_STRING_SIZE - 1);

         pvGet(ics3name);
         strncpy(instruments[4].name, ics3name, MAX_STRING_SIZE - 1);

         pvGet(ics3port);
         instruments[4].port = atoi(ics3port);

         pvGet(ics3capability);
         strncpy(instruments[4].capability, ics3capability, MAX_STRING_SIZE - 1);

         pvGet(ics4name);
         strncpy(instruments[5].name, ics4name, MAX_STRING_SIZE - 1);

         pvGet(ics4port);
         instruments[5].port = atoi(ics4port);

         pvGet(ics4capability);
         strncpy(instruments[5].capability, ics4capability, MAX_STRING_SIZE - 1);

         printf("instrument data loaded\n");

         strncpy(inst0, instruments[0].name, MAX_STRING_SIZE - 1);
         pvPut(inst0);

         strncpy(inst1, instruments[1].name, MAX_STRING_SIZE - 1);
         pvPut(inst1);

         strncpy(inst2, instruments[2].name, MAX_STRING_SIZE - 1);
         pvPut(inst2);

         strncpy(inst3, instruments[3].name, MAX_STRING_SIZE - 1);
         pvPut(inst3);

         strncpy(inst4, instruments[4].name, MAX_STRING_SIZE - 1);
         pvPut(inst4);

         strncpy(inst5, instruments[5].name, MAX_STRING_SIZE - 1);
         pvPut(inst5);



         pvGet(tiltSkew);
         pvGet(tiltOffsetX);
         pvGet(tiltOffsetY);

         pvGet(posSkew);
         pvGet(posOffsetX);
         pvGet(posOffsetY);

         pvGet(gaosSkew);
         pvGet(gaosOffsetX);
         pvGet(gaosOffsetY);

         pvGet(gyroSkew);
         pvGet(gyroOffsetX);
         pvGet(gyroOffsetY);

         pvGet(focusScaling);

         printf("CADProc:LF pre-frame\n");
         %{
            frame.tiltCosTheta = cos(tiltSkew * DEGS2RADS);
            frame.tiltSinTheta = sin(tiltSkew * DEGS2RADS);
            frame.tiltOffsetX = tiltOffsetX;
            frame.tiltOffsetY = tiltOffsetY;

            frame.posCosTheta = cos(posSkew * DEGS2RADS);
            frame.posSinTheta = sin(posSkew * DEGS2RADS);;
            frame.posOffsetX = posOffsetX;
            frame.posOffsetY = posOffsetY;

            frame.gaosCosTheta = cos(gaosSkew * DEGS2RADS);
            frame.gaosSinTheta = sin(gaosSkew * DEGS2RADS);;
            frame.gaosOffsetX = gaosOffsetX;
            frame.gaosOffsetY = gaosOffsetY;

            frame.gyroCosTheta = cos(gyroSkew * DEGS2RADS);
            frame.gyroSinTheta = sin(gyroSkew * DEGS2RADS);;
            frame.gyroOffsetX = gyroOffsetX;
            frame.gyroOffsetY = gyroOffsetY;

            frame.focusScaling = focusScaling;

            writeCommand(ACT_PWR_ON);


            writeCommand(MOFFLOFF);
            writeCommand(CMD_INIT);

         }%



         printf("CADProc:LF pre-setpoint\n");

         %{
             if (setPointFree)
             {

                epicsMutexLock(setPointFree);
                errlogPrintf(" moveXposition set to %f \n",moveXPosition);
                errlogPrintf(" moveYPosition set to %f \n",moveYPosition);

                setPoint.xTiltA = 0.0;
                setPoint.yTiltA = 0.0;
                setPoint.xTiltB = 0.0;
                setPoint.yTiltB = 0.0;
                setPoint.xTiltC = 0.0;
                setPoint.yTiltC = 0.0;
                setPoint.zFocus = 0.0;
                setPoint.xPosition = moveXPosition;
                setPoint.yPosition = moveYPosition;
                epicsMutexUnlock(setPointFree);
             }
             else
             {
                errorLog ("state startInit - couldn't obtain setPointFree mutex", 1, ON);
             }
         }%

         printf("CADProc:LF post-setpoint\n");
         pvGet(moveXInputPos);
         pvGet(moveYInputPos);
         pvGet(xyPosDeadband);

         printf("CADProc:LF pre-page0\n");

         %{
              if (refMemFree)
             {
                epicsMutexLock(refMemFree);

                scsBase->page0.AxTilt = 0.0;
                scsBase->page0.BxTilt = 0.0;
                scsBase->page0.CxTilt = 0.0;
                scsBase->page0.AyTilt = 0.0;
                scsBase->page0.ByTilt = 0.0;
                scsBase->page0.CyTilt = 0.0;
                scsBase->page0.xTiltGuide = 0.0;
                scsBase->page0.yTiltGuide = 0.0;
                scsBase->page0.zFocusGuide = 0.0;
                scsBase->page0.xDemand = moveXPosition;
                scsBase->page0.yDemand = moveYPosition;
                scsBase->page0.centralBaffle = 0;
                scsBase->page0.deployBaffle = 0;
                scsBase->page0.chopProfile = 0;
                scsBase->page0.chopFrequency = 0.0;
                scsBase->page0.chopDutyCycle = 0.0;
                scsBase->page0.xTiltTolerance = 0.0;
                scsBase->page0.yTiltTolerance = 0.0;
                scsBase->page0.zFocusTolerance = 0.0;
                scsBase->page0.xPositionTolerance = 0.0;
                scsBase->page0.yPositionTolerance = 0.0;
                scsBase->page0.bandwidth = 0.0;
                scsBase->page0.xTiltGain =0.0;
                scsBase->page0.yTiltGain = 0.0;
                scsBase->page0.zFocusGain = 0.0;
                scsBase->page0.xTiltShift = 0.0;
                scsBase->page0.yTiltShift = 0.0;
                scsBase->page0.zFocusShift = 0.0;
                scsBase->page0.xTiltSmooth = 0.0;
                scsBase->page0.yTiltSmooth = 0.0;
                scsBase->page0.zFocusSmooth = 0.0;
                scsBase->page0.xTcsMinRange = 0.0;
                scsBase->page0.yTcsMinRange = 0.0;
                scsBase->page0.xTcsMaxRange = 0.0;
                scsBase->page0.yTcsMaxRange = 0.0;
                scsBase->page0.xPMinRange = 0.0;
                scsBase->page0.yPMinRange = 0.0;
                scsBase->page0.xPMaxRange = 0.0;
                scsBase->page0.yPMaxRange = 0.0;
                scsBase->page0.follower = 0;
                scsBase->page0.foldir = 0;
                scsBase->page0.followersteps = 0;
                scsBase->page0.offloader = 0;
                scsBase->page0.ofldir = 0;
                scsBase->page0.offloadersteps = 0;
                scsBase->page0.cbafdir = 0;
                scsBase->page0.cbsteps = 0;
                scsBase->page0.deployable_baffle = 0;
                scsBase->page0.dbafdir = 0;
                scsBase->page0.dbsteps = 0;
                scsBase->page0.xy_motor = 0;
                scsBase->page0.xydir = 0;
                scsBase->page0.xysteps = 0;
                scsBase->page0.zFocus = 0.0;
                scsBase->page0.zGuide = 0.0;
                scsBase->page0.rawXGuide = 0.0;
                scsBase->page0.rawYGuide = 0.0;
                scsBase->page0.rawZGuide = 0.0;
                scsBase->page0.xGrossTiltDmd = 0.0;
                scsBase->page0.yGrossTiltDmd = 0.0;
                scsBase->page0.xyPositionDeadband = xyPosDeadband;

                epicsMutexUnlock(refMemFree);
              }
             else
             {
                errorLog ("state startInit - couldn't obtain refMemFree mutex", 1, ON);
             }
             }%

             printf("CADProc:LF post-page0\n");
             controller[FOCUS].sum = 0.0;
             controller[FOCUS].oldSum = 0.0;
             controller[FOCUS].oldError = 0.0;
             controller[XTILT].sum = 0.0;
             controller[XTILT].oldSum = 0.0;
             controller[XTILT].oldError = 0.0;
             controller[YTILT].sum = 0.0;
             controller[YTILT].oldSum = 0.0;
             controller[YTILT].oldError = 0.0;


             reportHealth(GOOD, "");
             puts("init - wait for init response: then wait 10 seconds...");


             strncpy(initCarMessIn, "M2 is initialising...", MAX_STRING_SIZE - 1);


         pvPut(initCarMessIn);
         pvGet(initResponse);

      } state waitForInitStart
   }

   state waitForInitStart
   {

      option +e;
      entry{
        printf("CADprocessor: waitForInitStart\n");
      }



      when( (initResponse == 1) && delay(10.0))
      {
         cadProcessorState = WAITINITRESPONSE;
         pvPut(cadProcessorState);

         puts("init start detected. wait 10.0 seconds");



         strncpy(initCarMessIn, "M2 is initialising...", MAX_STRING_SIZE - 1);
         pvPut(initCarMessIn);

         pvGet(initResponse);
      } state waitForInitCompletion



      when(delay(CMD_RESPONSE_TIMEOUT))
      {
         initCarErrIn = STATUS_ERROR;
         pvPut(initCarErrIn);

         puts("init - no response");
         strncpy(initCarMessIn, "M2 no response to init", MAX_STRING_SIZE - 1);
         pvPut(initCarMessIn);

         initCarIn = CAR_ERROR;
         pvPut(initCarIn);

      } state idle
   }

   state waitForInitCompletion
   {

      option +e;
      entry{
        printf("CADprocessor: waitForInitCompletion\n");
      }

      when((initResponse == 0) && delay(10.0 ))
      {
         pvGet(initResponse);
         printf("Init Complete ...initResponse is %d\n", initResponse);

         cadProcessorState = WAITINITCOMPLETE;
         pvPut(cadProcessorState);


         initCarIn = CAR_IDLE;
         pvPut(initCarIn);


         strncpy(initCarMessIn, "", MAX_STRING_SIZE - 1);
         pvPut(initCarMessIn);
         puts("BYPASS REDUNDANT STARTUP COMMANDS...");







         myscsState = SYSTEMIDLE;
         scsState = myscsState;
         pvPut(myscsState);

         puts("init push tolerance data and wait 6.0 seconds...");

         tolDir = 0;
         pvPut(tolDir);

         tolDir = 2;
         pvPut(tolDir);

         tolDir = 3;
         pvPut(tolDir);

         setCont = 0;
         pvPut(setCont);
         setCont = 2;
         pvPut(setCont);
         setCont = 3;
         pvPut(setCont);

         guideConfReset = 0;
         pvPut(guideConfReset);
         guideConfReset = 2;
         pvPut(guideConfReset);
         guideConfReset = 3;
         pvPut(guideConfReset);

      } state initCompleteStartMove

      when(delay(INIT_COMPLETE_TIMEOUT))
      {
         cadProcessorState = INITCOMPLETETIMEOUT;
         pvPut(cadProcessorState);

         initCarErrIn = STATUS_ERROR;
         pvPut(initCarErrIn);

         strncpy(initCarMessIn, "M2 did not finish init within 6 minutes",
               MAX_STRING_SIZE - 1);
         pvPut(initCarMessIn);

         initCarIn = CAR_ERROR;
         pvPut(initCarIn);

         writeCommand(ACT_PWR_ON);
         writeCommand(MOFFLON);
         writeCommand(VIBSTART);
         writeCommand(MSTART);


         myscsState = SYSTEMIDLE;
         scsState = myscsState;
         pvPut(myscsState);
# 1995 "../scs_st.st"
         puts(".DICTO");

         moveDir = 2;
         pvPut(moveDir);
         moveDir = 3;
         pvPut(moveDir);
      } state idle

   }

   state initCompleteStartMove
   {

      option +e;
      entry{
        printf("CADprocessor: initCompleteStartMove\n");
      }

      when (delay(18.0))
      {

         puts("...Finished INIT, moving to base");



         moveDir = 1;
         pvPut(moveDir);

         moveDir = 0;
         pvPut(moveDir);

         moveDir = 2;
         pvPut(moveDir);

         moveDir = 3;
         pvPut(moveDir);


         pvGet(moveAXTilt);
         pvGet(moveAYTilt);
         pvGet(moveBXTilt);
         pvGet(moveBYTilt);
         pvGet(moveCXTilt);
         pvGet(moveCYTilt);
         pvGet(moveZFocus);
         pvGet(moveXPosition);
         pvGet(moveYPosition);
         pvGet(moveXInputPos);
         pvGet(moveYInputPos);
         pvGet(xyPosDeadband);



         xTiltAdef = moveAXTilt;
         yTiltAdef = moveAYTilt;
         xTiltBdef = moveBXTilt;
         yTiltBdef = moveBYTilt;
         xTiltCdef = moveCXTilt;
         yTiltCdef = moveCYTilt;
         zFocusDef = moveZFocus;
         xPosDef = moveXPosition;
         yPosDef = moveYPosition;
         xPosTcsDef = moveXInputPos;
         yPosTcsDef = moveYInputPos;
         xyDeadband = xyPosDeadband;
         printf(" xTiltAdef %f \n",xTiltAdef);
         printf(" yTiltAdef %f \n",yTiltAdef);
         printf(" xPosDef %f \n",xPosDef);
         printf(" yPosDef %f \n",yPosDef);
         printf(" xPosTcsDef %f \n",xPosTcsDef);
         printf(" yPosTcsDef %f \n",yPosTcsDef);
         printf(" xyDeadband %f \n",xyDeadband);
# 2078 "../scs_st.st"
         pidDir = 0;
         pvPut(pidDir);
         pidDir = 2;
         pvPut(pidDir);
         pidDir = 3;
         pvPut(pidDir);



        vtkXDir = 2;
        pvPut(vtkXDir);
        vtkXDir = 3;
        pvPut(vtkXDir);

        vtkYDir = 2;
        pvPut(vtkYDir);
        vtkYDir = 3;
        pvPut(vtkYDir);



        phasorXDir = 2;
        pvPut(phasorXDir);
        phasorXDir = 3;
        pvPut(phasorXDir);


        phasorYDir = 2;
        pvPut(phasorYDir);
        phasorYDir = 3;
        pvPut(phasorYDir);

      } state idle
   }
# 2142 "../scs_st.st"
   state startInitXY
   {

      option +e;
      entry{
        printf("CADprocessor: startInitXY\n");
      }

      when()
      {
         errorLog("state startInitXY...", 1, ON);
         myscsState = INITIALISING;
         scsState = myscsState;
         pvPut(myscsState);

         cadProcessorState = STARTINIT;
         pvPut(cadProcessorState);

         scsStateSad = INIT;
         pvPut(scsStateSad);


         writeCommand(CHOP_OFF);

         chopSwitch = 0;
         pvPut(chopSwitch);

         chopIsOn = 0;



         followOn = OFF;



         guideOn = OFF;

         guideSwitch = 0;
         pvPut(guideSwitch);



         writeCommand(ACT_PWR_ON);

      } state loadFilesXY
   }

   state loadFilesXY
   {

      option +e;
      entry{
        printf("CADprocessor: loadFilesXY\n");
      }

      when()
      {
         cadProcessorState = LOADFILES;
         pvPut(cadProcessorState);


         printf("sending command : CMD_XYINIT \n");
         writeCommand(CMD_XYINIT);


%{
         if (setPointFree)
         {
            epicsMutexLock(setPointFree);
            setPoint.xPosition = 0.0;
            setPoint.yPosition = 0.0;
            epicsMutexUnlock(setPointFree);
         }
         else
         {
            errorLog ("state startInitXY - couldn't obtain setPointFree mutex", 1, ON);
         }

         if (refMemFree)
         {
            epicsMutexLock(refMemFree);
            scsBase->page0.xDemand = moveXPosition;
            scsBase->page0.yDemand = moveYPosition;
            scsBase->page0.xPositionTolerance = 0.0;
            scsBase->page0.yPositionTolerance = 0.0;
            scsBase->page0.xTcsMinRange = 0.0;
            scsBase->page0.yTcsMinRange = 0.0;
            scsBase->page0.xTcsMaxRange = 0.0;
            scsBase->page0.yTcsMaxRange = 0.0;
            scsBase->page0.xPMinRange = 0.0;
            scsBase->page0.yPMinRange = 0.0;
            scsBase->page0.xPMaxRange = 0.0;
            scsBase->page0.yPMaxRange = 0.0;
            scsBase->page0.xy_motor = 0;
            scsBase->page0.xydir = 0;
            scsBase->page0.xysteps = 0;
            scsBase->page0.xyPositionDeadband = xyPosDeadband;

            epicsMutexUnlock(refMemFree);
         }
         else
         {
            errorLog ("state startInitXY - couldn't obtain refMemFree mutex", 1, ON);
         }
}%



         reportHealth(GOOD, "");



         strncpy(initXYCarMessIn, "M2 XY Positioner is initialising...", MAX_STRING_SIZE - 1)
            ;
         pvPut(initXYCarMessIn);


      } state waitForInitStartXY
   }

   state waitForInitStartXY
   {

      option +e;
      entry{
        printf("CADprocessor: waitForInitStartXY\n");
      }



      when(initResponse == 1)
      {
         cadProcessorState = WAITINITRESPONSE;
         pvPut(cadProcessorState);

         puts("init XY start detected");



         strncpy(initXYCarMessIn, "M2 XY Positioner is initialising...", MAX_STRING_SIZE - 1);
         pvPut(initXYCarMessIn);

      } state waitForInitCompletionXY



      when(delay(CMD_RESPONSE_TIMEOUT))
      {
         initXYCarErrIn = STATUS_ERROR;
         pvPut(initXYCarErrIn);

         puts("init - no response");
         strncpy(initXYCarMessIn, "M2 no response to init XY Positioner", MAX_STRING_SIZE - 1);
         pvPut(initXYCarMessIn);

         initXYCarIn = CAR_ERROR;
         pvPut(initXYCarIn);

      } state idle
   }

   state waitForInitCompletionXY
   {

      option +e;
      entry{
        printf("CADprocessor: waitForInitCompletionXY\n");
      }

      when(initResponse == 0)
      {
         cadProcessorState = WAITINITCOMPLETE;
         pvPut(cadProcessorState);

         puts("init completion detected");



         initXYCarIn = CAR_IDLE;
         pvPut(initXYCarIn);



         strncpy(initXYCarMessIn, "", MAX_STRING_SIZE - 1);
         pvPut(initXYCarMessIn);

         myscsState = SYSTEMIDLE;
         scsState = myscsState;
         pvPut(myscsState);


         printf(" xPosTcsDef %f \n",xPosTcsDef);
         printf(" yPosTcsDef %f \n",yPosTcsDef);

         moveXInputPos = xPosTcsDef;
         moveYInputPos = yPosTcsDef;
         pvPut(moveXInputPos);
         pvPut(moveYInputPos);

         moveDir = 2;
         pvPut(moveDir);
         moveDir = 3;
         pvPut(moveDir);

      } state idle

      when(delay(INIT_COMPLETE_TIMEOUT))
      {
         cadProcessorState = INITCOMPLETETIMEOUT;
         pvPut(cadProcessorState);

         initXYCarErrIn = STATUS_ERROR;
         pvPut(initXYCarErrIn);

         strncpy(initXYCarMessIn, "M2 XY Positioner did not finish init within 6 minutes", MAX_STRING_SIZE - 1);
         pvPut(initXYCarMessIn);

         initXYCarIn = CAR_ERROR;
         pvPut(initXYCarIn);

         myscsState = SYSTEMIDLE;
         scsState = myscsState;
         pvPut(myscsState);






      } state idle
   }
# 2406 "../scs_st.st"
   state startMove
   {

      option +e;
      entry{
        printf("CADprocessor: startMove\n");
      }

      when()
      {
         printf("Start Move - \n");
         cadProcessorState = STARTMOVE;
         pvPut(cadProcessorState);

         writeCommand(ACT_PWR_ON);
         writeCommand(MEND);
         writeCommand(VEND);
         writeCommand(MOFFLON);


      } state proceedWithMove
   }

   state proceedWithMove
   {

      option +e;
      entry{
        printf("CADprocessor: proceedWithMove\n");
      }

      when(servoOnStat == 0)
      {
         printf("mirror control disabled - proceed with move\n");

         myscsState = MOVING;
         scsState = myscsState;
         pvPut(myscsState);

         cadProcessorState = PROCEEDWITHMOVE;
         pvPut(cadProcessorState);

         followOn = OFF;



         pvGet(moveAXTilt);
         pvGet(moveAYTilt);
         pvGet(moveBXTilt);
         pvGet(moveBYTilt);
         pvGet(moveCXTilt);
         pvGet(moveCYTilt);
         pvGet(moveZFocus);
         pvGet(moveXPosition);
         pvGet(moveYPosition);


         currFocus = scsPtr->page1.zFocus;
         printf ("proceedWithMove - currFocus %f moveZFocus %f\n",currFocus,moveZFocus);
         if( (abs(currFocus-moveZFocus)) > 1200 )
         {
            errorLog ("receiveTcsDemand - Z Demand Out of Limit", 1, ON);
         }


%{
         if(setPointFree)
         {
            epicsMutexLock(setPointFree);
            printf("proceedWithMove - setPointFree taken\n");
          setPoint.xTiltA = moveAXTilt;
            setPoint.yTiltA = moveAYTilt;
            setPoint.xTiltB = moveBXTilt;
            setPoint.yTiltB = moveBYTilt;
            setPoint.xTiltC = moveCXTilt;
            setPoint.yTiltC = moveCYTilt;
            setPoint.zFocus = moveZFocus;
            setPoint.xPosition = moveXPosition;
            setPoint.yPosition = moveYPosition;

            epicsMutexUnlock(setPointFree);
         }
         else
         {
            errorLog("state startMove - couldn't obtain setPointFree mutex", 1, ON);
         }
         printf("proceedWithMove - setPointFree released\n");
  servoInPosition = 0;
}%
      } state moveWaitForCoincidence

      when(delay(SERVO_OFF_TIMEOUT))


      {
         cadProcessorState = SERVOOFFTIMEOUT;
         pvPut(cadProcessorState);

         printf("proceedWithMove - Servo off timeout n");
         errorLog
            ("proceedWithMove - M2 system not switching servos off",
             1, ON);

         moveCarErrIn = STATUS_ERROR;
         pvPut(moveCarErrIn);

         strncpy(moveCarMessIn,
               "M2 not switching mirror control off", MAX_STRING_SIZE - 1);
         pvPut(moveCarMessIn);

         moveCarIn = CAR_ERROR;
         pvPut(moveCarIn);

      } state idle
   }

   state moveWaitForCoincidence
   {

      option +e;
      entry{
        printf("CADprocessor: moveWaitForCoincidence\n");
      }





      when(delay(10.0) && (servoInPosition == 1) && ( XYmovingStatus == 0 ))
      {
         cadProcessorState = MOVEWAITFORCOINCIDENCE;
         pvPut(cadProcessorState);

         printf("in close range - turning on mirror control \n");

         writeCommand(VIBSTART);
         writeCommand(MSTART);



         moveCarIn = CAR_IDLE;
         pvPut(moveCarIn);



         strncpy(moveCarMessIn, "", MAX_STRING_SIZE - 1);
         pvPut(moveCarMessIn);

      } state idle

      when(delay(MOVE_TIMEOUT))
      {
         cadProcessorState = MOVETIMEOUTFORCOINCIDENCE;
         pvPut(cadProcessorState);

         printf("startMove - timeout on in position\n");
         errorLog("startMove - M2 system not achieving coincidence in time", 1, ON);

         moveCarErrIn = STATUS_ERROR;
         pvPut(moveCarErrIn);

         strncpy(moveCarMessIn, "M2 failed to achieve coincidence", MAX_STRING_SIZE - 1);
         pvPut(moveCarMessIn);

         moveCarIn = CAR_ERROR;
         pvPut(moveCarIn);

      } state idle
   }
# 2605 "../scs_st.st"
   state startActuator
   {

      option +e;
      entry{
        printf("CADprocessor: startActuator\n");
      }

      when()
      {
         cadProcessorState = STARTACTUATOR;
         pvPut(cadProcessorState);

         writeCommand(ACT_PWR_ON);
         writeCommand(MEND);
         writeCommand(VEND);
         writeCommand(MOFFLON);


      } state proceedWithActMove
   }

   state proceedWithActMove
   {

      option +e;
      entry{
        printf("CADprocessor: proceedWithActMove\n");
      }

      when(servoOnStat == 0)
      {
         printf("mirror control disabled - proceed with move\n");

         myscsState = MOVING;
         scsState = myscsState;
         pvPut(myscsState);

         cadProcessorState = PROCEEDWITHACTMOVE;
         pvPut(cadProcessorState);

         followOn = OFF;

         pvGet(actXTilt);
         pvGet(actYTilt);
         pvGet(actZFocus);
%{
         if(setPointFree)
         {
            epicsMutexLock(setPointFree);
            setPoint.xTiltA = actXTilt;
            setPoint.yTiltA = actYTilt;
            setPoint.zFocus = actZFocus;

            epicsMutexUnlock(setPointFree);
         }
         else
         {
            errorLog("state startActuator - couldn't obtain setPointFree mutex", 1, ON);
         }
}%

      } state actuatorWaitForCoincidence

      when(delay(SERVO_OFF_TIMEOUT))


      {

         cadProcessorState = ACTUATORSERVOOFFTIMEOUT;
         pvPut(cadProcessorState);

         printf("proceedWithActMove - Servo off timeout n");
         errorLog
            ("proceedWithActMove - M2 system not switching sevos off",
             1, ON);

         actuatorCarErrIn = STATUS_ERROR;
         pvPut(actuatorCarErrIn);

         strncpy(actuatorCarMessIn,
               "M2 not switching mirror control off", MAX_STRING_SIZE - 1);
         pvPut(actuatorCarMessIn);

         actuatorCarIn = CAR_ERROR;
         pvPut(actuatorCarIn);

      } state idle
   }

   state actuatorWaitForCoincidence
   {

      option +e;
      entry{
        printf("CADprocessor: actuatorWaitForCoincidence\n");
      }





      when(delay(3.0) && (servoInPosition == 1))
      {
         cadProcessorState = ACTUATORWAITFORCOINCIDENCE;
         pvPut(cadProcessorState);

         printf("in close range - turning on mirror control\n");

         writeCommand(VIBSTART);
         writeCommand(MSTART);



         actuatorCarIn = CAR_IDLE;
         pvPut(actuatorCarIn);



         strncpy(actuatorCarMessIn, "", MAX_STRING_SIZE - 1);
         pvPut(actuatorCarMessIn);

      } state idle

      when(delay(TIMEOUT))
      {
         cadProcessorState = ACTUATORTIMEOUTFORCOINCIDENCE;
         pvPut(cadProcessorState);

         actuatorCarErrIn = STATUS_ERROR;
         pvPut(actuatorCarErrIn);

         strncpy(actuatorCarMessIn, "M2 failed to achieve coincidence", MAX_STRING_SIZE - 1);
         pvPut(actuatorCarMessIn);

         actuatorCarIn = CAR_ERROR;
         pvPut(actuatorCarIn);

      } state idle
   }
# 2777 "../scs_st.st"
   state startFollow
   {

      option +e;
      entry{
        printf("CADprocessor: startFollow\n");
      }

      when()
      {
         cadProcessorState = STARTFOLLOW;
         pvPut(cadProcessorState);

         writeCommand(ACT_PWR_ON);
         writeCommand(MEND);
         writeCommand(VEND);
         writeCommand(MOFFLON);

         printf("wait for mirror control to disable\n");

      } state proceedWithFollow
   }




   state proceedWithFollow
   {

      option +e;
      entry{
        printf("CADprocessor: proceedWithFollow\n");
      }

      when(servoOnStat == 0)
      {
         printf("mirror control disabled - proceed with move\n");

         myscsState = MOVING;
         scsState = myscsState;
         pvPut(myscsState);

         cadProcessorState = PROCEEDWITHFOLLOW;
         pvPut(cadProcessorState);

         followOn = ON;



         resetFirstFollowDemand();

         servoInPosition = 0;

      } state waitForCoincidence

      when(delay(SERVO_OFF_TIMEOUT))


      {
         cadProcessorState = FOLLOWSERVOTIMEOUT;
         pvPut(cadProcessorState);

         printf("proceedWithFollow - Servo off timeout n");
         errorLog( "proceedWithFollow - M2 system not switching sevos off",
               1, ON);

         followCarErrIn = STATUS_ERROR;
         pvPut(followCarErrIn);

         strncpy(followCarMessIn,
               "M2 not switching mirror control off", MAX_STRING_SIZE - 1);
         pvPut(followCarMessIn);

         followCarIn = CAR_ERROR;
         pvPut(followCarIn);

      } state idle
   }

   state waitForCoincidence
   {

      option +e;
      entry{
        printf("CADprocessor: waitForCoincidence\n");
      }
# 2877 "../scs_st.st"
      when(delay(10.0) && (servoInPosition == 1))
      {
         cadProcessorState = FOLLOWWAITFORCOINCIDENCE;
         pvPut(cadProcessorState);

         printf("in close range - turning on mirror control\n");

         writeCommand(VIBSTART);
         writeCommand(MSTART);



         followCarIn = CAR_IDLE;
         pvPut(followCarIn);



         strncpy(followCarMessIn, "", MAX_STRING_SIZE - 1);
         pvPut(followCarMessIn);

         followOn = ON;






      } state idle

      when(delay(TIMEOUT))
      {
         cadProcessorState = FOLLOWWAITFORCOINCIDENCE;
         pvPut(cadProcessorState);

         printf("in close range - turning on mirror control\n");

         writeCommand(VIBSTART);
         writeCommand(MSTART);



         followCarIn = CAR_IDLE;
         pvPut(followCarIn);



         strncpy(followCarMessIn, "", MAX_STRING_SIZE - 1);
         pvPut(followCarMessIn);

         followOn = ON;
# 2943 "../scs_st.st"
      } state idle
   }
# 2974 "../scs_st.st"
   state startStop
   {

      option +e;
      entry{
        printf("CADprocessor: startStop\n");
      }

      when()
      {
         myscsState = MOVING;
         scsState = myscsState;
         pvPut(myscsState);

         cadProcessorState = STARTSTOP;
         pvPut(cadProcessorState);



         writeCommand(CHOP_OFF);

         chopIsOn = 0;



         followOn = OFF;



         guideOn = OFF;

         strncpy(stopCarMessIn, "", MAX_STRING_SIZE - 1);
         pvPut(stopCarMessIn);



         stopCarIn = CAR_IDLE;




         strncpy(stopCarMessIn, "", MAX_STRING_SIZE - 1);
         pvPut(stopCarMessIn);

      } state idle
   }
# 3048 "../scs_st.st"
   state startPark
   {

      option +e;
      entry{
        printf("CADprocessor: startPark\n");
      }

      when()
      {
         cadProcessorState = STARTPARK;
         pvPut(cadProcessorState);


         parkCarIn = CAR_BUSY;
         pvPut(parkCarIn);



         writeCommand(DECS_OFF);

         writeCommand(CHOP_OFF);

         chopIsOn = 0;



         guideOn = OFF;



         followOn = OFF;

         writeCommand(ACT_PWR_ON);
         writeCommand(MEND);
         writeCommand(VEND);
         writeCommand(MOFFLON);


        vtkXCtrl = 0;
        vtkYCtrl = 0;
        pvPut(vtkXCtrl);
        pvPut(vtkYCtrl);

        vtkXCtrlDir = 2;
        pvPut(vtkXCtrlDir);
        vtkXCtrlDir = 3;
        pvPut(vtkXCtrlDir);

        vtkYCtrlDir = 2;
        pvPut(vtkYCtrlDir);
        vtkYCtrlDir = 3;
        pvPut(vtkYCtrlDir);

      } state proceedWithPark
   }

   state proceedWithPark
   {

      option +e;
      entry{
        printf("CADprocessor: proceedWithPark\n");
      }

      when(servoOnStat == 0)
      {
         printf("mirror control disable - proceed with move\n");

         myscsState = PARKED;
         scsState = myscsState;
         pvPut(myscsState);



         parkPosition.xTilt = xTiltAdef;
         parkPosition.yTilt = yTiltAdef;
         parkPosition.zFocus = zFocusDef;
         parkPosition.xPos = xPosDef;
         parkPosition.yPos = yPosDef;



         printf(" xTiltA %f \n",xTiltAdef);
         printf(" yTiltA %f \n",yTiltAdef);
         printf(" zfocus %f \n",zFocusDef);
         printf(" xPos %f \n",xPosDef);
         printf(" yPos %f \n",yPosDef);

%{
         if(setPointFree)
         {
            epicsMutexLock(setPointFree);
            setPoint.xTiltA = parkPosition.xTilt;
            setPoint.yTiltA = parkPosition.yTilt;
            setPoint.zFocus = parkPosition.zFocus;
            setPoint.xTiltB = 0.0;
            setPoint.yTiltB = 0.0;
            setPoint.xTiltC = 0.0;
            setPoint.yTiltC = 0.0;
            setPoint.xPosition = parkPosition.xPos;
            setPoint.yPosition = parkPosition.yPos;

            epicsMutexUnlock(setPointFree);
         }
         else
         {
            errorLog("state proceedWithPark - couldn't obtain setPointFree mutex", 1, ON);
         }
}%
      } state parkWaitForCoincidence

      when(delay(SERVO_OFF_TIMEOUT))


      {
         cadProcessorState = SERVOOFFTIMEOUT;
         pvPut(cadProcessorState);

         printf("proceedWithPark - Servo off timeout n");
         errorLog
            ("proceedWithPark - M2 system not switching sevos off",
             1, ON);

         parkCarErrIn = STATUS_ERROR;
         pvPut(parkCarErrIn);
         strncpy(parkCarMessIn,
               "M2 not switching mirror control off", MAX_STRING_SIZE - 1);
         pvPut(parkCarMessIn);

      } state idle
   }

   state parkWaitForCoincidence
   {

      option +e;
      entry{
        printf("CADprocessor: parkWaitForCoincidence\n");
      }



      when(delay(10.0) && (servoInPosition == 1) && ( XYmovingStatus == 0 ))
      {
         cadProcessorState = PARKWAITFORCOINCIDENCE;
         pvPut(cadProcessorState);

         writeCommand(VEND);
         writeCommand(MEND);



         parkCarIn = CAR_IDLE;
         pvPut(parkCarIn);
         strncpy(parkCarMessIn, "", MAX_STRING_SIZE - 1);

      } state idle


      when(delay(PARK_TIMEOUT))
      {
         cadProcessorState = TIMEOUTWAITFORPARK;
         pvPut(cadProcessorState);

         parkCarErrIn = STATUS_ERROR;
         pvPut(parkCarErrIn);

         strncpy(parkCarMessIn, "No response to park command", MAX_STRING_SIZE - 1);
         pvPut(parkCarMessIn);

         parkCarIn = CAR_ERROR;
         pvPut(parkCarIn);

      } state idle
   }
# 3250 "../scs_st.st"
   state startChopControl
   {

      option +e;
      entry{
        printf("CADprocessor: startChopControl\n");
      }


      when()
      {
         cadProcessorState = STARTCHOPCONTROL;
         pvPut(cadProcessorState);



         pvGet(syncSource);
         pvGet(profile);

         pvGet(dutyCycle);
         pvGet(chopOn);
         pvGet(decsOn);
         pvGet(decsPause);
         pvGet(decsFreeze);
         pvGet(decsReset);
         if(chopIsOn)
         {
            if(chopOn == 1)
            {
               strncpy(chopControlCarMessIn, "Already Chopping",MAX_STRING_SIZE - 1);
               pvPut(chopControlCarMessIn);
            }
            else
            {
               writeCommand(CHOP_OFF);
               chopIsOn = 0;
               if (eventConfig.change == 0)
               {
                  eventConfig.change = 1;
                  if (eventConfig.on != chopOn)
                  {
                     eventConfig.onChange = 1;
                  }

                  eventConfig.on = chopOn;
                  eventConfig.profile = profile;

               }
               else
               {
                  errorLog("startChopControl - chop mode change not acknowledged by event system", 1, ON);
               }
               writeCommand(CHOP_OFF);
               epicsEventSignal(eventSem);
            }

         }
         else
         {







            if(decsOn == 0)
            {


            }

            if(chopOn == 1)
            {


               jogBeam = BEAMA;
# 3335 "../scs_st.st"
               chopIsPending = 1;
               decsIsPending = 1;
            }
            else
            {
# 3348 "../scs_st.st"
               writeCommand(CHOP_OFF);


               chopIsOn = 0;
            }

            if (decsOn == 1)
            {
               if (!chopIsPending)
               {


               }
               else
               {

                  decsIsPending = 1;
               }
            }

            if(decsPause == 1)
            {
               writeCommand(DECS_PAUSE);

            }
            else
            {
               writeCommand(DECS_CONTINUE);

            }

            if(decsFreeze == 1)
            {
               writeCommand(DECS_FREEZE);

            }
            else
            {
               writeCommand(DECS_UNFREEZE);

            }

            if(decsReset == 1)
            {
               writeCommand(DECS_ZERO);

            }







            if (eventConfig.change == 0)
            {


               eventConfig.change = 1;
# 3418 "../scs_st.st"
               if (eventConfig.on != chopOn)
               {
                  eventConfig.onChange = 1;
               }

               eventConfig.on = chopOn;
               eventConfig.profile = profile;

               if (syncSource == 0)
               {
                  eventConfig.drive = LMMS;

               }
               else
               {
                  eventConfig.drive = INST;

               }

               eventConfig.source = instruments[syncSource].port;




               if(!strcmp(instruments[syncSource].capability, "ONELINE"))
                  eventConfig.capability = ONELINE;
               else if(!strcmp(instruments[syncSource].capability, "TWOLINE"))
                  eventConfig.capability = TWOLINE;
               else if(!strcmp(instruments[syncSource].capability, "ONESHOT"))
                  eventConfig.capability = ONESHOT;
               else
                  eventConfig.capability = STROBE;


            }
            else
            {
               errorLog("startChopControl - chop mode change not acknowledged by event system", 1, ON);
            }



            if(chopOn == 1)
            {
               chopIsOn = ON;
            }
            else
            {
               chopIsOn = OFF;
            }

            epicsEventSignal(eventSem);
         }

      } state waitForChopResponse
   }

   state waitForChopResponse
   {

      option +e;
      entry{
        printf("CADprocessor: waitForChopResponse\n");
      }



      when(chopResponse == 1 && chopOn == 1)
      {
         m2ChopResponseOK = 1;


         cadProcessorState = WAITFORCHOPRESPONSE;
         pvPut(cadProcessorState);



         chopControlCarIn = CAR_IDLE;
         pvPut(chopControlCarIn);

         strncpy(chopControlCarMessIn, "", MAX_STRING_SIZE - 1);
         pvPut(chopControlCarMessIn);

      } state idle

      when(chopResponse == 0 && chopOn == 0)
      {
         m2ChopResponseOK = 0;

         myscsState = MOVING;
         scsState = myscsState;
         pvPut(myscsState);

         cadProcessorState = WAITFORCHOPRESPONSE;
         pvPut(cadProcessorState);



         chopControlCarIn = CAR_IDLE;
         pvPut(chopControlCarIn);

         strncpy(chopControlCarMessIn, "", MAX_STRING_SIZE - 1);
         pvPut(chopControlCarMessIn);

         chopConfigDir = 3;
         pvPut(chopConfigDir);

      } state idle

      when(delay(CHOP_TIMEOUT))
      {


         cadProcessorState = TIMEOUTWAITFORCHOPRESPONSE;
         pvPut(cadProcessorState);

         chopControlCarErrIn = STATUS_ERROR;
         pvPut(chopControlCarErrIn);

         strncpy(chopControlCarMessIn, "M2 no response to chop on/off command", MAX_STRING_SIZE - 1);
         pvPut(chopControlCarMessIn);

         chopControlCarIn = CAR_ERROR;
         pvPut(chopControlCarIn);

      } state idle
   }
# 3570 "../scs_st.st"
   state startBandwidth
   {

      option +e;
      entry{
        printf("CADprocessor: startBandwith\n");
      }

      when()
      {
         cadProcessorState = STARTBANDWITH;
         pvPut(cadProcessorState);

         pvGet(bandwidth);
%{
            if(refMemFree)
            {
               epicsMutexLock(refMemFree);
               scsPtr->page0.bandwidth = bandwidth;
               epicsMutexUnlock(refMemFree);
            }
            else
            {
               errorLog("state startBandwidth - couldn't obtain refMemFree mutex", 1, ON);
            }
}%
         writeCommand(BANDWIDTH_CHANGE);

         strncpy(bandwidthCarMessIn, "", MAX_STRING_SIZE - 1);
         pvPut(bandwidthCarMessIn);

      } state idle
   }
# 3611 "../scs_st.st"
   state startVtkChange
   {

        when()
        {

            vtkXScale = guideInfo.vtkXdata[0];
            vtkXAngle = guideInfo.vtkXdata[1];
            vtkXSampleRate = guideInfo.vtkXdata[2];
            pvPut(vtkXScale);
            pvPut(vtkXAngle);
            pvPut(vtkXSampleRate);

            vtkYScale = guideInfo.vtkYdata[0];
            vtkYAngle = guideInfo.vtkYdata[1];
            vtkYSampleRate = guideInfo.vtkYdata[2];
            pvPut(vtkYScale);
            pvPut(vtkYAngle);
            pvPut(vtkYSampleRate);

        } state idle
   }
# 3644 "../scs_st.st"
   state startGuideSimChange {

      option +e;
      entry{
        printf("CADprocessor: startGuideSimChange\n");
      }

      when() {

         if (guideSimStart == myOldGuideSimState){
            puts("guideSim no state change");
         }

         else if(guideSimStart == 1) {
            myOldGuideSimState = 1;

            tiltPidOnSim = 0;
            pvPut(tiltPidOnSim);

            tiltpidDir = 2;
            pvPut(tiltpidDir);

            tiltpidDir = 3;
            pvPut(tiltpidDir);

            focusPidOnSim = 0;
            pvPut(focusPidOnSim);

            focuspidDir = 2;
            pvPut(focuspidDir);

            focuspidDir = 3;
            pvPut(focuspidDir);

            startGuideSim();
         }

         else
         {
            myOldGuideSimState = 0;

            tiltPidOnSim = 1;
            pvPut(tiltPidOnSim);

            tiltpidDir = 2;
            pvPut(tiltpidDir);

            tiltpidDir = 3;
            pvPut(tiltpidDir);

            focusPidOnSim = 1;
            pvPut(focusPidOnSim);

            focuspidDir = 2;
            pvPut(focuspidDir);

            focuspidDir = 3;
            pvPut(focuspidDir);

            endGuideSim();
         }

      } state idle
   }
# 3732 "../scs_st.st"
   state startTolerance {

      option +e;
      entry{
        printf("CADprocessor: startTolerance\n");
      }

      when() {
         cadProcessorState = STARTTOLERANCE;
         pvPut(cadProcessorState);





         pvGet(xTiltTol);
         pvGet(yTiltTol);
         pvGet(zFocusTol);
         pvGet(xPosTol);
         pvGet(yPosTol);
         pvGet(xyPosDeadband);
%{
            if(refMemFree)
            {
               epicsMutexLock(refMemFree);
               scsPtr->page0.xTiltTolerance = (float) xTiltTol;
               scsPtr->page0.yTiltTolerance = (float) yTiltTol;
               scsPtr->page0.zFocusTolerance = (float) zFocusTol;
               scsPtr->page0.xPositionTolerance = (float) xPosTol;
               scsPtr->page0.yPositionTolerance = (float) yPosTol;
               scsPtr->page0.xyPositionDeadband = (float) xyPosDeadband;
               epicsMutexUnlock(refMemFree);
            }
            else
            {
               errorLog("state startTolerance - couldn't obtain refMemFree mutex", 1, ON);
            }

         writeCommand(TOLERANCE_CHANGE);
         writeCommand(XY_DEADBAND_CHANGE);
}%

         strncpy(toleranceCarMessIn, "", MAX_STRING_SIZE - 1);
         pvPut(toleranceCarMessIn);

         printf("Registered default tolerances with CEM:\n");
         printf("  xTiltTolerance:   %f\n", xTiltTol);
         printf("  yTiltTolerance:   %f\n", yTiltTol);
         printf("  zFocusTolerance:  %f\n", zFocusTol);
         printf("  xPosTolerance:    %f\n", xPosTol);
         printf("  yPosTolerance:    %f\n", yPosTol);
         printf("  xyDeadbandTol:    %f\n", xyPosDeadband);

      } state idle
   }
}
# 3832 "../scs_st.st"
ss followDemandProcessing {
   state init {
      when() {
         followDemandState = FOLDEMANDENTRY;
         pvPut(followDemandState);

      } state waitForDemand
   }

   state waitForDemand {
      when(efTest(newBeamA) && (followOn == ON)) {
         followDemandState = WAITFORDEMAND;
         pvPut(followDemandState);

         efClear(newBeamA);


         if(tcs.trackId != currentId && followOn) {
            currentId = tcs.trackId;
            activeC = CAR_BUSY;
            pvPut(activeC);

         }

      } state waitForNextCoincidence
   }

   state waitForNextCoincidence {
      when(delay(0.1) && coincidence == ENABLED) {
         followDemandState = WAITFORNEXTCOINCIDENCE;
         pvPut(followDemandState);

         activeC = CAR_IDLE;
         pvPut(activeC);

      } state waitForDemand

      when(delay(TIMEOUT)) {
         followDemandState = TIMEOUTWAITFORNEXTCOINCIDENCE;
         pvPut(followDemandState);




      } state waitForDemand
   }
}
# 3913 "../scs_st.st"
ss monitorSad {
   state initMS {
      when() {
         monitorSadState = MONSADENTRY;
         pvPut(monitorSadState);

      } state updateSad
   }

   state updateSad {
      when(delay(3.0)) {
         monitorSadState = UPDATESAD;
         pvPut(monitorSadState);

         %{
         if(refMemFree) {

            epicsMutexLock(refMemFree);
            if(scsPtr->page1.inPosition != 0 || followOn || guideOn)
               strncpy(inPositionSad, "TRUE", MAX_STRING_SIZE - 1);
            else
               strncpy(inPositionSad, "FALSE", MAX_STRING_SIZE - 1);
# 3943 "../scs_st.st"
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
            errlogPrintf("updateSad - refMemFree timeout\n");
         }
         }%

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

         for(source = 0; source < 5; source++) {
            pvPut(x[source]);
            pvPut(y[source]);
            pvPut(z[source]);
            pvPut(xerr[source]);
            pvPut(yerr[source]);
            pvPut(zerr[source]);
         }

      } state updateSad







      when(checkBaffleFlag) {
      } state checkBaffle

    }

    state checkBaffle {

      option +e;
      option -t;

      entry{
        errlogPrintf("checkBaffle enter: dbafpos=%ld\n",scsPtr->page1.deployBaffle);
      }


      when (scsPtr->page0.deployBaffle == scsPtr->page1.deployBaffle) {
          checkBaffleFlag = 0;
      } state updateSad

      when (delay(4)) {


        if ( scsPtr->page1.deployBaffle >= 0) {

            errlogPrintf("checkBaffle: Failed to move when commanded. Try again.\n");
            writeCommand(BAFFLE_CHANGE);
        }


        else {
          checkBaffleFlag = 0;
        }

      } state updateSad

      exit {
        errlogPrintf("checkBaffle exit: dbafpos=%ld\n",scsPtr->page1.deployBaffle);
      }
    }

}
# 4150 "../scs_st.st"
ss monitorProcess {
   state updateParameters {
      when(delay(0.3)) {
         monitorProcessState = UPDATEPARAMETERS;
         pvPut(monitorProcessState);

         %{
         if(refMemFree) {
            epicsMutexLock(refMemFree);

            coincidence = !scsPtr->page1.inPosition;
            epicsMutexUnlock(refMemFree);
         }
         else {
            errorLog ("updateParameters - refMemFree timeout", 1, ON);
         }
         }%

         pvPut(coincidence);

      } state updateParameters
   }
}
# 4219 "../scs_st.st"
ss rebootScs {
   state initReboot {
      when() {
         rebootScsState = INITREBOOT;
         pvPut(rebootScsState);

         efClear(rebootCadChange);
      } state waitForRebootCmd
   }

   state waitForRebootCmd {
      when(efTest(rebootCadChange)) {
         rebootScsState = WAITFORREBOOTCMD;
         pvPut(rebootScsState);


         efClear(rebootCadChange);
      } state startReboot
   }

   state startReboot {


      when() {
         rebootScsState = STARTREBOOT;
         pvPut(rebootScsState);


         rebootCarIn = CAR_BUSY;
         pvPut(rebootCarIn);


         parkCarIn = CAR_BUSY;
         pvPut(parkCarIn);



         writeCommand(DECS_OFF);

         writeCommand(CHOP_OFF);

         chopIsOn = 0;



         guideOn = OFF;



         followOn = OFF;
# 4278 "../scs_st.st"
         writeCommand(ACT_PWR_OFF);
         writeCommand(MEND);
         writeCommand(VEND);
         writeCommand(MOFFLON);

         printf("startReboot - wait for mirror control to disable ******* \n");
      } state rebootParkWaitForCoincidence




   }

   state rebootParkWaitForCoincidence {


      when(delay(5.0)) {
         rebootScsState = WAITFORPARKREBOOT;
         pvPut(rebootScsState);





         writeCommand(VEND);
         writeCommand(MEND);
         writeCommand(MOFFLOFF);
         writeCommand(ACT_PWR_OFF);




         if (eventConfig.change == 0) {



            printf("powerCycleCEM - Shutting off CEM power\n");
            eventConfig.change = 1;
            eventConfig.on = 0;
            eventConfig.m2Servo = OFF;
            eventConfig.m2Power = OFF;
            epicsEventSignal(eventSem);
         }
         else {
            errorLog("waitForParkReboot - command not acknowledged", 1, ON);
            printf("waitForParkReboot - command not acknowledged\n");
         }
      } state powerCycleCEM

      when(delay(TIMEOUT)) {
         rebootScsState = TIMEOUTWAITFORPARKREBOOT;
         pvPut(rebootScsState);

         parkCarErrIn = STATUS_ERROR;
         pvPut(parkCarErrIn);

         strncpy(parkCarMessIn, "No response to park command", MAX_STRING_SIZE - 1);
         pvPut(parkCarMessIn);

         parkCarIn = CAR_ERROR;
         pvPut(parkCarIn);



         writeCommand(VEND);
         writeCommand(MEND);
         writeCommand(MOFFLOFF);
         writeCommand(ACT_PWR_OFF);




         printf("state waitForParkReboot\n");
         if (eventConfig.change == 0) {



            printf("waitForParkReboot - Shutting off CEM power\n");
            eventConfig.change = 1;
            eventConfig.on = 0;
            eventConfig.m2Servo = OFF;
            eventConfig.m2Power = OFF;
            epicsEventSignal(eventSem);
         }
         else {
            errorLog("waitForParkReboot - command not acknowledged", 1, ON);
            printf("waitForParkReboot - command not acknowledged\n");
         }
      } state powerCycleCEM
   }

   state powerCycleCEM {
      when(delay(5.0)) {
         printf("state powerCycleCEM\n");
         if (eventConfig.change == 0) {



            printf("waitForParkReboot - Turning CEM power back on\n");
            eventConfig.change = 1;
            eventConfig.on = 0;
            eventConfig.m2Servo = ON;
            eventConfig.m2Power = ON;
            epicsEventSignal(eventSem);
         }
      } state rebootNow
   }


   state rebootNow {
      when(delay(3.0)) {
         rebootScsState = REBOOTNOW;
         pvPut(rebootScsState);

         myscsState = REBOOTING;
         scsState = myscsState;
         pvPut(myscsState);

         scsStateSad = BOOTING;
         pvPut(scsStateSad);



         rebootCarIn = CAR_BUSY;
         pvPut(rebootCarIn);
# 4417 "../scs_st.st"
         printf("rebootNow - Sendind shutdown command\n");
         %%rebootVME();




      } state waitForRebootCmd
   }
}
# 4471 "../scs_st.st"
ss clearguidefocusScs
{
   state initClearGuideFocus
   {
      when()
      {
         efClear(clearGuideFocusCadChange);

      } state waitForClearGuideFocusCmd
   }

   state waitForClearGuideFocusCmd
   {
      when(efTest(clearGuideFocusCadChange))
      {


         efClear(clearGuideFocusCadChange);
      } state startClearGuideFocus
   }

   state startClearGuideFocus
   {

      when()
      {
         clearGuideFocusCarIn = CAR_BUSY;
         pvPut(clearGuideFocusCarIn);

         printf("startClearGuideFocus - wait for clear guide focus value\n");
      } state proceedWithClearGuideFocus
   }

   state proceedWithClearGuideFocus
   {
      when(controller[FOCUS].sum >= 500 )
      {
         controller[FOCUS].sum -= 500.;
         controller[FOCUS].oldSum -= 500.;

         printf ("proceedWith + sum %f oldS %f \n",
               controller[FOCUS].sum, controller[FOCUS].oldSum);

      } state clearGuideFocusWaitForCoincidence

      when( controller[FOCUS].sum <= -500 )
      {
         controller[FOCUS].sum += 500.;
         controller[FOCUS].oldSum += 500.;

         printf ("proceedWith - sum %f oldS %f \n",
               controller[FOCUS].sum, controller[FOCUS].oldSum);

      } state clearGuideFocusWaitForCoincidence


      when(controller[FOCUS].sum >= -500 && controller[FOCUS].sum <= 500 )
      {
         printf ("proceedWith +- SUm %f oldS %f \n",
               controller[FOCUS].sum, controller[FOCUS].oldSum);
      } state clearGuideFocusWaitForCoincidence

      when(delay(TIMEOUT))
      {

         clearGuideFocusCarErrIn = STATUS_ERROR;
         pvPut(clearGuideFocusCarErrIn);

         strncpy(clearGuideFocusCarMessIn, "proceedWith:No response to clear guide focus command", MAX_STRING_SIZE - 1);
         pvPut(clearGuideFocusCarMessIn);

         clearGuideFocusCarIn = CAR_ERROR;
         pvPut(clearGuideFocusCarIn);

      } state clearGuideFocusWaitForCoincidence

   }

   state clearGuideFocusWaitForCoincidence
   {

      when(controller[FOCUS].sum >= -500 && controller[FOCUS].sum <= 500 )
      {
         controller[FOCUS].sum = 0.0;
         controller[FOCUS].oldSum = 0.0;
         controller[FOCUS].oldError = 0.0;

         printf ("clearGuideFocusWaitForCoincidence - sum %f oldS %f \n",
               controller[FOCUS].sum, controller[FOCUS].oldSum);

         clearGuideFocusCarIn = CAR_IDLE;
         pvPut(clearGuideFocusCarIn);

         strncpy(clearGuideFocusCarMessIn, "", MAX_STRING_SIZE - 1);
         pvPut(clearGuideFocusCarMessIn);

      } state waitForClearGuideFocusCmd

      when( delay(3.0) && controller[FOCUS].sum >= 500 )
      {
         printf ("WaitForCoincidence + Sum %f oldS %f \n",
               controller[FOCUS].sum, controller[FOCUS].oldSum);

      } state proceedWithClearGuideFocus

      when( delay(3.0) && controller[FOCUS].sum <= -500 )
      {
         printf ("WaitForCoincidence - Sum %f oldS %f \n",
               controller[FOCUS].sum, controller[FOCUS].oldSum);

      } state proceedWithClearGuideFocus

      when(delay(TIMEOUT))
      {

         clearGuideFocusCarErrIn = STATUS_ERROR;
         pvPut(clearGuideFocusCarErrIn);

         strncpy(clearGuideFocusCarMessIn, "WaitForCoincidence:No response to clear guide focus command", MAX_STRING_SIZE - 1);
         pvPut(clearGuideFocusCarMessIn);

         clearGuideFocusCarIn = CAR_ERROR;
         pvPut(clearGuideFocusCarIn);

      } state waitForClearGuideFocusCmd
   }

}
