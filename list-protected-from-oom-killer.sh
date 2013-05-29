#!/bin/bash
# 2013-05-29: Derek Gottlieb (asndbg)
#
# List PIDs that are protected from the Linux OOM killer

for PROCDIR in /proc/[0-9]*
do 
 PID=$(echo $PROCDIR | sed -e 's/\/proc\///')
 if [ -f $PROCDIR/oom_adj ]; then
  OOM=$(cat $PROCDIR/oom_adj)
  if [ "$OOM" != "0" ]; then 
   echo "$PID: $OOM"
   ps $PID
  fi
 fi
done

