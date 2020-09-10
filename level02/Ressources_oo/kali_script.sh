#!/bin/bash

LEVEL="02"
PW="f2av5il02puano7naaf6adaaf"

export SNOW_USER="level$LEVEL"
export SNOW_PORT="4242"

if [ -z ${SNOW_HOST+x} ]; then read -p "VM Host: " SNOW_HOST; fi

PCAP="level02.pcap"
PCAP_PATH="./$PCAP"

# Update & install SCP and john packages
apt-get update && apt-get install -y openssh-client && apt-get install -y tcpick

# Copy the passwords file
echo -e "\n\n$SNOW_USER password is : $PW\n"
scp -q -o "StrictHostKeyChecking no" -P $SNOW_PORT $SNOW_USER@$SNOW_HOST:$PCAP_PATH ./

# Decrypt the password with john the ripper
tcpick -C -yU -r $PCAP
echo -e "\n\nPassword found with PCAP file : ft_wandr<7f><7f><7f>NDRel<7f>L0L"
echo -e "\n7F in ASCII means 'DEL' character, so we need to reproduce this delete key event => flag02 password is : ft_waNDReL0L\n\n"