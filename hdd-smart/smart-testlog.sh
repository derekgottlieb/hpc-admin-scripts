#!/bin/bash
# 2013-09-10: Derek Gottlieb (asndbg)

for drive in /dev/sd[a-z]
do
 smartctl --log=selftest $drive
done
