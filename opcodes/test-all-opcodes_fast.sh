#!/bin/bash

if [ -z $1 ]; then
 echo "Usage: $0 binary"
 exit 1
else
 binary=$1
fi

for f in *.txt
do
 echo "Testing $f..."
 #./test-opcodes.sh $f $binary
 ./test-opcodes_fast.sh $f $binary
done
