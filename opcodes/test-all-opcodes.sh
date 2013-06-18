#!/bin/bash

usage()
{
 cat << EOF
 Usage: $0 options

 OPTIONS:
  -h       Show this message
  -v       Verbose
  -b file  Binary file
EOF
}

VERBOSE=0
VERBOSE_FLAG=""
BINARY=

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
 echo "Testing $f..."
 ./test-opcodes.sh $VERBOSE_FLAG -o $OPCODE_FILE -d $OBJDUMP_FILE
done

rm -f $OBJDUMP_FILE
