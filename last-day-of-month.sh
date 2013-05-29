#!/bin/bash
# 2013-05-29: Derek Gottlieb (asndbg)
#
# Simple script to determine if today is the last day of the month

TODAY=$(/bin/date +%d)
TOMORROW=$(/bin/date +%d -d "1 day")

# See if tomorrow's day is less than today's
if [ $TOMORROW -lt $TODAY ]; then
 exit 0
fi

exit 1
