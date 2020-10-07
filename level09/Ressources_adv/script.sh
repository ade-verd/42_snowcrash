#!/bin/bash

function hexToDec {
    echo $((16#$1))
}

function level09Decoder {
    (set -x
    xxd -c 1 -l 25 $1 | tee /tmp/out)
    XXD_OUTPUT=`cat /tmp/out`

    PASSWORD=''

    echo -e "#\tCODE\tCHAR\t\tCODE\tCHAR"
    echo "=============================================="
    while IFS= read -r line; do
        INDEX_16=`echo $line | cut -d: -f1`
        INDEX_10=`hexToDec $INDEX_16`
        echo -en "$INDEX_10\t"

        CHARCODE_16=`echo $line | cut -d ' ' -f2`
        CHARCODE_10=`hexToDec $CHARCODE_16`
        echo -en "$CHARCODE_10\t"

        CHAR=`echo $line | cut -d ' ' -f3`
        echo -en "$CHAR\t"

        DECODED_CHARCODE_10=$(($CHARCODE_10 - $INDEX_10))
        echo -en ">\t$DECODED_CHARCODE_10\t"

        DECODED_CHAR=`printf "\x$(printf %x $DECODED_CHARCODE_10)"`
        echo "$DECODED_CHAR"

        PASSWORD+=$DECODED_CHAR
    done <<< "$XXD_OUTPUT"

    echo -e "\nflag09 Password is: $PASSWORD"
}

level09Decoder ~/token
