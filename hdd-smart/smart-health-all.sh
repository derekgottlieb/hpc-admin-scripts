#!/bin/bash
# 2013-09-10: Derek Gottlieb (asndbg)

for drive in /dev/sd[a-z]
do
 HEALTH=$(smartctl -H $drive | grep ^SMART)
 echo "$drive: $HEALTH"
done
