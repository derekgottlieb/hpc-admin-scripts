#!/bin/bash

if [ -z $1 ]; then
 echo "Usage: $0 opcodes.txt binary"
 exit
else
 opcodes_file=$1
fi

if [ -z $2 ]; then
 echo "Usage: $0 opcodes.txt binary"
 exit
else
 binary=$2
fi

tmpfile=$(mktemp)

objdump -d $binary > $tmpfile

#opcodes=$(cat $opcodes_file | sed ':a;N;$!ba;s/\n/|/g' | sed -e 's/ //g')
opcodes=$(cat $opcodes_file | sed ':a;N;$!ba;s/\n/ | /g')

op_found=$(grep -c -E " $opcodes " $tmpfile)
if [ $op_found -gt 0 ]; then
 echo "Found opcode from $opcodes_file in $binary!"
 rm -f $tmpfile
 exit 1
fi

rm -f $tmpfile
exit 0
