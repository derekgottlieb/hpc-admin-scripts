#!/bin/bash
# 2013-05-29: Derek Gottlieb (asndbg)
#
# Run sys_basher with starting thread count based on number of detected cores
# Accepts runtime in minutes as cli arg, or will prompt if not specified
#
# sys_basher source available at http://www.polybus.com/sys_basher_web/


if [ -z $1 ]; then
 printf "\nEnter desired runtime in minutes: "
 read RUNTIME
else
 RUNTIME=$1
fi

# Determine number of cores
NUM_CORES=$(cat /proc/cpuinfo  | grep ^processor | wc -l)

# Runtime in minutes: -mi N
./sys_basher -mi ${RUNTIME} -ts ${NUM_CORES}

# Runtime in hours: -ho N
#./sys_basher -ho 48 -ts ${NUM_CORES}

