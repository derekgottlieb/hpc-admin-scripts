#!/bin/bash
# 2013-06-18: Derek Gottlieb (asndbg)
#
# Tries to be a faster version of the opcode scanner by doing a single grep for
# all of the OPCODES in the specified file instead of one grep per opcode.

usage()
{
 cat << EOF
 Usage: $0 options

 OPTIONS:
  -h       Show this message
  -v       Verbose
  -b file  Binary file
  -d file  "objdump -d" output for binary
  -o file  File containing OPCODES to test for
EOF
}

VERBOSE=0
BINARY=
OBJDUMP_FILE=
DELETE_OBJDUMP_FILE=1
OPCODES=

while getopts "hvb:d:o:" OPTION
do
 case $OPTION in
  h)
   usage
   exit 1
   ;;
  v)
   VERBOSE=1
   ;;
  b)
   BINARY=$OPTARG
   ;;
  d)
   OBJDUMP_FILE=$OPTARG
   DELETE_OBJDUMP_FILE=0
   ;;
  o)
   OPCODES_FILE=$OPTARG
   ;;
  ?)
   usage
   exit 1
   ;;
 esac
done

if [ -z $OPCODES_FILE ]; then
 usage
 exit 1
fi

if [ -z $OBJDUMP_FILE ] && [ -z $BINARY ]; then
 usage
 exit 1
fi

if [ -z $OBJDUMP_FILE ]; then 
 OBJDUMP_FILE=$(mktemp)
 objdump --no-show-raw-insn -d $BINARY > $OBJDUMP_FILE
fi

FOUND=0

#OPCODES=$(cat $OPCODES_FILE | sed ':a;N;$!ba;s/\n/|/g' | sed -e 's/ //g')
OPCODES=$(cat $OPCODES_FILE | sed ':a;N;$!ba;s/\n/ |/g')

op_found=$(grep -c -E "$OPCODES " $OBJDUMP_FILE)
if [ $op_found -gt 0 ]; then
 echo "Found opcode(s) from $OPCODES_FILE!"
fi

if [ $DELETE_OBJDUMP_FILE -gt 0 ]; then
 rm -f $OBJDUMP_FILE
fi

exit 0
