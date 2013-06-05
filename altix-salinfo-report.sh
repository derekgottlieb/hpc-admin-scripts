#!/bin/bash
# 2013-06-05: Derek Gottlieb (asndbg)
#
# SGI logs hardware errors for IA-64 Altix systems to /var/log/salinfo. This 
# script is intended to run daily via cronjob to summarize hardware errors we
# know how to parse (e.g., memory DIMM ECC errors) and notify the sysadmin via 
# email

ADMIN_EMAIL="sysadmin@example.company"

# Look for salinfo entries created in the past 24 hours (-ctime was -1? trying 0)
filelist=$(find /var/log/salinfo/decoded -maxdepth 1 -type f -ctime 0 -size +0 | grep -v oemdata)

filecount=0
for salfile in $filelist
do
 ((filecount=$filecount+1))
done

if [ "$filelist" != "" ]
then
 CURRENTMONTH=$(date +%Y-%m)

 rm -f /tmp/salinfo_files.$DATE /tmp/salinfo_knownfiles.$DATE

 CMC_FOUND=$(find /var/log/salinfo/decoded -name ${CURRENTMONTH}*-cmc* | wc -l)
 if [ "$CMC_FOUND" -gt 0 ]; then
  cmcfilelist=$(find /var/log/salinfo/decoded/*cmc* -maxdepth 1 -type f -ctime 0 -size
 +0)
  echo $cmcfilelist >> /tmp/salinfo_knownfiles.$DATE
 fi
 CPE_FOUND=$(find /var/log/salinfo/decoded -name ${CURRENTMONTH}*-cpe* | wc -l)
 if [ "$CPE_FOUND" -gt 0 ]; then
  cpefilelist=$(find /var/log/salinfo/decoded/*cpe* -maxdepth 1 -type f -ctime 0 -size
 +0)
  echo $cpefilelist >> /tmp/salinfo_knownfiles.$DATE
 fi
 echo $filelist > /tmp/salinfo_files.$DATE
 sort /tmp/salinfo_files.$DATE > /tmp/salinfo_files.$DATE.s

 if [ -e /tmp/salinfo_files.$DATE ]; then
  sort /tmp/salinfo_knownfiles.$DATE > /tmp/salinfo_knownfiles.$DATE.s
  UNKNOWN_FILES=$(diff /tmp/salinfo_files.$DATE.s /tmp/salinfo_knownfiles.$DATE.s)
 else
  UNKNOWN_FILES=$filelist
 fi

 DIMMS=$(grep DIMM /var/log/salinfo/decoded/${CURRENTMONTH}* | grep -v oemdata | awk -
F":" '{print $3, $4}' | sort | uniq -c | sort -n)
 PROC_CMC=$(grep PROC_CMC /var/log/salinfo/decoded/${CURRENTMONT}* | grep -v oemdata)

 printf "$filecount new salinfo files on $HOSTNAME\n\nDIMM error counts (this month): \n\n$DIMMS\n\nPROC_CMC (this month):\n$PROC_CMC\n\nThese nonzero files were created in the last 24 hours:\n$filelist\n\nCMC Files:\n$cmcfilelist\n\nCPE Files:\n$cpefilelist\n\nUnknown Files:\n$UNKNOWN_FILES\n\n" | mail -s "$filecount new salinfo files on $HOSTNAME" ${ADMIN_EMAIL}
fi
