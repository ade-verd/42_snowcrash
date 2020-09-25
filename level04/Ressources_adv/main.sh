#!/bin/bash

LEVEL="04"

CURDIR=`dirname "$(readlink -f "$0")"`

PREV_LEVEL=`printf "%02d" $(($LEVEL-1))`
PW=`cat $CURDIR/../../level$PREV_LEVEL/flag`

SNOW_USER="level$LEVEL"

if [ -z ${SNOW_HOST+x} ]; then read -p "VM Host: " SNOW_HOST; fi
if [ -z ${SNOW_PORT+x} ]; then read -p "VM Port: " SNOW_PORT; fi

FLAG_CONTENT=`cat $CURDIR/../flag`

# Connect to 'level04'
echo -e "\n$SNOW_USER password is : $PW\n"
ssh -p $SNOW_PORT $SNOW_USER@$SNOW_HOST 'bash' < $CURDIR/script.sh
echo -e "\nExpected flag: $FLAG_CONTENT"