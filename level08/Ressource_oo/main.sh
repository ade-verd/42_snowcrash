#!/bin/bash

LEVEL="08"
PW="fiumuikeil55xe9cu4dood66h"

export SNOW_USER="level$LEVEL"
export SNOW_PORT="4242"

if [ -z ${SNOW_HOST+x} ]; then read -p "VM Host: " SNOW_HOST; fi

CURDIR=`dirname $0`
FLAG_CONTENT=`cat $CURDIR/../flag`

# Connect to 'level08'
echo -e "\n\n$SNOW_USER password is : $PW\n"
ssh -p $SNOW_PORT $SNOW_USER@$SNOW_HOST 'bash' < $CURDIR/script.sh
# Connect to 'flag08' to get the flag
ssh -q -p $SNOW_PORT flag08@$SNOW_HOST getflag
echo -e "\nExpected flag: $FLAG_CONTENT"