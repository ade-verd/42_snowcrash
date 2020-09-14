#!/bin/bash

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
echo -e "\nThen use caesar cipher solver"
caesarSolver $OUTPUT

PASSWORD=`caesarSolver $OUTPUT | grep 'hard' | cut -d ' ' -f2`
echo -e "\nFlag00 Password is: $PASSWORD\n"