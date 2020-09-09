#!/bin/bash

LEVEL="00"

export SNOW_USER="level$LEVEL"
export SNOW_PORT="4242"

if [ -z ${SNOW_HOST+x} ]; then read -p "VM Host: " SNOW_HOST; fi
if [ -z ${SNOW_PORT+x} ]; then read -p "VM Port (ex: 4242): " SNOW_PORT; fi
if [ -z ${SNOW_USER+x} ]; then read -p "VM User (ex: level00): " SNOW_USER; fi

CURDIR=`dirname $0`
SCRIPT="$CURDIR/script.sh"

# Run script.sh on level user
ssh -t -q $SNOW_USER@$SNOW_HOST -p $SNOW_PORT "bash -s" -- < $SCRIPT

# Then check flag on flag user
FLAG_LEVEL="flag$LEVEL"
FLAG_CONTENT=`cat $CURDIR/../flag`

ssh -t -q $FLAG_LEVEL@$SNOW_HOST -p $SNOW_PORT "getflag"
echo -e "\nExpected flag: $FLAG_CONTENT"