#!/bin/bash
# 2013-05-29: Derek Gottlieb (asndbg)
#
# Determine longest walltime remaining for jobs running on a node
#
# Tested with Torque / Moab, may work with Maui if checknode output for running
# jobs is the same

NODENAME=$1
NODE="$1/"

JOBCOUNT=$(qstat -an1 | grep $NODE | awk '{ if ($10 == "R") {print $1} }' | wc -l)
if [ $JOBCOUNT -gt 0 ]; then
 TIMELEFT=$(checknode $NODENAME | grep Runn | awk '{print $5}' | sort -rg | head -n 1)
 printf "$NODENAME: $TIMELEFT\n"

else
 echo "Node Drained: $NODENAME"
fi
