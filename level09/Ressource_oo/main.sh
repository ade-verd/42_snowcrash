#!/bin/bash

LEVEL="09"
PW="25749xKZ8L7DkSCwJkT9dyv6f"

export SNOW_USER="level$LEVEL"
export SNOW_PORT="4242"

if [ -z ${SNOW_HOST+x} ]; then read -p "VM Host: " SNOW_HOST; fi

CURDIR=`dirname $0`
FLAG_CONTENT=`cat $CURDIR/../flag`
FLAG="flag$LEVEL"

# Connect to 'level09'
echo -e "\n\n$SNOW_USER password is : $PW\n"
ssh -p $SNOW_PORT $SNOW_USER@$SNOW_HOST 'bash' < $CURDIR/script.sh
# Connect to 'flag09' to get the flag
ssh -q -p $SNOW_PORT $FLAG@$SNOW_HOST getflag
echo -e "\nExpected flag: $FLAG_CONTENT"