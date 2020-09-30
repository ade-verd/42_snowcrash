#!/bin/bash

LEVEL='08'

CURDIR=`dirname "$(readlink -f "$0")"`

PREV_LEVEL=`printf "%02d" $((10#$LEVEL-1))`
PW=`cat $CURDIR/../../level$PREV_LEVEL/flag`

SNOW_USER="level$LEVEL"

if [ -z ${SNOW_HOST+x} ]; then read -p "VM Host: " SNOW_HOST; fi
if [ -z ${SNOW_PORT+x} ]; then read -p "VM Port: " SNOW_PORT; fi

FLAG_CONTENT=`cat $CURDIR/../flag`

# Connect to 'level08'
echo -e "\n$SNOW_USER password is : $PW\n"
ssh -t -p $SNOW_PORT $SNOW_USER@$SNOW_HOST 'bash' < $CURDIR/script.sh

# Connect to 'flag08' to get the flag
ssh -q -p $SNOW_PORT flag08@$SNOW_HOST getflag
echo -e "\nExpected flag: $FLAG_CONTENT"