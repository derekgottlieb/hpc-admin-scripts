#!/bin/bash

usage()
{
 cat << EOF
 Usage: $0 options

 OPTIONS:
  -h       Show this message
  -v       Verbose
  -b file  Binary file
  -d file  "objdump -d" output for binary
  -o file  File containing opcodes to test for
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
   OPCODES=$OPTARG
   ;;
  ?)
   usage
   exit 1
   ;;
 esac
done

if [ -z $OPCODES ]; then
 usage
 exit 1
fi

if [ -z $OBJDUMP_FILE ] && [ -z $BINARY ]; then
 usage
 exit 1
fi

if [ -z $OBJDUMP_FILE ]; then 
 OBJDUMP_FILE=$(mktemp)
 objdump -d $BINARY > $OBJDUMP_FILE
fi

FOUND=0
for op in $(cat $OPCODES)
do
 [ "$VERBOSE" -gt 0 ] && printf "\tTesting $op..."
 op_found=$(grep -c "$op " $OBJDUMP_FILE)
 [ "$VERBOSE" -gt 0 ] && printf "$op_found"

 if [ $op_found -gt 0 ]; then
  [ "$VERBOSE" -gt 0 ] && printf "\tFound $op!"
  FOUND=$((FOUND + 1))
 fi
 printf "\n"
done

printf "\tFound $FOUND different opcodes from $OPCODES\n\n"

if [ $DELETE_OBJDUMP_FILE -gt 0 ]; then
 rm -f $OBJDUMP_FILE
fi

exit 0
