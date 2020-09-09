#! /bin/bash

if [ -z ${SNOW_HOST+x} ]; then read -p "VM Host: " SNOW_HOST; fi
if [ -z ${SNOW_PORT+x} ]; then read -p "VM Port (ex: 4242): " SNOW_PORT; fi
if [ -z ${SNOW_USER+x} ]; then read -p "VM User (ex: level00): " SNOW_USER; fi

set -x

ssh $SNOW_USER@$SNOW_HOST -p $SNOW_PORT