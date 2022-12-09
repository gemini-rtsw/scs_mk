TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build the IOC application

#USR_CFLAGS += -DMK

PROD_IOC_RTEMS = scs-mk-ioc
# scs-mk-ioc.dbd will be created and installed
DBD += scs-mk-ioc.dbd

# scs-mk-ioc.dbd will be made up from these files:
scs-mk-ioc_DBD += base.dbd
# scs-mk-ioc_DBD += iocAdmin.dbd
# scs-mk-ioc_DBD += menuScan.dbd
scs-mk-ioc_DBD += geminiRecords.dbd
scs-mk-ioc_DBD += vmi5588Supp.dbd
scs-mk-ioc_DBD += xy240Supp.dbd
scs-mk-ioc_DBD += tcslibSupp.dbd
scs-mk-ioc_DBD += bancommDev.dbd
scs-mk-ioc_DBD += pvload.dbd
scs-mk-ioc_DBD += timelibSupp.dbd
scs-mk-ioc_DBD += slalib.dbd
scs-mk-ioc_DBD += timeProbeSupp.dbd
scs-mk-ioc_DBD += listAlarmRecords.dbd
scs-mk-ioc_DBD += systemTickTools.dbd
scs-mk-ioc_DBD += initTrace.dbd
scs-mk-ioc_DBD += symb.dbd
scs-mk-ioc_DBD += scs.dbd

# scs-mk-ioc_registerRecordDeviceDriver.cpp derives from scs-mk-ioc.dbd
scs-mk-ioc_SRCS += scs-mk-ioc_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
scs-mk-ioc_SRCS_DEFAULT += scs-mk-iocMain.cpp

scs-mk-ioc_SRCS += m2Log.c
scs-mk-ioc_SRCS += chop.c
scs-mk-ioc_SRCS += chopControl.c
scs-mk-ioc_SRCS += config.c
scs-mk-ioc_SRCS += control.c
scs-mk-ioc_SRCS += dmDrive.c
scs-mk-ioc_SRCS += house.c
scs-mk-ioc_SRCS += interlock.c
scs-mk-ioc_SRCS += interp.c
scs-mk-ioc_SRCS += scs.c
scs-mk-ioc_SRCS += setup.c
scs-mk-ioc_SRCS += testFunctions.c
scs-mk-ioc_SRCS += tiltSim.c
scs-mk-ioc_SRCS += utilities.c
scs-mk-ioc_SRCS += eventBus.c
scs-mk-ioc_SRCS += m2ParseMsg.c
scs-mk-ioc_SRCS += showEngineering.c
scs-mk-ioc_SRCS += guide.c
scs-mk-ioc_SRCS += scs.syms.cpp

LIBRARY_IOC += scsSupport
scsSupport_LIBS += seq pv
scsSupport_LIBS += $(EPICS_BASE_IOC_LIBS)
scsSupport_SRCS += scs_st.st
scsSupport_SRCS += tilt_st.st
scsSupport_SRCS += scs_mon.st

# Add all the support libraries used by this IOC
scs-mk-ioc_LIBS += geminiRecords
scs-mk-ioc_LIBS += vmi5588
scs-mk-ioc_LIBS += xy240
scs-mk-ioc_LIBS += bancomm 
scs-mk-ioc_LIBS += pvload
scs-mk-ioc_LIBS += tcslib
scs-mk-ioc_LIBS += timelib
scs-mk-ioc_LIBS += slalib
# scs-mk-ioc_LIBS += devIocStats 
scs-mk-ioc_LIBS += timeProbe 
scs-mk-ioc_LIBS += listAlarmRecords 
scs-mk-ioc_LIBS += systemTickTools 
scs-mk-ioc_LIBS += initTrace
scs-mk-ioc_LIBS += Symb 

# Finally link to the EPICS Base libraries
scs-mk-ioc_LIBS += scsSupport seq pv

scs-mk-ioc_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

