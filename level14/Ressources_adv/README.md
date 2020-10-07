# Level14 - Flag14

## Local script usage

```shell
Usage: ./main.sh
```

## Passwords and token

|         |                                           |
| ------- | ----------------------------------------- |
| level14 | `2A31L79asukciNyi8uppkEuSx`               |
| flag14  | `7QiHafiNa3HVozsaXkawuYrTstxbpABHD8CPnHJ` |
| token   | `7QiHafiNa3HVozsaXkawuYrTstxbpABHD8CPnHJ` |

## Steps to resolve on VM

1. Connect to `level14` user and notice there is no file in home for this level

```bash
ssh level14@$SNOW_HOST -p 4242
# Enter the password

ls -l
>
```

So we have to find ourself the security hole without any hint.

We tried to find another file with extended permission, but nothing.

So we decided to investigate the getflag binary.

Using `strings` is not clear enough to debug. We used `gdb` instead.

```bash
# First locate getflag binary
which getflag
> /bin/getflag

# Then debug with gdb
gdb /bin/getflag
(gdb) run

> Starting program: /bin/getflag
  You should not reverse this
  [Inferior 1 (process 2233) exited with code 01]
```

It seems there is a protection against debugging

```bash
# main disassembler
(gdb) disas main

> (...)
  0x08048989 <+67>:	call   0x8048540 <ptrace@plt>
  (...)
```

The first call is `ptrace`. This syscall is used for process trace and is mainly used to debug.

Considering this (website)[https://seblau.github.io/posts/linux-anti-debugging]:

> The point here is that debuggers like gdb, edb or strace(1) for example utilize the ptrace(2) function to attach to a process at runtime. But there is only one process allowed to do this at a time and therefore having a call to ptrace(2) in your code can be used to detect debuggers.

We have to bypass `ptrace`. Lets try the provided solution without modify sources while using LD_PRELOAD (cf. level13).

```shell
vim /tmp/cptrace.c
```

```c
long ptrace(int request, int pid, int addr, int data)
{
    return 0;
}
```

```shell
cd /tmp
gcc -shared -fPIC -o cptrace.so cptrace.c
export LD_PRELOAD=/tmp/cptrace.so
gdb /bin/getflag
(gdb) run

> Starting program: /bin/getflag
  Injection Linked lib detected exit..
  During startup program exited with code 1.
```

Arghhh, there is a protection against LD_PRELOAD injection too. Need another solution.

Considering this (gist)[https://gist.github.com/poxyran/71a993d292eee10e95b4ff87066ea8f2], we should modify the register used by `ptrace` to bypass it. Lets try.

(As it does not work, do not forget to `unset LD_PRELOAD`)

```shell
gdb /bin/getflag
(gdb) catch syscall ptrace
      commands 1
      set ($eax) = 0
      continue
      end
(gdb) run

> Starting program: /bin/getflag

  Catchpoint 1 (call to syscall ptrace), 0xb7fdd428 in __kernel_vsyscall ()

  Catchpoint 1 (returned from syscall ptrace), 0xb7fdd428 in __kernel_vsyscall ()
  Check flag.Here is your token :
  Nope there is no token here for you sorry. Try again :)
  [Inferior 1 (process 2286) exited normally]
```

Good point here, because we successfully bypassed ptrace and the program has been executed normally.

Lets check the disassembled main

```asm
   (...)
   0x08048afd <+439>:	call   0x80484b0 <getuid@plt>       ##### call getuid
   0x08048b02 <+444>:	mov    %eax,0x18(%esp)
   0x08048b06 <+448>:	mov    0x18(%esp),%eax
   0x08048b0a <+452>:	cmp    $0xbbe,%eax                  ##### compare the register eax with the value 0xbbe (base10: 3006)
   0x08048b0f <+457>:	je     0x8048ccb <main+901>
   0x08048b15 <+463>:	cmp    $0xbbe,%eax
   0x08048b1a <+468>:	ja     0x8048b68 <main+546>
   0x08048b1c <+470>:	cmp    $0xbba,%eax                  ##### 0xbba = 3002.... looks like UID values (cf. /etc/password)
   0x08048b21 <+475>:	je     0x8048c3b <main+757>
   0x08048b27 <+481>:	cmp    $0xbba,%eax
   (...)
   0x08048bab <+613>:	cmp    $0xbc5,%eax
   0x08048bb0 <+618>:	je     0x8048dc4 <main+1150>
   0x08048bb6 <+624>:	cmp    $0xbc6,%eax                    ##### 0xbc6 (base10: 3014) is the UID value of flag14 (cf. /etc/passwd)
   0x08048bbb <+629>:	je     0x8048de5 <main+1183>
   0x08048bc1 <+635>:	jmp    0x8048e06 <main+1216>
   (...)
```

While checking the main disassembled, we can see a syscall to getuid, and then a serie of comparisons with differents hexadecimal values. First 0xbbe (3006), then 0xbba (3002), ...etc. It looks like UID values. We can check /etc/passwd to confirm this hypothesis.

```bash
cat /etc/passwd | grep flag

> flag00:x:3000:3000::/home/flag/flag00:/bin/bash
  flag01:42hDRfypTqqnw:3001:3001::/home/flag/flag01:/bin/bash
  flag02:x:3002:3002::/home/flag/flag02:/bin/bash
  flag03:x:3003:3003::/home/flag/flag03:/bin/bash
  flag04:x:3004:3004::/home/flag/flag04:/bin/bash
  flag05:x:3005:3005::/home/flag/flag05:/bin/bash
  flag06:x:3006:3006::/home/flag/flag06:/bin/bash
  flag07:x:3007:3007::/home/flag/flag07:/bin/bash
  flag08:x:3008:3008::/home/flag/flag08:/bin/bash
  flag09:x:3009:3009::/home/flag/flag09:/bin/bash
  flag10:x:3010:3010::/home/flag/flag10:/bin/bash
  flag11:x:3011:3011::/home/flag/flag11:/bin/bash
  flag12:x:3012:3012::/home/flag/flag12:/bin/bash
  flag13:x:3013:3013::/home/flag/flag13:/bin/bash
  flag14:x:3014:3014::/home/flag/flag14:/bin/bash
```

So we need to search what the hexadecimal value of 3014 which is 0xbc6.

The register used is still `eax`. We have to replace the register value after `getuid` syscall and before comparisons. We can do that with a breakpoint.

```shell
gdb /bin/getflag
(gdb) catch syscall ptrace
      commands 1
      set ($eax) = 0
      continue
      end

(gdb) break getuid
(gdb) run
(gdb) next
(gdb) set ($eax) = 0xbc6
(gdb) continue

> Continuing.
  Check flag.Here is your token : 7QiHafiNa3HVozsaXkawuYrTstxbpABHD8CPnHJ
```

---

## Sources

- [gdb Cheat Sheet](https://darkdust.net/files/GDB%20Cheat%20Sheet.pdf)
- [Linux anti debugging - ptrace](https://seblau.github.io/posts/linux-anti-debugging) how works ptrace
- [Easy bypass for ptrace](https://gist.github.com/poxyran/71a993d292eee10e95b4ff87066ea8f2)
