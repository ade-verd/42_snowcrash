#!/bin/bash

set -e
LEVEL="02"

CURDIR=`dirname "$(readlink -f "$0")"`

PREV_LEVEL=`printf "%02d" $(($LEVEL-1))`
USER="level$LEVEL"
PASSWORD=`cat $CURDIR/../../level$PREV_LEVEL/flag`

IMAGE="kalilinux/kali-rolling"
CONTAINER="kali$LEVEL"

SCRIPT_NAME="kali_script.sh"

if [ -z ${SNOW_HOST+x} ]; then read -p "VM Host: " SNOW_HOST; fi
if [ -z ${SNOW_PORT+x} ]; then read -p "VM Port: " SNOW_PORT; fi

echo -e "$USER Password is: $PASSWORD\n"

# Run container and apply the script
(set -x
docker run -it --rm \
    --name $CONTAINER \
    -e SNOW_HOST=$SNOW_HOST \
    -e SNOW_PORT=$SNOW_PORT \
    -e USER=$USER \
    -v $CURDIR/$SCRIPT_NAME:/$SCRIPT_NAME \
    $IMAGE \
    bash $SCRIPT_NAME)

# Then check flag on flag user
FLAG_LEVEL="flag$LEVEL"
FLAG_CONTENT=`cat $CURDIR/../flag`

(set -x
ssh -q $FLAG_LEVEL@$SNOW_HOST -p $SNOW_PORT "getflag")
echo -e "\nExpected flag: $FLAG_CONTENT"