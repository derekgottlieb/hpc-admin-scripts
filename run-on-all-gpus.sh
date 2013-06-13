#!/bin/bash
# 2013-06-13: Derek Gottlieb (asndbg)
#
# Quick and dirty script that determines available NVIDIA GPUs and runs a
# specified binary on each

if [ -z $1 ]; then
 echo "Usage: $0 gpu_binary"
 exit
fi

GPUBIN=$1

# Count the number of NVIDIA controllers found
N3D=$(/sbin/lspci | grep -i NVIDIA | grep "3D controller" | wc -l)
NVGA=$(/sbin/lspci | grep -i NVIDIA | grep "VGA compatible controller" | wc -l)

# How many gpus?
NUM_GPUS=$(expr $N3D + $NVGA - 1)

n=0
while [ $n -le $NUM_GPUS ]; do
 printf "\n##### Testing GPU $n...\n\n"
 export CUDA_VISIBLE_DEVICES=$n
 $GPUBIN
 n=$((n + 1))
done
