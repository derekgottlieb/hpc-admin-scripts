#!/bin/bash
# 2013-06-05: Derek Gottlieb (asndbg)
#
# List current active pbs_server (useful when running torque HA configuration)

qmgr -c 'list server' 2>/dev/null | grep "^Server"
