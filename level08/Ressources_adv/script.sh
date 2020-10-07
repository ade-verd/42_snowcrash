#!/bin/bash
set -x

# 1. Create symbolic link of token with an other name than "token"
ln -sf ~/token /tmp/link

# 2. Execute level08 with symlink as parameter
./level08 /tmp/link