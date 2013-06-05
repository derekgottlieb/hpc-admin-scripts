#!/bin/bash
# 2013-06-05: Derek Gottlieb (asndbg)
#
# List current active moab server (useful when running moab HA configuration)

mdiag -S -v | grep "running on"
