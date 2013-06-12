#!/bin/bash
# 2013-06-12: Derek Gottlieb (asndbg)
#
# Determine system serial number for known SGI systems. Tested on UV2000, Altix
# 350, Altix 450, Rackable Intel server

if [ -e /proc/sgi_uv/system_serial_number ]; then
 echo "##### /proc/sgi_uv/system_serial_number"
 cat /proc/sgi_uv/system_serial_number
 exit
fi

if [ -e /proc/sgi_sn/system_serial_number ]; then
 echo "##### /proc/sgi_sn/system_serial_number"
 cat /proc/sgi_sn/system_serial_number
 exit
fi

echo "##### dmidecode -s system-serial-number"
dmidecode -s system-serial-number
