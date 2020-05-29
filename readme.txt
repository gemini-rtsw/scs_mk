



telnet 10.1.5.85 2305

# Boot test version on sim5.
configure-ioc -t work   \
   -b /gem_sw/test/tcumming/ioc/scs/mk/bin/RTEMS-mvme3100/scs-mk-ioc.boot    \
   -s /gem_sw/test/tcumming/ioc/scs/mk/bin/RTEMS-mvme3100/stscs-mk-ioc.boot  \
   sim5

configure-ioc -t work   \
   -b /gem_sw/test/tcumming/ioc/scs/mk/bin/RTEMS-beatnik/scs-mk-ioc.boot    \
   -s /gem_sw/test/tcumming/ioc/scs/mk/bin/RTEMS-beatnik/stscs-mk-ioc.boot  \
   sim5

# Boot test version on real scs (only one change from above)
configure-ioc -t work   \
   -b /gem_sw/test/tcumming/ioc/scs/mk/bin/RTEMS-mvme2307/scs-mk-ioc.boot    \
   -s /gem_sw/test/tcumming/ioc/scs/mk/bin/RTEMS-mvme2307/stscs-mk-ioc.boot  \
   scs-mk-ioc


# Boot back to production version.
# WARNING: The order of -b XXX and -s XXX is important. -b must be first
configure-ioc -t prod   \
   -b /gem_sw/prod/R3.14.12.7/ioc/scs/mk/4-4baffle_diagsBR5/bin/RTEMS-mvme2307/scs-mk-ioc.boot \
   -s /gem_sw/prod/R3.14.12.7/ioc/scs/mk/4-4baffle_diagsBR5/bin/RTEMS-mvme2307/stscs-mk-ioc.boot \
   scs-mk-ioc

configure-ioc -t prod   \
   -b /gem_sw/prod/R3.14.12.8/ioc/scs/mk/4-5/bin/RTEMS-mvme2307/scs-mk-ioc.boot    \
   -s /gem_sw/prod/R3.14.12.8/ioc/scs/mk/4-5/bin/RTEMS-mvme2307/stscs-mk-ioc.boot  \
   scs-mk-ioc


# Update boot parms to switch to epics.8 lv2 server.
PPC1-Bug>niot
Controller LUN =00? 
Device LUN     =00? 
Node Control Memory Address =0FF9E000? 
Client IP Address      =10.2.2.107? 
Server IP Address      =10.2.71.11? 10.2.71.12
Subnet IP Address Mask =255.255.255.0? 
Broadcast IP Address   =10.2.2.255? 
Gateway IP Address     =10.2.2.1? 
Boot File Name ("NULL" for None)     =/gem_sw/prod/redirector/scs-mk-ioc? 
Argument File Name ("NULL" for None) =10.2.71.11:/gem_sw:prod/redirector/scs-mk-ioc.cmd? 10.2.71.12:/gem_sw:prod/redirector/scs-mk-ioc.cmd
Boot File Load Address         =001F0000? 
Boot File Execution Address    =001F0000? 
Boot File Execution Delay      =00000000? 
Boot File Length               =00000000? 
Boot File Byte Offset          =00000000? 
BOOTP/RARP Request Retry       =00? 
TFTP/ARP Request Retry         =00? 
Trace Character Buffer Address =00000000? 
BOOTP/RARP Request Control: Always/When-Needed (A/W)=W? 
BOOTP/RARP Reply Update Control: Yes/No (Y/N)       =Y? 

Update Non-Volatile RAM (Y/N)? Y


# Release new version.
gem-release.py -i -m "Added dynamic config, moved to epics.8" scs/mk 4-5

