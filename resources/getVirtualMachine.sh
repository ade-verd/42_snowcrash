#! /bin/bash

VM_LOCATION="https://projects.intra.42.fr/uploads/document/document/1573/SnowCrash.iso"
VM_NAME="SnowCrash.iso"

read -p "Download $VM_NAME ? [yY] " -n 1 -r
if [[ $REPLY =~ ^[yY]$ ]]
then
    echo
	(set -x; (curl -L $VM_LOCATION > $VM_NAME))
fi