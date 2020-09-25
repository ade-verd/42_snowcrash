#!/bin/bash

function level09Decoder {
    for (( i=0; i<${#1}; i++ )); do # '#' to get the length of $1
        # 1. Turn into ASCII integer
        # printf -v nb %d "'${1:i:1}" # ${string:position:length} to extract from string $1
        nb=`perl -C255 -e 'print ord($ARGV[0])' ${1:i:1}`
        printf "${1:i:1} | "

        printf "1) $nb | "
        # 2. Substract the position of current char to decode
        printf "\-$i | "
        (( nb -= $i ))
        (( nb %= 255 ))
        printf "1) $nb | "
        awk -v char=$nb 'BEGIN { printf "%c", char; exit }'
        # printf \\$(printf '%03o' "$nb")
        printf "\n"
        
        # 3. Revert back to char
        # printf \\$(printf '%03o' "$nb")
        # if ($i - 1 = ${#1}); then
        #     printf "\n"
        # fi
    done
}

# cat ~/token
# level09Decoder $(cat ~/token)

level09Decoder $1

# f4kmm6p|=�p�n��DB�Du{��