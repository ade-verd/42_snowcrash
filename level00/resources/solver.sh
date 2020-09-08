#!/bin/bash

FLAG="flag00";
function tryGetFlag {
    set -x;
    su $FLAG -c "getflag"
}

function caesarSolver {
    if [ ! "$#" -eq 1 ]; then
        echo Usage "./$(basename $0) <string>"
        exit 1
    fi

    for i in $(seq 15); do
        echo $i $1 | tr $(printf %${i}s | tr ' ' '.')\a-z a-za-z
    done
}

set -x;
OUTPUT=`find / -user flag00 2>/dev/null | head -1`
OUTPUT=`cat $OUTPUT`

set +x;
echo "Then use caesar cipher solver"
caesarSolver $OUTPUT

tryGetFlag