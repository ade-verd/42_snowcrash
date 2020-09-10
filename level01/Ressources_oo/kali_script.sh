#!/bin/bash

LEVEL="01"
PW="x24ti5gi3x0ol2eh4esiuxias"

export SNOW_USER="level$LEVEL"
export SNOW_PORT="4242"

if [ -z ${SNOW_HOST+x} ]; then read -p "VM Host: " SNOW_HOST; fi

PASSWORD="passwd"
PASSWORD_PATH="/etc/$PASSWORD"

# Update & install SCP and john packages
apt-get update && apt-get install -y openssh-client && apt-get install -y john

# Copy the passwords file
echo -e "\n\nlevel01 password is : $PW\n"
scp -q -o "StrictHostKeyChecking no" -P $SNOW_PORT $SNOW_USER@$SNOW_HOST:$PASSWORD_PATH ./

# Decrypt the password with john the ripper
john $PASSWORD
echo -e "\n\nflag01 password is : $(john --show $PASSWORD | cut -d ':' -f 2)\n"