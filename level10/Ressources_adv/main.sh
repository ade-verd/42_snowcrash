#!/bin/bash

LEVEL="10"

CURDIR=`dirname "$(readlink -f "$0")"`

PREV_LEVEL=`printf "%02d" $(($LEVEL-1))`
USER="level$LEVEL"
PW=`cat $CURDIR/../../level$PREV_LEVEL/flag`

OUTPUT="/tmp/output"

if [ -z ${SNOW_HOST+x} ]; then read -p "VM Host: " SNOW_HOST; fi
if [ -z ${SNOW_PORT+x} ]; then read -p "VM Port: " SNOW_PORT; fi

# Then check flag on flag user
FLAG_LEVEL="flag$LEVEL"
FLAG_CONTENT=`cat $CURDIR/../flag`

# Connect to 'level10' and run the script
echo -e "\n$USER password is : $PW\n"
(set -x
ssh -t -q -p $SNOW_PORT $USER@$SNOW_HOST 'bash' < $CURDIR/script.sh | tee $OUTPUT)

LASTLINE=`awk '/./{line=$0} END{print line}' $OUTPUT`
if [[ "$LASTLINE" == *"Please retry"* ]]; then exit 1; fi

# Check flag password and token
(set -x
ssh -q $FLAG_LEVEL@$SNOW_HOST -p $SNOW_PORT "getflag")
echo -e "\nExpected flag: $FLAG_CONTENT"