#!/bin/bash
# 2013-09-10: Derek Gottlieb (asndbg)

ADMIN_EMAIL="sysadmin@example.company"

if [ -z $1 ]; then
 echo "Usage $0 /dev/sda"
 exit
fi

DRIVE=$1

echo $DRIVE

# Kick off the SMART extended self-test (drive controller runs it in the
# background, so you have to poll using smartctl to see the status of the test
# and get results)
smartctl --test=long $DRIVE

sleep 60
TICK=0
while [ 1 ]
do
 # Grep out just extended offline test results
 TEST_STATUS=$(smartctl --log=selftest $DRIVE | grep "Extended offline")

 # If we see any line that shows "in progress", there's a self-test actively
 # running
 IS_IN_PROGRESS=$(echo $TEST_STATUS | grep "in progress" | wc -l)
 if [ $TICK -eq 23 ]; then
  IS_IN_PROGRESS=0
 fi
 if [ $IS_IN_PROGRESS -eq 0 ]; then
  # Get the full output for the drive, and look for any failed tests
  FULL_OUT=$(smartctl -i --attributes --log=selftest $DRIVE)
  IS_FAILED=$(echo $TEST_STATUS | grep fail | wc -l)
  if [ $IS_FAILED -gt 0 ]; then
   logger -s -t "SMART-SELF-TEST" "SMART ERROR: $DRIVE reporting self-test failure ($TEST_STATUS)"
   echo -e "$FULL_OUT" | mail -s "SMART ERROR: $DRIVE reporting self-test failure on $HOSTNAME" $ADMIN_EMAIL
  else
   # If we didn't see any failed tests, assume tests passed
   echo -e "$FULL_OUT" | mail -s "SMART OK: $DRIVE reporting self-test on $HOSTNAME" $ADMIN_EMAIL
  fi
  exit
 fi
 # Only check once an hour
 TICK=$(($TICK + 1 ))
 sleep 3600
done

