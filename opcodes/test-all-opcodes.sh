#!/bin/bash
# 2013-06-18: Derek Gottlieb (asndbg)
# 
# Generate objdump dump output for the specified binary and then run feed that
# into the scanner for every opcode .txt file found in this directory.

usage()
{
 cat << EOF
 Usage: $0 options

 OPTIONS:
  -h       Show this message
  -v       Verbose
  -f       Run "fast" version (single grep, less info about which opcodes found)
  -b file  Binary file
EOF
}

VERBOSE=0
VERBOSE_FLAG=""
BINARY=
FAST_GREP=0

while getopts "hvb:d:o:" OPTION
do
 case $OPTION in
  h)
   usage
   exit 1
   ;;
  v)
   VERBOSE=1
   VERBOSE_FLAG="-v"
   ;;
  b)
   BINARY=$OPTARG
   ;;
  f)
   FAST_GREP=1
   ;;
  ?)
   usage
   exit 1
   ;;
 esac
done

if [ -z $BINARY ]; then
 usage
 exit 1
fi

OBJDUMP_FILE=$(mktemp)
objdump -d $BINARY > $OBJDUMP_FILE

for OPCODE_FILE in *.txt
do
 echo "Testing $OPCODE_FILE..."
 if [ $FAST_GREP -gt 0 ]; then
  ./test-opcodes_fast.sh $VERBOSE_FLAG -o $OPCODE_FILE -d $OBJDUMP_FILE
 else
  ./test-opcodes.sh $VERBOSE_FLAG -o $OPCODE_FILE -d $OBJDUMP_FILE
 fi
done

rm -f $OBJDUMP_FILE
