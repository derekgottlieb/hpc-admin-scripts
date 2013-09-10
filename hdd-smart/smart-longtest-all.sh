#!/bin/bash
# 2013-09-10: Derek Gottlieb (asndbg)

SCRIPTPATH=$(dirname $(readlink -f $0))

for DRIVE in /dev/sd[a-z]
do
 echo $DRIVE
 ${SCRIPTPATH}/smart-longtest.sh $DRIVE &
done

wait
