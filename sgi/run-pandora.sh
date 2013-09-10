#!/bin/bash
# 2013-06-05: Derek Gottlieb (asndbg)
#
# Run SGI's pandora set to test 95% of free system memory
# Accepts runtime in minutes as cli arg, or will prompt if not specified

if [ -z $1 ]; then
 printf "\nEnter desired runtime in minutes: "
 read RUNTIME
else
 RUNTIME=$1
fi

pandora -runtime ${RUNTIME} PERCENT=95
