#!/bin/bash

LEVEL="00"

USER="level$LEVEL"
PASSWORD="level00"

CURDIR=`dirname $0`
SCRIPT="$CURDIR/script.sh"

if [ -z ${SNOW_HOST+x} ]; then read -p "VM Host: " SNOW_HOST; fi
if [ -z ${SNOW_PORT+x} ]; then read -p "VM Port: " SNOW_PORT; fi

echo -e "$USER Password is: $PASSWORD"

# Run script.sh on level user
ssh -t -q $USER@$SNOW_HOST -p $SNOW_PORT < $SCRIPT

# Then check flag on flag user
FLAG_LEVEL="flag$LEVEL"
FLAG_CONTENT=`cat $CURDIR/../flag`

ssh -q $FLAG_LEVEL@$SNOW_HOST -p $SNOW_PORT "getflag"
echo -e "\nExpected flag: $FLAG_CONTENT"