#!/bin/bash

LEVEL="01"

if [ -z ${SNOW_HOST+x} ]; then read -p "VM Host: " SNOW_HOST; fi
if [ -z ${SNOW_PORT+x} ]; then read -p "VM Port: " SNOW_PORT; fi

CURDIR=`dirname $0`
CURDIR_ABS=`dirname "$(readlink -f "$0")"`
SCRIPT="kali_script.sh"

# Create the docker environment and run John the Ripper hacking tool to find flag01 password
docker run -e SNOW_HOST=$SNOW_HOST -it -v $CURDIR_ABS/$SCRIPT:/$SCRIPT --rm kalilinux/kali-rolling bash script.sh

# Then check flag on flag user
FLAG_LEVEL="flag$LEVEL"
FLAG_CONTENT=`cat $CURDIR/../flag`

ssh -t -q $FLAG_LEVEL@$SNOW_HOST -p $SNOW_PORT "getflag"
echo -e "\nExpected flag: $FLAG_CONTENT"