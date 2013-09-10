#!/bin/bash
# 2013-09-10: Derek Gottlieb (asndbg)

errors_found=0

for drive in /dev/sd[a-z]
do
 ata_error=$(smartctl -a $drive | grep -c "ATA Error")
 if [ $ata_error -gt 0 ]; then
  echo "ATA Error found on $drive on $HOSTNAME"
  errors_found=$((errors_found + 1))
 fi
done

if [ "$errors_found" -eq 0 ]; then
 echo "No disk issues found on $HOSTNAME"
else
 echo "Found $errors_found disks with issues on $HOSTNAME"
fi
