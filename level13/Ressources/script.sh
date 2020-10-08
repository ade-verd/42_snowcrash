#!/bin/bash

exec gdb -q level13 << EOI 
# Set a breakpoint before getuid
    break getuid
# Run the program
    run
# Step to getuid breakpoint
    step
# Set 4242 in eax register, then continue normally the execution
    set \$eax=4242
    continue
    quit
EOI