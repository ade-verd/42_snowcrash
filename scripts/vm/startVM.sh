#! /bin/bash

NAME="snowcrash"
VM_PORT="4242"

# set -x
VM_NAME=`VBoxManage list vms | grep -i $NAME | head -1 | grep -oP '\"\K[^" ]+'`
if [ -z "$VM_NAME" ]; then
    echo "The VM $NAME does not exist. Please install it first"
    exit 1;
fi

IS_VM_RUNNING=`vboxmanage showvminfo "$VM_NAME" | grep -c "running (since"`
if [ "$IS_VM_RUNNING" -eq "0" ]; then
    VBoxManage startvm $VM_NAME --type headless
else
    echo "VM $VM_NAME is already running"
fi

echo "Waiting for the IP..."
n=0
until [ "$n" -ge 60 ]
do
    VM_IP=`VBoxManage guestproperty enumerate $VM_NAME | grep -i ip | grep -ioP 'value: \K[^,]+'`
    if [ -n "$VM_IP" ]; then break; fi
    n=$((n+1)) 
    sleep 1
done
if [ -z "$VM_IP" ]; then
    echo "Failed to get the IP. Please try again"
    exit 1;
fi

echo -e "You should set its IP as environment variable\n"
echo "export SNOW_HOST=$VM_IP"
echo "export SNOW_PORT=$VM_PORT"