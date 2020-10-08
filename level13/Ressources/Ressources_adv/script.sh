#!/bin/bash

set -x

# Write a C getuid function to override the real getuid
cat << EOI > /tmp/inject.c
#include <sys/types.h>
#include <stdio.h>       
                             
uid_t   getuid(void) {
    printf("getuid overrided!\n");
    return (4242);       
}
EOI

# compile our injection into a shared library
cd /tmp
gcc -shared -fPIC -o inject.so inject.c

# use the LD_PRELOAD trick by setting the appropriate environment variable
# LD_PRELOAD to the path to our shared library, before executing our target program
LD_PRELOAD=/tmp/inject.so ~/level13

# It does not work, because there is a setuid bit on level13 
stat -c '%A %a %n' ~/level13
(set +x; echo -e "We have to remove the setuid bit\n")

# Copy the file to remove setuid bit
cp ~/level13 /tmp/level13
stat -c '%A %a %n' /tmp/level13
(set +x; echo -e "Setuid bit is removed. We can relaunch level13 with LD_PRELOAD trick\n")

# Then relaunch with level13 copy 
LD_PRELOAD=/tmp/inject.so /tmp/level13