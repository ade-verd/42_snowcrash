#! /bin/bash

if [ ! "$#" -eq 2 ]; then
    echo Usage "./$(basename $0) <absolute local source> <absolute remote destination>"
    exit 1
fi

if [ -z ${SNOW_HOST+x} ]; then read -p "VM Host: " SNOW_HOST; fi
if [ -z ${SNOW_PORT+x} ]; then read -p "VM Port (ex: 4242): " SNOW_PORT; fi
if [ -z ${SNOW_USER+x} ]; then read -p "VM User (ex: level00): " SNOW_USER; fi

SOURCE=$(realpath $1)
DEST=$2


set -x

scp -q -P $SNOW_PORT $SOURCE $SNOW_USER@$SNOW_HOST:$DEST