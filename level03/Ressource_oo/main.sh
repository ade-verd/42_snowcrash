#!/bin/bash

LEVEL="02"
PW="f2av5il02puano7naaf6adaaf"

export SNOW_USER="level$LEVEL"
export SNOW_PORT="4242"

if [ -z ${SNOW_HOST+x} ]; then read -p "VM Host: " SNOW_HOST; fi

CURDIR=`dirname $0`
CURDIR_ABS=`dirname "$(readlink -f "$0")"`
SCRIPT="kali_script.sh"

# Create the docker environment and run TCPICK top 
docker run -e SNOW_HOST=$SNOW_HOST -it -v $CURDIR_ABS/$SCRIPT:/$SCRIPT --rm kalilinux/kali-rolling bash kali_script.sh

# Then check flag on flag user
FLAG_LEVEL="flag$LEVEL"
FLAG_CONTENT=`cat $CURDIR/../flag`

ssh -t -q $FLAG_LEVEL@$SNOW_HOST -p $SNOW_PORT "getflag"
echo -e "\nExpected flag: $FLAG_CONTENT"