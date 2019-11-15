

# Boot test version on sim5.
configure-ioc -t work   \
   -b /gem_sw/test/tcumming/ioc/scs/mk/bin/RTEMS-mvme3100/scs-mk-ioc.boot    \
   -s /gem_sw/test/tcumming/ioc/scs/mk/bin/RTEMS-mvme3100/stscs-mk-ioc.boot  \
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
