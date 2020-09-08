#!/bin/bash

export SNOW_USER="level00"
export SNOW_PORT="4242"

CURDIR=`dirname $0`
SCRIPTS="$CURDIR/../../scripts"
SCP="$SCRIPTS/scpTransfer.sh"

function sendScript {
    SOURCE="$CURDIR/solver.sh"
    DEST="/tmp"

    $SCP $SOURCE $DEST
}

sendScript

echo "Then in VM run:"
echo "bash $DEST/$(basename $SOURCE)"

