#!/bin/bash

LEVEL="03"
PW="kooda2puivaav1idi4f57q8iq"

export SNOW_USER="level$LEVEL"
export SNOW_PORT="4242"

if [ -z ${SNOW_HOST+x} ]; then read -p "VM Host: " SNOW_HOST; fi

CURDIR=`dirname $0`
FLAG_CONTENT=`cat $CURDIR/../flag`

# Connect to 'level03'
echo -e "\n\n$SNOW_USER password is : $PW\n"
ssh -p $SNOW_PORT $SNOW_USER@$SNOW_HOST 'bash' < $CURDIR/script.sh
echo -e "\nExpected flag: $FLAG_CONTENT"