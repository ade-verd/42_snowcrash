#!/bin/bash

# Install requirements
(set -x
apt update &> /dev/null
apt install -y openssh-client tcpick &> /dev/null)

# Get .pcap file
REMOTE_FILE="./level02.pcap"
DEST_FILE="/level02.pcap"
(set +x
scp -q -o StrictHostKeyChecking=accept-new \
    -P $SNOW_PORT \
    $USER@$SNOW_HOST:$REMOTE_FILE $DEST_FILE)

# Read pcap file with tcpick using yU option to display data with unprintable characters
(set -x
tcpick -C -yU -r level02.pcap  | sed -n '/Password: /,/EOF/p')

echo -e "\nYou can see <7f> characters that correspond to the DEL character from the ASCII table"
echo "Let's extract the password while removing special chars and chars that precede <7f> char"

# Extract password only
PASSWORD=`tcpick -yU -r level02.pcap | sed '1,/Password: /d;/<00>/,$d' | tr -d [:cntrl:] | sed -e ':loop' -e 's/.<7f>//' -e 't loop'`
echo -e "\nFlag02 Password is: $PASSWORD\n"

# tcpink
# https://serverfault.com/questions/38626/how-can-i-read-pcap-files-in-a-friendly-format/38632

# sed
# exclude https://unix.stackexchange.com/questions/17404/print-lines-between-and-excluding-two-patterns
# loop    https://stackoverflow.com/questions/9983646/sed-substitute-recursively