#!/bin/bash

set -x

exec gdb -q /bin/getflag << EOI > /tmp/.gdbinit
catch syscall ptrace
commands 1
set $eax=0
continue
end

break getuid
run
next
set $eax=0xbc6
next
quit
EOI