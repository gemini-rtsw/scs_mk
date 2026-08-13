/* THIS IS A GENERATED FILE. DO NOT EDIT! */
/* Generated from ../O.Common/scs-mk-ioc.dbd */

#include <string.h>
#ifndef USE_TYPED_RSET
#  define USE_TYPED_RSET
#endif
#include "compilerDependencies.h"
#include "epicsStdlib.h"
#include "iocsh.h"
#include "iocshRegisterCommon.h"
#include "registryCommon.h"
#include "recSup.h"
#include "shareLib.h"

extern "C" {

epicsShareExtern typed_rset *pvar_rset_aSubRSET, *pvar_rset_aaiRSET,
    *pvar_rset_aaoRSET, *pvar_rset_aiRSET, *pvar_rset_aoRSET,
    *pvar_rset_applyRSET, *pvar_rset_biRSET, *pvar_rset_boRSET,
    *pvar_rset_cadRSET, *pvar_rset_calcRSET, *pvar_rset_calcoutRSET,
    *pvar_rset_carRSET, *pvar_rset_cmdTimeoutRSET,
    *pvar_rset_compressRSET, *pvar_rset_dfanoutRSET, *pvar_rset_eventRSET,
    *pvar_rset_fanoutRSET, *pvar_rset_genSubRSET,
    *pvar_rset_histogramRSET, *pvar_rset_int64inRSET,
    *pvar_rset_int64outRSET, *pvar_rset_longinRSET,
    *pvar_rset_longoutRSET, *pvar_rset_lsiRSET, *pvar_rset_lsoRSET,
    *pvar_rset_lutinRSET, *pvar_rset_lutoutRSET, *pvar_rset_mbbiRSET,
    *pvar_rset_mbbiDirectRSET, *pvar_rset_mbboRSET,
    *pvar_rset_mbboDirectRSET, *pvar_rset_permissiveRSET,
    *pvar_rset_printfRSET, *pvar_rset_selRSET, *pvar_rset_seqRSET,
    *pvar_rset_sirRSET, *pvar_rset_stateRSET, *pvar_rset_statusRSET,
    *pvar_rset_stringinRSET, *pvar_rset_stringoutRSET, *pvar_rset_subRSET,
    *pvar_rset_subArrayRSET, *pvar_rset_waveformRSET;

typedef int (*rso_func)(dbRecordType *pdbRecordType);
epicsShareExtern rso_func pvar_func_aSubRecordSizeOffset,
    pvar_func_aaiRecordSizeOffset, pvar_func_aaoRecordSizeOffset,
    pvar_func_aiRecordSizeOffset, pvar_func_aoRecordSizeOffset,
    pvar_func_applyRecordSizeOffset, pvar_func_biRecordSizeOffset,
    pvar_func_boRecordSizeOffset, pvar_func_cadRecordSizeOffset,
    pvar_func_calcRecordSizeOffset, pvar_func_calcoutRecordSizeOffset,
    pvar_func_carRecordSizeOffset, pvar_func_cmdTimeoutRecordSizeOffset,
    pvar_func_compressRecordSizeOffset, pvar_func_dfanoutRecordSizeOffset,
    pvar_func_eventRecordSizeOffset, pvar_func_fanoutRecordSizeOffset,
    pvar_func_genSubRecordSizeOffset, pvar_func_histogramRecordSizeOffset,
    pvar_func_int64inRecordSizeOffset, pvar_func_int64outRecordSizeOffset,
    pvar_func_longinRecordSizeOffset, pvar_func_longoutRecordSizeOffset,
    pvar_func_lsiRecordSizeOffset, pvar_func_lsoRecordSizeOffset,
    pvar_func_lutinRecordSizeOffset, pvar_func_lutoutRecordSizeOffset,
    pvar_func_mbbiRecordSizeOffset, pvar_func_mbbiDirectRecordSizeOffset,
    pvar_func_mbboRecordSizeOffset, pvar_func_mbboDirectRecordSizeOffset,
    pvar_func_permissiveRecordSizeOffset,
    pvar_func_printfRecordSizeOffset, pvar_func_selRecordSizeOffset,
    pvar_func_seqRecordSizeOffset, pvar_func_sirRecordSizeOffset,
    pvar_func_stateRecordSizeOffset, pvar_func_statusRecordSizeOffset,
    pvar_func_stringinRecordSizeOffset,
    pvar_func_stringoutRecordSizeOffset, pvar_func_subRecordSizeOffset,
    pvar_func_subArrayRecordSizeOffset, pvar_func_waveformRecordSizeOffset;

static const char * const recordTypeNames[] = {
    "aSub", "aai", "aao", "ai", "ao", "apply", "bi", "bo", "cad", "calc",
    "calcout", "car", "cmdTimeout", "compress", "dfanout", "event",
    "fanout", "genSub", "histogram", "int64in", "int64out", "longin",
    "longout", "lsi", "lso", "lutin", "lutout", "mbbi", "mbbiDirect",
    "mbbo", "mbboDirect", "permissive", "printf", "sel", "seq", "sir",
    "state", "status", "stringin", "stringout", "sub", "subArray",
    "waveform"
};

static const recordTypeLocation rtl[] = {
    {(struct typed_rset *)pvar_rset_aSubRSET, pvar_func_aSubRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_aaiRSET, pvar_func_aaiRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_aaoRSET, pvar_func_aaoRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_aiRSET, pvar_func_aiRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_aoRSET, pvar_func_aoRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_applyRSET, pvar_func_applyRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_biRSET, pvar_func_biRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_boRSET, pvar_func_boRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_cadRSET, pvar_func_cadRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_calcRSET, pvar_func_calcRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_calcoutRSET, pvar_func_calcoutRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_carRSET, pvar_func_carRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_cmdTimeoutRSET, pvar_func_cmdTimeoutRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_compressRSET, pvar_func_compressRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_dfanoutRSET, pvar_func_dfanoutRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_eventRSET, pvar_func_eventRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_fanoutRSET, pvar_func_fanoutRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_genSubRSET, pvar_func_genSubRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_histogramRSET, pvar_func_histogramRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_int64inRSET, pvar_func_int64inRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_int64outRSET, pvar_func_int64outRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_longinRSET, pvar_func_longinRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_longoutRSET, pvar_func_longoutRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_lsiRSET, pvar_func_lsiRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_lsoRSET, pvar_func_lsoRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_lutinRSET, pvar_func_lutinRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_lutoutRSET, pvar_func_lutoutRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_mbbiRSET, pvar_func_mbbiRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_mbbiDirectRSET, pvar_func_mbbiDirectRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_mbboRSET, pvar_func_mbboRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_mbboDirectRSET, pvar_func_mbboDirectRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_permissiveRSET, pvar_func_permissiveRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_printfRSET, pvar_func_printfRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_selRSET, pvar_func_selRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_seqRSET, pvar_func_seqRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_sirRSET, pvar_func_sirRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_stateRSET, pvar_func_stateRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_statusRSET, pvar_func_statusRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_stringinRSET, pvar_func_stringinRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_stringoutRSET, pvar_func_stringoutRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_subRSET, pvar_func_subRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_subArrayRSET, pvar_func_subArrayRecordSizeOffset},
    {(struct typed_rset *)pvar_rset_waveformRSET, pvar_func_waveformRecordSizeOffset}
};

epicsShareExtern dset *pvar_dset_devAaiSoft, *pvar_dset_devAaoSoft,
    *pvar_dset_devAiSoft, *pvar_dset_devAiSoftRaw,
    *pvar_dset_devAiSoftCallback, *pvar_dset_devTimestampAI,
    *pvar_dset_devAiGeneralTime, *pvar_dset_devAiBc635,
    *pvar_dset_devAiSymb, *pvar_dset_devAiSymbLong,
    *pvar_dset_devAiSymbShort, *pvar_dset_devAiSymb,
    *pvar_dset_devAiSymbLong, *pvar_dset_devAiSymbShort,
    *pvar_dset_devAoSoft, *pvar_dset_devAoSoftRaw,
    *pvar_dset_devAoSoftCallback, *pvar_dset_devAoBc635,
    *pvar_dset_devAoSymb, *pvar_dset_devAoSymb, *pvar_dset_devBiSoft,
    *pvar_dset_devBiSoftRaw, *pvar_dset_devBiSoftCallback,
    *pvar_dset_devBiDbState, *pvar_dset_devBiVmi5588,
    *pvar_dset_devBiXy240, *pvar_dset_devBiSymb, *pvar_dset_devBiSymb,
    *pvar_dset_devBoSoft, *pvar_dset_devBoSoftRaw,
    *pvar_dset_devBoSoftCallback, *pvar_dset_devBoGeneralTime,
    *pvar_dset_devBoDbState, *pvar_dset_devBoXy240, *pvar_dset_devBoSymb,
    *pvar_dset_devBoSymb, *pvar_dset_devCalcoutSoft,
    *pvar_dset_devCalcoutSoftCallback, *pvar_dset_devEventSoft,
    *pvar_dset_devHistogramSoft, *pvar_dset_devI64inSoft,
    *pvar_dset_devI64inSoftCallback, *pvar_dset_devI64outSoft,
    *pvar_dset_devI64outSoftCallback, *pvar_dset_devLiSoft,
    *pvar_dset_devLiSoftCallback, *pvar_dset_devLiGeneralTime,
    *pvar_dset_devLiSymb, *pvar_dset_devLiSymb, *pvar_dset_devLoSoft,
    *pvar_dset_devLoSoftCallback, *pvar_dset_devLoSymb,
    *pvar_dset_devLoSymb, *pvar_dset_devLsiSoft, *pvar_dset_devLsiEnviron,
    *pvar_dset_devLsoSoft, *pvar_dset_devLsoSoftCallback,
    *pvar_dset_devLsoStdio, *pvar_dset_devLutinSoft,
    *pvar_dset_devLutoutSoft, *pvar_dset_devMbbiSoft,
    *pvar_dset_devMbbiSoftRaw, *pvar_dset_devMbbiSoftCallback,
    *pvar_dset_devMbbiXy240, *pvar_dset_devMbbiSymb,
    *pvar_dset_devMbbiSymbRaw, *pvar_dset_devMbbiSymb,
    *pvar_dset_devMbbiSymbRaw, *pvar_dset_devMbbiDirectSoft,
    *pvar_dset_devMbbiDirectSoftRaw, *pvar_dset_devMbbiDirectSoftCallback,
    *pvar_dset_devMbboSoft, *pvar_dset_devMbboSoftRaw,
    *pvar_dset_devMbboSoftCallback, *pvar_dset_devMbboXy240,
    *pvar_dset_devMbboSymb, *pvar_dset_devMbboSymbRaw,
    *pvar_dset_devMbboSymb, *pvar_dset_devMbboSymbRaw,
    *pvar_dset_devMbboDirectSoft, *pvar_dset_devMbboDirectSoftRaw,
    *pvar_dset_devMbboDirectSoftCallback, *pvar_dset_devPrintfSoft,
    *pvar_dset_devPrintfSoftCallback, *pvar_dset_devPrintfStdio,
    *pvar_dset_devStatusSoft, *pvar_dset_devSiSoft,
    *pvar_dset_devSiSoftCallback, *pvar_dset_devTimestampSI,
    *pvar_dset_devSiGeneralTime, *pvar_dset_devSiEnviron,
    *pvar_dset_devSiBc635, *pvar_dset_devSiSymb, *pvar_dset_devSiSymb,
    *pvar_dset_devSoSoft, *pvar_dset_devSoSoftCallback,
    *pvar_dset_devSoStdio, *pvar_dset_devSoBc635, *pvar_dset_devSoSymb,
    *pvar_dset_devSoSymb, *pvar_dset_devSASoft, *pvar_dset_devWfSoft,
    *pvar_dset_devWfSymb, *pvar_dset_devWfSymb;

static const char * const deviceSupportNames[] = {
    "devAaiSoft", "devAaoSoft", "devAiSoft", "devAiSoftRaw",
    "devAiSoftCallback", "devTimestampAI", "devAiGeneralTime",
    "devAiBc635", "devAiSymb", "devAiSymbLong", "devAiSymbShort",
    "devAiSymb", "devAiSymbLong", "devAiSymbShort", "devAoSoft",
    "devAoSoftRaw", "devAoSoftCallback", "devAoBc635", "devAoSymb",
    "devAoSymb", "devBiSoft", "devBiSoftRaw", "devBiSoftCallback",
    "devBiDbState", "devBiVmi5588", "devBiXy240", "devBiSymb",
    "devBiSymb", "devBoSoft", "devBoSoftRaw", "devBoSoftCallback",
    "devBoGeneralTime", "devBoDbState", "devBoXy240", "devBoSymb",
    "devBoSymb", "devCalcoutSoft", "devCalcoutSoftCallback",
    "devEventSoft", "devHistogramSoft", "devI64inSoft",
    "devI64inSoftCallback", "devI64outSoft", "devI64outSoftCallback",
    "devLiSoft", "devLiSoftCallback", "devLiGeneralTime", "devLiSymb",
    "devLiSymb", "devLoSoft", "devLoSoftCallback", "devLoSymb",
    "devLoSymb", "devLsiSoft", "devLsiEnviron", "devLsoSoft",
    "devLsoSoftCallback", "devLsoStdio", "devLutinSoft", "devLutoutSoft",
    "devMbbiSoft", "devMbbiSoftRaw", "devMbbiSoftCallback",
    "devMbbiXy240", "devMbbiSymb", "devMbbiSymbRaw", "devMbbiSymb",
    "devMbbiSymbRaw", "devMbbiDirectSoft", "devMbbiDirectSoftRaw",
    "devMbbiDirectSoftCallback", "devMbboSoft", "devMbboSoftRaw",
    "devMbboSoftCallback", "devMbboXy240", "devMbboSymb",
    "devMbboSymbRaw", "devMbboSymb", "devMbboSymbRaw",
    "devMbboDirectSoft", "devMbboDirectSoftRaw",
    "devMbboDirectSoftCallback", "devPrintfSoft", "devPrintfSoftCallback",
    "devPrintfStdio", "devStatusSoft", "devSiSoft", "devSiSoftCallback",
    "devTimestampSI", "devSiGeneralTime", "devSiEnviron", "devSiBc635",
    "devSiSymb", "devSiSymb", "devSoSoft", "devSoSoftCallback",
    "devSoStdio", "devSoBc635", "devSoSymb", "devSoSymb", "devSASoft",
    "devWfSoft", "devWfSymb", "devWfSymb"
};

static const dset * const devsl[] = {
    pvar_dset_devAaiSoft, pvar_dset_devAaoSoft, pvar_dset_devAiSoft,
    pvar_dset_devAiSoftRaw, pvar_dset_devAiSoftCallback,
    pvar_dset_devTimestampAI, pvar_dset_devAiGeneralTime,
    pvar_dset_devAiBc635, pvar_dset_devAiSymb, pvar_dset_devAiSymbLong,
    pvar_dset_devAiSymbShort, pvar_dset_devAiSymb,
    pvar_dset_devAiSymbLong, pvar_dset_devAiSymbShort,
    pvar_dset_devAoSoft, pvar_dset_devAoSoftRaw,
    pvar_dset_devAoSoftCallback, pvar_dset_devAoBc635,
    pvar_dset_devAoSymb, pvar_dset_devAoSymb, pvar_dset_devBiSoft,
    pvar_dset_devBiSoftRaw, pvar_dset_devBiSoftCallback,
    pvar_dset_devBiDbState, pvar_dset_devBiVmi5588, pvar_dset_devBiXy240,
    pvar_dset_devBiSymb, pvar_dset_devBiSymb, pvar_dset_devBoSoft,
    pvar_dset_devBoSoftRaw, pvar_dset_devBoSoftCallback,
    pvar_dset_devBoGeneralTime, pvar_dset_devBoDbState,
    pvar_dset_devBoXy240, pvar_dset_devBoSymb, pvar_dset_devBoSymb,
    pvar_dset_devCalcoutSoft, pvar_dset_devCalcoutSoftCallback,
    pvar_dset_devEventSoft, pvar_dset_devHistogramSoft,
    pvar_dset_devI64inSoft, pvar_dset_devI64inSoftCallback,
    pvar_dset_devI64outSoft, pvar_dset_devI64outSoftCallback,
    pvar_dset_devLiSoft, pvar_dset_devLiSoftCallback,
    pvar_dset_devLiGeneralTime, pvar_dset_devLiSymb, pvar_dset_devLiSymb,
    pvar_dset_devLoSoft, pvar_dset_devLoSoftCallback, pvar_dset_devLoSymb,
    pvar_dset_devLoSymb, pvar_dset_devLsiSoft, pvar_dset_devLsiEnviron,
    pvar_dset_devLsoSoft, pvar_dset_devLsoSoftCallback,
    pvar_dset_devLsoStdio, pvar_dset_devLutinSoft,
    pvar_dset_devLutoutSoft, pvar_dset_devMbbiSoft,
    pvar_dset_devMbbiSoftRaw, pvar_dset_devMbbiSoftCallback,
    pvar_dset_devMbbiXy240, pvar_dset_devMbbiSymb,
    pvar_dset_devMbbiSymbRaw, pvar_dset_devMbbiSymb,
    pvar_dset_devMbbiSymbRaw, pvar_dset_devMbbiDirectSoft,
    pvar_dset_devMbbiDirectSoftRaw, pvar_dset_devMbbiDirectSoftCallback,
    pvar_dset_devMbboSoft, pvar_dset_devMbboSoftRaw,
    pvar_dset_devMbboSoftCallback, pvar_dset_devMbboXy240,
    pvar_dset_devMbboSymb, pvar_dset_devMbboSymbRaw,
    pvar_dset_devMbboSymb, pvar_dset_devMbboSymbRaw,
    pvar_dset_devMbboDirectSoft, pvar_dset_devMbboDirectSoftRaw,
    pvar_dset_devMbboDirectSoftCallback, pvar_dset_devPrintfSoft,
    pvar_dset_devPrintfSoftCallback, pvar_dset_devPrintfStdio,
    pvar_dset_devStatusSoft, pvar_dset_devSiSoft,
    pvar_dset_devSiSoftCallback, pvar_dset_devTimestampSI,
    pvar_dset_devSiGeneralTime, pvar_dset_devSiEnviron,
    pvar_dset_devSiBc635, pvar_dset_devSiSymb, pvar_dset_devSiSymb,
    pvar_dset_devSoSoft, pvar_dset_devSoSoftCallback,
    pvar_dset_devSoStdio, pvar_dset_devSoBc635, pvar_dset_devSoSymb,
    pvar_dset_devSoSymb, pvar_dset_devSASoft, pvar_dset_devWfSoft,
    pvar_dset_devWfSymb, pvar_dset_devWfSymb
};

epicsShareExtern drvet *pvar_drvet_drvBc635, *pvar_drvet_drvVmi5588,
    *pvar_drvet_drvXy240;

static const char *driverSupportNames[] = {
    "drvBc635", "drvVmi5588", "drvXy240"};

static struct drvet *drvsl[] = {
    pvar_drvet_drvBc635,
    pvar_drvet_drvVmi5588,
    pvar_drvet_drvXy240};

epicsShareExtern jlif *pvar_jlif_lnkCalcIf, *pvar_jlif_lnkConstIf,
    *pvar_jlif_lnkDebugIf, *pvar_jlif_lnkStateIf, *pvar_jlif_lnkTraceIf;

static struct jlif *jlifsl[] = {
    pvar_jlif_lnkCalcIf,
    pvar_jlif_lnkConstIf,
    pvar_jlif_lnkDebugIf,
    pvar_jlif_lnkStateIf,
    pvar_jlif_lnkTraceIf};

typedef void (*reg_func)(void);
epicsShareExtern reg_func pvar_func_BCTestFunctions,
    pvar_func_BCconfigureRegister, pvar_func_CADlogTogRegisterCommands,
    pvar_func_arrInitialize, pvar_func_asSub, pvar_func_bc635TimeRegister,
    pvar_func_bc635_reportRegister, pvar_func_chopRegisterCommands,
    pvar_func_controlRegisterCommands, pvar_func_dbndInitialize,
    pvar_func_decInitialize, pvar_func_displayFilterRegisterCommands,
    pvar_func_drvVmi5588RegisterCommands,
    pvar_func_drvXy240RegisterCommands, pvar_func_initTraceRegister,
    pvar_func_listAlarmRecordsRegistrar, pvar_func_pvloadRegistrar,
    pvar_func_rsrvRegistrar, pvar_func_scsRegisterCommands,
    pvar_func_scs_stRegistrar, pvar_func_syncInitialize,
    pvar_func_systemTickToolsRegistrar,
    pvar_func_testFunctionsRegisterCommands, pvar_func_tilt_stRegistrar,
    pvar_func_timeClockInitRegister, pvar_func_timePrintRegister,
    pvar_func_timeSeqRegistrar, pvar_func_tsInitialize,
    pvar_func_utagInitialize, pvar_func_register_func_CADactuators,
    pvar_func_register_func_CADbeamJog,
    pvar_func_register_func_CADchopConfig,
    pvar_func_register_func_CADchopControl,
    pvar_func_register_func_CADclearGuideFocus,
    pvar_func_register_func_CADclearTiltGuide,
    pvar_func_register_func_CADcontroller,
    pvar_func_register_func_CADdatum, pvar_func_register_func_CADdebug,
    pvar_func_register_func_CADdecsAdjust,
    pvar_func_register_func_CADdriveCB,
    pvar_func_register_func_CADdriveDB,
    pvar_func_register_func_CADdriveFollower,
    pvar_func_register_func_CADdriveOffloader,
    pvar_func_register_func_CADdriveXY,
    pvar_func_register_func_CADfocusPidControl,
    pvar_func_register_func_CADfollow, pvar_func_register_func_CADfreeRun,
    pvar_func_register_func_CADguideConfig,
    pvar_func_register_func_CADguideControl,
    pvar_func_register_func_CADguideReset,
    pvar_func_register_func_CADguideSimCont,
    pvar_func_register_func_CADinit, pvar_func_register_func_CADinitXY,
    pvar_func_register_func_CADmove,
    pvar_func_register_func_CADmoveBaffle,
    pvar_func_register_func_CADmovePeriscope,
    pvar_func_register_func_CADpark,
    pvar_func_register_func_CADphasorControl,
    pvar_func_register_func_CADreboot,
    pvar_func_register_func_CADservoBandwidth,
    pvar_func_register_func_CADsetPhasorControl,
    pvar_func_register_func_CADsetVTKControl,
    pvar_func_register_func_CADsimulate, pvar_func_register_func_CADstop,
    pvar_func_register_func_CADtest,
    pvar_func_register_func_CADtiltPidControl,
    pvar_func_register_func_CADtolerance,
    pvar_func_register_func_CADvtkControl,
    pvar_func_register_func_cadDirLog,
    pvar_func_register_func_calcEnvelope,
    pvar_func_register_func_carDrive1, pvar_func_register_func_carDrive2,
    pvar_func_register_func_carDrive3, pvar_func_register_func_decimate,
    pvar_func_register_func_displayScs,
    pvar_func_register_func_displayScs2,
    pvar_func_register_func_driveEvent, pvar_func_register_func_dummyInit,
    pvar_func_register_func_dummyInitGenSub,
    pvar_func_register_func_gensubFanDoubles,
    pvar_func_register_func_getTime, pvar_func_register_func_guideConfig,
    pvar_func_register_func_guideSimProc,
    pvar_func_register_func_highSpeed, pvar_func_register_func_highSpeed2,
    pvar_func_register_func_initDecimate,
    pvar_func_register_func_initFollowGenSub,
    pvar_func_register_func_initHighSpeed,
    pvar_func_register_func_initHighSpeed2,
    pvar_func_register_func_initInterlock,
    pvar_func_register_func_initSelector,
    pvar_func_register_func_initTime,
    pvar_func_register_func_issueM2Primitive,
    pvar_func_register_func_lockMonitor,
    pvar_func_register_func_lookupGuide, pvar_func_register_func_mechSim,
    pvar_func_register_func_percentCalc,
    pvar_func_register_func_pulseSteerCAD,
    pvar_func_register_func_readHealth,
    pvar_func_register_func_readHealthInit,
    pvar_func_register_func_readM2Diagnostics,
    pvar_func_register_func_readM2DiagnosticsInit,
    pvar_func_register_func_real2Drive, pvar_func_register_func_realDrive,
    pvar_func_register_func_receiveTcsDemand,
    pvar_func_register_func_resetGuideConfig,
    pvar_func_register_func_scsStateStringConvert,
    pvar_func_register_func_scsStateStringInit,
    pvar_func_register_func_selector,
    pvar_func_register_func_sirDisplayFrame,
    pvar_func_register_func_sirDisplayTime,
    pvar_func_register_func_sirHealth,
    pvar_func_register_func_sirRArcsecs, pvar_func_register_func_sirRDegs,
    pvar_func_register_func_sirRaDecSys,
    pvar_func_register_func_sirSDegsSigned,
    pvar_func_register_func_sirSDegsUnsigned,
    pvar_func_register_func_sirSHrs, pvar_func_register_func_snlStateInit,
    pvar_func_register_func_snlStateMonitor,
    pvar_func_register_func_snlStateStringConvert,
    pvar_func_register_func_snlStateStringInit,
    pvar_func_register_func_stateInit,
    pvar_func_register_func_stateMonitor,
    pvar_func_register_func_statusDrive, pvar_func_register_func_ticker,
    pvar_func_register_func_timeClockCheck,
    pvar_func_register_func_timeClockReport,
    pvar_func_register_func_timeDump;

epicsShareExtern int * const pvar_int_CADlogging;
epicsShareExtern int * const pvar_int_CASDEBUG;
epicsShareExtern int * const pvar_int_NsNrTolerance;
epicsShareExtern int * const pvar_int_absent;
epicsShareExtern int * const pvar_int_altIntCounter1;
epicsShareExtern int * const pvar_int_altIntCounter2;
epicsShareExtern int * const pvar_int_asCaDebug;
epicsShareExtern int * const pvar_int_atExitDebug;
epicsShareExtern int * const pvar_int_bcConfiguredOK;
epicsShareExtern int * const pvar_int_bcDebug;
epicsShareExtern int * const pvar_int_bcEventCounter;
epicsShareExtern int * const pvar_int_bcIntCounter;
epicsShareExtern int * const pvar_int_bcReadCounter;
epicsShareExtern int * const pvar_int_bcTickCnt;
epicsShareExtern int * const pvar_int_bcYearEpoch;
epicsShareExtern int * const pvar_int_bc_usec_ignore;
epicsShareExtern double * const pvar_double_boHIGHlimit;
epicsShareExtern int * const pvar_int_boHIGHprecision;
epicsShareExtern double * const pvar_double_calcoutODLYlimit;
epicsShareExtern int * const pvar_int_calcoutODLYprecision;
epicsShareExtern int * const pvar_int_callbackParallelThreadsDefault;
epicsShareExtern int * const pvar_int_checkBaffleFlag;
epicsShareExtern int * const pvar_int_dbAccessDebugPUTF;
epicsShareExtern int * const pvar_int_dbBptNotMonotonic;
epicsShareExtern int * const pvar_int_dbConvertStrict;
epicsShareExtern int * const pvar_int_dbJLinkDebug;
epicsShareExtern int * const pvar_int_dbQuietMacroWarnings;
epicsShareExtern int * const pvar_int_dbRecordsAbcSorted;
epicsShareExtern int * const pvar_int_dbRecordsOnceOnly;
epicsShareExtern int * const pvar_int_dbTemplateMaxVars;
epicsShareExtern int * const pvar_int_dbThreadRealtimeLock;
epicsShareExtern int * const pvar_int_debugLevel;
epicsShareExtern int * const pvar_int_histogramSDELprecision;
epicsShareExtern int * const pvar_int_isr2;
epicsShareExtern int * const pvar_int_isr3;
epicsShareExtern int * const pvar_int_lnkDebug_debug;
epicsShareExtern int * const pvar_int_logClientDebug;
epicsShareExtern int * const pvar_int_m2diags1;
epicsShareExtern int * const pvar_int_m2diags2;
epicsShareExtern int * const pvar_int_m2diags3;
epicsShareExtern int * const pvar_int_m2diags4;
epicsShareExtern int * const pvar_int_m2diags5;
epicsShareExtern int * const pvar_int_m2diags6;
epicsShareExtern int * const pvar_int_m2diags7;
epicsShareExtern int * const pvar_int_m2diags8;
epicsShareExtern int * const pvar_int_m2diags9;
epicsShareExtern int * const pvar_int_mutex1;
epicsShareExtern int * const pvar_int_mutex10;
epicsShareExtern int * const pvar_int_mutex11;
epicsShareExtern int * const pvar_int_mutex12;
epicsShareExtern int * const pvar_int_mutex13;
epicsShareExtern int * const pvar_int_mutex14;
epicsShareExtern int * const pvar_int_mutex15;
epicsShareExtern int * const pvar_int_mutex16;
epicsShareExtern int * const pvar_int_mutex17;
epicsShareExtern int * const pvar_int_mutex18;
epicsShareExtern int * const pvar_int_mutex19;
epicsShareExtern int * const pvar_int_mutex2;
epicsShareExtern int * const pvar_int_mutex20;
epicsShareExtern int * const pvar_int_mutex3;
epicsShareExtern int * const pvar_int_mutex4;
epicsShareExtern int * const pvar_int_mutex5;
epicsShareExtern int * const pvar_int_mutex6;
epicsShareExtern int * const pvar_int_mutex7;
epicsShareExtern int * const pvar_int_mutex8;
epicsShareExtern int * const pvar_int_mutex9;
epicsShareExtern int * const pvar_int_procGuideCount1;
epicsShareExtern int * const pvar_int_procGuideCount10;
epicsShareExtern int * const pvar_int_procGuideCount2;
epicsShareExtern int * const pvar_int_procGuideCount3;
epicsShareExtern int * const pvar_int_procGuideCount4;
epicsShareExtern int * const pvar_int_procGuideCount5;
epicsShareExtern int * const pvar_int_procGuideCount6;
epicsShareExtern int * const pvar_int_procGuideCount7;
epicsShareExtern int * const pvar_int_procGuideCount8;
epicsShareExtern int * const pvar_int_procGuideCount9;
epicsShareExtern int * const pvar_int_reallock1;
epicsShareExtern int * const pvar_int_reallock2;
epicsShareExtern int * const pvar_int_reallock3;
epicsShareExtern int * const pvar_int_reallock4;
epicsShareExtern int * const pvar_int_refmem_mon1;
epicsShareExtern int * const pvar_int_scsrx1;
epicsShareExtern int * const pvar_int_scsrx2;
epicsShareExtern int * const pvar_int_scsrx3;
epicsShareExtern int * const pvar_int_scsrx3a;
epicsShareExtern int * const pvar_int_scsrx3b;
epicsShareExtern int * const pvar_int_scsrx4;
epicsShareExtern int * const pvar_int_scsrx5;
epicsShareExtern int * const pvar_int_sendpulse;
epicsShareExtern double * const pvar_double_seqDLYlimit;
epicsShareExtern int * const pvar_int_seqDLYprecision;
epicsShareExtern int * const pvar_int_showTimeProfile;
epicsShareExtern int * const pvar_int_showcs;
epicsShareExtern int * const pvar_int_simLevel;
epicsShareExtern int * const pvar_int_vmic5588int0cnt;
epicsShareExtern int * const pvar_int_vmic5588int1cnt;
epicsShareExtern int * const pvar_int_vmic5588int2cnt;
epicsShareExtern int * const pvar_int_vmic5588int3cnt;
epicsShareExtern int * const pvar_int_vmic5588latestIrqNum;
epicsShareExtern double * const pvar_double_waittime;
epicsShareExtern double * const pvar_double_waittime2;

static struct iocshVarDef vardefs[] = {
    {"CADlogging", iocshArgInt, pvar_int_CADlogging},
    {"CASDEBUG", iocshArgInt, pvar_int_CASDEBUG},
    {"NsNrTolerance", iocshArgInt, pvar_int_NsNrTolerance},
    {"absent", iocshArgInt, pvar_int_absent},
    {"altIntCounter1", iocshArgInt, pvar_int_altIntCounter1},
    {"altIntCounter2", iocshArgInt, pvar_int_altIntCounter2},
    {"asCaDebug", iocshArgInt, pvar_int_asCaDebug},
    {"atExitDebug", iocshArgInt, pvar_int_atExitDebug},
    {"bcConfiguredOK", iocshArgInt, pvar_int_bcConfiguredOK},
    {"bcDebug", iocshArgInt, pvar_int_bcDebug},
    {"bcEventCounter", iocshArgInt, pvar_int_bcEventCounter},
    {"bcIntCounter", iocshArgInt, pvar_int_bcIntCounter},
    {"bcReadCounter", iocshArgInt, pvar_int_bcReadCounter},
    {"bcTickCnt", iocshArgInt, pvar_int_bcTickCnt},
    {"bcYearEpoch", iocshArgInt, pvar_int_bcYearEpoch},
    {"bc_usec_ignore", iocshArgInt, pvar_int_bc_usec_ignore},
    {"boHIGHlimit", iocshArgDouble, pvar_double_boHIGHlimit},
    {"boHIGHprecision", iocshArgInt, pvar_int_boHIGHprecision},
    {"calcoutODLYlimit", iocshArgDouble, pvar_double_calcoutODLYlimit},
    {"calcoutODLYprecision", iocshArgInt, pvar_int_calcoutODLYprecision},
    {"callbackParallelThreadsDefault", iocshArgInt, pvar_int_callbackParallelThreadsDefault},
    {"checkBaffleFlag", iocshArgInt, pvar_int_checkBaffleFlag},
    {"dbAccessDebugPUTF", iocshArgInt, pvar_int_dbAccessDebugPUTF},
    {"dbBptNotMonotonic", iocshArgInt, pvar_int_dbBptNotMonotonic},
    {"dbConvertStrict", iocshArgInt, pvar_int_dbConvertStrict},
    {"dbJLinkDebug", iocshArgInt, pvar_int_dbJLinkDebug},
    {"dbQuietMacroWarnings", iocshArgInt, pvar_int_dbQuietMacroWarnings},
    {"dbRecordsAbcSorted", iocshArgInt, pvar_int_dbRecordsAbcSorted},
    {"dbRecordsOnceOnly", iocshArgInt, pvar_int_dbRecordsOnceOnly},
    {"dbTemplateMaxVars", iocshArgInt, pvar_int_dbTemplateMaxVars},
    {"dbThreadRealtimeLock", iocshArgInt, pvar_int_dbThreadRealtimeLock},
    {"debugLevel", iocshArgInt, pvar_int_debugLevel},
    {"histogramSDELprecision", iocshArgInt, pvar_int_histogramSDELprecision},
    {"isr2", iocshArgInt, pvar_int_isr2},
    {"isr3", iocshArgInt, pvar_int_isr3},
    {"lnkDebug_debug", iocshArgInt, pvar_int_lnkDebug_debug},
    {"logClientDebug", iocshArgInt, pvar_int_logClientDebug},
    {"m2diags1", iocshArgInt, pvar_int_m2diags1},
    {"m2diags2", iocshArgInt, pvar_int_m2diags2},
    {"m2diags3", iocshArgInt, pvar_int_m2diags3},
    {"m2diags4", iocshArgInt, pvar_int_m2diags4},
    {"m2diags5", iocshArgInt, pvar_int_m2diags5},
    {"m2diags6", iocshArgInt, pvar_int_m2diags6},
    {"m2diags7", iocshArgInt, pvar_int_m2diags7},
    {"m2diags8", iocshArgInt, pvar_int_m2diags8},
    {"m2diags9", iocshArgInt, pvar_int_m2diags9},
    {"mutex1", iocshArgInt, pvar_int_mutex1},
    {"mutex10", iocshArgInt, pvar_int_mutex10},
    {"mutex11", iocshArgInt, pvar_int_mutex11},
    {"mutex12", iocshArgInt, pvar_int_mutex12},
    {"mutex13", iocshArgInt, pvar_int_mutex13},
    {"mutex14", iocshArgInt, pvar_int_mutex14},
    {"mutex15", iocshArgInt, pvar_int_mutex15},
    {"mutex16", iocshArgInt, pvar_int_mutex16},
    {"mutex17", iocshArgInt, pvar_int_mutex17},
    {"mutex18", iocshArgInt, pvar_int_mutex18},
    {"mutex19", iocshArgInt, pvar_int_mutex19},
    {"mutex2", iocshArgInt, pvar_int_mutex2},
    {"mutex20", iocshArgInt, pvar_int_mutex20},
    {"mutex3", iocshArgInt, pvar_int_mutex3},
    {"mutex4", iocshArgInt, pvar_int_mutex4},
    {"mutex5", iocshArgInt, pvar_int_mutex5},
    {"mutex6", iocshArgInt, pvar_int_mutex6},
    {"mutex7", iocshArgInt, pvar_int_mutex7},
    {"mutex8", iocshArgInt, pvar_int_mutex8},
    {"mutex9", iocshArgInt, pvar_int_mutex9},
    {"procGuideCount1", iocshArgInt, pvar_int_procGuideCount1},
    {"procGuideCount10", iocshArgInt, pvar_int_procGuideCount10},
    {"procGuideCount2", iocshArgInt, pvar_int_procGuideCount2},
    {"procGuideCount3", iocshArgInt, pvar_int_procGuideCount3},
    {"procGuideCount4", iocshArgInt, pvar_int_procGuideCount4},
    {"procGuideCount5", iocshArgInt, pvar_int_procGuideCount5},
    {"procGuideCount6", iocshArgInt, pvar_int_procGuideCount6},
    {"procGuideCount7", iocshArgInt, pvar_int_procGuideCount7},
    {"procGuideCount8", iocshArgInt, pvar_int_procGuideCount8},
    {"procGuideCount9", iocshArgInt, pvar_int_procGuideCount9},
    {"reallock1", iocshArgInt, pvar_int_reallock1},
    {"reallock2", iocshArgInt, pvar_int_reallock2},
    {"reallock3", iocshArgInt, pvar_int_reallock3},
    {"reallock4", iocshArgInt, pvar_int_reallock4},
    {"refmem_mon1", iocshArgInt, pvar_int_refmem_mon1},
    {"scsrx1", iocshArgInt, pvar_int_scsrx1},
    {"scsrx2", iocshArgInt, pvar_int_scsrx2},
    {"scsrx3", iocshArgInt, pvar_int_scsrx3},
    {"scsrx3a", iocshArgInt, pvar_int_scsrx3a},
    {"scsrx3b", iocshArgInt, pvar_int_scsrx3b},
    {"scsrx4", iocshArgInt, pvar_int_scsrx4},
    {"scsrx5", iocshArgInt, pvar_int_scsrx5},
    {"sendpulse", iocshArgInt, pvar_int_sendpulse},
    {"seqDLYlimit", iocshArgDouble, pvar_double_seqDLYlimit},
    {"seqDLYprecision", iocshArgInt, pvar_int_seqDLYprecision},
    {"showTimeProfile", iocshArgInt, pvar_int_showTimeProfile},
    {"showcs", iocshArgInt, pvar_int_showcs},
    {"simLevel", iocshArgInt, pvar_int_simLevel},
    {"vmic5588int0cnt", iocshArgInt, pvar_int_vmic5588int0cnt},
    {"vmic5588int1cnt", iocshArgInt, pvar_int_vmic5588int1cnt},
    {"vmic5588int2cnt", iocshArgInt, pvar_int_vmic5588int2cnt},
    {"vmic5588int3cnt", iocshArgInt, pvar_int_vmic5588int3cnt},
    {"vmic5588latestIrqNum", iocshArgInt, pvar_int_vmic5588latestIrqNum},
    {"waittime", iocshArgDouble, pvar_double_waittime},
    {"waittime2", iocshArgDouble, pvar_double_waittime2},
    {NULL, iocshArgInt, NULL}
};

int scs_mk_ioc_registerRecordDeviceDriver(DBBASE *pbase)
{
    static int executed = 0;
    const char *bldTop = "/repo";
    const char *envTop = getenv("TOP");

    if (envTop && strcmp(envTop, bldTop)) {
        printf("Warning: IOC is booting with TOP = \"%s\"\n"
               "          but was built with TOP = \"%s\"\n",
               envTop, bldTop);
    }

    if (!pbase) {
        printf("pdbbase is NULL; you must load a DBD file first.\n");
        return -1;
    }

    if (executed) {
        printf("Warning: Registration already done.\n");
    }
    executed = 1;

    registerRecordTypes(pbase, NELEMENTS(rtl), recordTypeNames, rtl);
    registerDevices(pbase, NELEMENTS(devsl), deviceSupportNames, devsl);
    registerDrivers(pbase, NELEMENTS(drvsl), driverSupportNames, drvsl);
    registerJLinks(pbase, NELEMENTS(jlifsl), jlifsl);
    runRegistrarOnce(pvar_func_BCTestFunctions);
    runRegistrarOnce(pvar_func_BCconfigureRegister);
    runRegistrarOnce(pvar_func_CADlogTogRegisterCommands);
    runRegistrarOnce(pvar_func_arrInitialize);
    runRegistrarOnce(pvar_func_asSub);
    runRegistrarOnce(pvar_func_bc635TimeRegister);
    runRegistrarOnce(pvar_func_bc635_reportRegister);
    runRegistrarOnce(pvar_func_chopRegisterCommands);
    runRegistrarOnce(pvar_func_controlRegisterCommands);
    runRegistrarOnce(pvar_func_dbndInitialize);
    runRegistrarOnce(pvar_func_decInitialize);
    runRegistrarOnce(pvar_func_displayFilterRegisterCommands);
    runRegistrarOnce(pvar_func_drvVmi5588RegisterCommands);
    runRegistrarOnce(pvar_func_drvXy240RegisterCommands);
    runRegistrarOnce(pvar_func_initTraceRegister);
    runRegistrarOnce(pvar_func_listAlarmRecordsRegistrar);
    runRegistrarOnce(pvar_func_pvloadRegistrar);
    runRegistrarOnce(pvar_func_rsrvRegistrar);
    runRegistrarOnce(pvar_func_scsRegisterCommands);
    runRegistrarOnce(pvar_func_scs_stRegistrar);
    runRegistrarOnce(pvar_func_syncInitialize);
    runRegistrarOnce(pvar_func_systemTickToolsRegistrar);
    runRegistrarOnce(pvar_func_testFunctionsRegisterCommands);
    runRegistrarOnce(pvar_func_tilt_stRegistrar);
    runRegistrarOnce(pvar_func_timeClockInitRegister);
    runRegistrarOnce(pvar_func_timePrintRegister);
    runRegistrarOnce(pvar_func_timeSeqRegistrar);
    runRegistrarOnce(pvar_func_tsInitialize);
    runRegistrarOnce(pvar_func_utagInitialize);
    runRegistrarOnce(pvar_func_register_func_CADactuators);
    runRegistrarOnce(pvar_func_register_func_CADbeamJog);
    runRegistrarOnce(pvar_func_register_func_CADchopConfig);
    runRegistrarOnce(pvar_func_register_func_CADchopControl);
    runRegistrarOnce(pvar_func_register_func_CADclearGuideFocus);
    runRegistrarOnce(pvar_func_register_func_CADclearTiltGuide);
    runRegistrarOnce(pvar_func_register_func_CADcontroller);
    runRegistrarOnce(pvar_func_register_func_CADdatum);
    runRegistrarOnce(pvar_func_register_func_CADdebug);
    runRegistrarOnce(pvar_func_register_func_CADdecsAdjust);
    runRegistrarOnce(pvar_func_register_func_CADdriveCB);
    runRegistrarOnce(pvar_func_register_func_CADdriveDB);
    runRegistrarOnce(pvar_func_register_func_CADdriveFollower);
    runRegistrarOnce(pvar_func_register_func_CADdriveOffloader);
    runRegistrarOnce(pvar_func_register_func_CADdriveXY);
    runRegistrarOnce(pvar_func_register_func_CADfocusPidControl);
    runRegistrarOnce(pvar_func_register_func_CADfollow);
    runRegistrarOnce(pvar_func_register_func_CADfreeRun);
    runRegistrarOnce(pvar_func_register_func_CADguideConfig);
    runRegistrarOnce(pvar_func_register_func_CADguideControl);
    runRegistrarOnce(pvar_func_register_func_CADguideReset);
    runRegistrarOnce(pvar_func_register_func_CADguideSimCont);
    runRegistrarOnce(pvar_func_register_func_CADinit);
    runRegistrarOnce(pvar_func_register_func_CADinitXY);
    runRegistrarOnce(pvar_func_register_func_CADmove);
    runRegistrarOnce(pvar_func_register_func_CADmoveBaffle);
    runRegistrarOnce(pvar_func_register_func_CADmovePeriscope);
    runRegistrarOnce(pvar_func_register_func_CADpark);
    runRegistrarOnce(pvar_func_register_func_CADphasorControl);
    runRegistrarOnce(pvar_func_register_func_CADreboot);
    runRegistrarOnce(pvar_func_register_func_CADservoBandwidth);
    runRegistrarOnce(pvar_func_register_func_CADsetPhasorControl);
    runRegistrarOnce(pvar_func_register_func_CADsetVTKControl);
    runRegistrarOnce(pvar_func_register_func_CADsimulate);
    runRegistrarOnce(pvar_func_register_func_CADstop);
    runRegistrarOnce(pvar_func_register_func_CADtest);
    runRegistrarOnce(pvar_func_register_func_CADtiltPidControl);
    runRegistrarOnce(pvar_func_register_func_CADtolerance);
    runRegistrarOnce(pvar_func_register_func_CADvtkControl);
    runRegistrarOnce(pvar_func_register_func_cadDirLog);
    runRegistrarOnce(pvar_func_register_func_calcEnvelope);
    runRegistrarOnce(pvar_func_register_func_carDrive1);
    runRegistrarOnce(pvar_func_register_func_carDrive2);
    runRegistrarOnce(pvar_func_register_func_carDrive3);
    runRegistrarOnce(pvar_func_register_func_decimate);
    runRegistrarOnce(pvar_func_register_func_displayScs);
    runRegistrarOnce(pvar_func_register_func_displayScs2);
    runRegistrarOnce(pvar_func_register_func_driveEvent);
    runRegistrarOnce(pvar_func_register_func_dummyInit);
    runRegistrarOnce(pvar_func_register_func_dummyInitGenSub);
    runRegistrarOnce(pvar_func_register_func_gensubFanDoubles);
    runRegistrarOnce(pvar_func_register_func_getTime);
    runRegistrarOnce(pvar_func_register_func_guideConfig);
    runRegistrarOnce(pvar_func_register_func_guideSimProc);
    runRegistrarOnce(pvar_func_register_func_highSpeed);
    runRegistrarOnce(pvar_func_register_func_highSpeed2);
    runRegistrarOnce(pvar_func_register_func_initDecimate);
    runRegistrarOnce(pvar_func_register_func_initFollowGenSub);
    runRegistrarOnce(pvar_func_register_func_initHighSpeed);
    runRegistrarOnce(pvar_func_register_func_initHighSpeed2);
    runRegistrarOnce(pvar_func_register_func_initInterlock);
    runRegistrarOnce(pvar_func_register_func_initSelector);
    runRegistrarOnce(pvar_func_register_func_initTime);
    runRegistrarOnce(pvar_func_register_func_issueM2Primitive);
    runRegistrarOnce(pvar_func_register_func_lockMonitor);
    runRegistrarOnce(pvar_func_register_func_lookupGuide);
    runRegistrarOnce(pvar_func_register_func_mechSim);
    runRegistrarOnce(pvar_func_register_func_percentCalc);
    runRegistrarOnce(pvar_func_register_func_pulseSteerCAD);
    runRegistrarOnce(pvar_func_register_func_readHealth);
    runRegistrarOnce(pvar_func_register_func_readHealthInit);
    runRegistrarOnce(pvar_func_register_func_readM2Diagnostics);
    runRegistrarOnce(pvar_func_register_func_readM2DiagnosticsInit);
    runRegistrarOnce(pvar_func_register_func_real2Drive);
    runRegistrarOnce(pvar_func_register_func_realDrive);
    runRegistrarOnce(pvar_func_register_func_receiveTcsDemand);
    runRegistrarOnce(pvar_func_register_func_resetGuideConfig);
    runRegistrarOnce(pvar_func_register_func_scsStateStringConvert);
    runRegistrarOnce(pvar_func_register_func_scsStateStringInit);
    runRegistrarOnce(pvar_func_register_func_selector);
    runRegistrarOnce(pvar_func_register_func_sirDisplayFrame);
    runRegistrarOnce(pvar_func_register_func_sirDisplayTime);
    runRegistrarOnce(pvar_func_register_func_sirHealth);
    runRegistrarOnce(pvar_func_register_func_sirRArcsecs);
    runRegistrarOnce(pvar_func_register_func_sirRDegs);
    runRegistrarOnce(pvar_func_register_func_sirRaDecSys);
    runRegistrarOnce(pvar_func_register_func_sirSDegsSigned);
    runRegistrarOnce(pvar_func_register_func_sirSDegsUnsigned);
    runRegistrarOnce(pvar_func_register_func_sirSHrs);
    runRegistrarOnce(pvar_func_register_func_snlStateInit);
    runRegistrarOnce(pvar_func_register_func_snlStateMonitor);
    runRegistrarOnce(pvar_func_register_func_snlStateStringConvert);
    runRegistrarOnce(pvar_func_register_func_snlStateStringInit);
    runRegistrarOnce(pvar_func_register_func_stateInit);
    runRegistrarOnce(pvar_func_register_func_stateMonitor);
    runRegistrarOnce(pvar_func_register_func_statusDrive);
    runRegistrarOnce(pvar_func_register_func_ticker);
    runRegistrarOnce(pvar_func_register_func_timeClockCheck);
    runRegistrarOnce(pvar_func_register_func_timeClockReport);
    runRegistrarOnce(pvar_func_register_func_timeDump);
    iocshRegisterVariable(vardefs);
    return 0;
}

/* scs_mk_ioc_registerRecordDeviceDriver */
static const iocshArg rrddArg0 = {"pdbbase", iocshArgPdbbase};
static const iocshArg *rrddArgs[] = {&rrddArg0};
static const iocshFuncDef rrddFuncDef = {
    "scs_mk_ioc_registerRecordDeviceDriver",
    1,
    rrddArgs,
    "Register the various records, devices, for this DBD.\n\n"
    "These are registered into the database given as first argument,\n"
    "which should always be 'pdbbase'.\n\n"
    "Example: scs_mk_ioc_registerRecordDeviceDriver pdbbase\n",
};
static void rrddCallFunc(const iocshArgBuf *)
{
    iocshSetError(scs_mk_ioc_registerRecordDeviceDriver(*iocshPpdbbase));
}

} // extern "C"

/*
 * Register commands on application startup
 */
static int Registration() {
    iocshRegisterCommon();
    iocshRegister(&rrddFuncDef, rrddCallFunc);
    return 0;
}

static int done EPICS_UNUSED = Registration();
