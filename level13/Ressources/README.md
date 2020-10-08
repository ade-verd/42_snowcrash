# Level14 - Flag14

## Local script usage

```shell
Usage: ./main.sh
```

## Passwords and token

|         |                             |
| ------- | --------------------------- |
| level14 | `2A31L79asukciNyi8uppkEuSx` |
| flag14  | `` |
| token   | `2A31L79asukciNyi8uppkEuSx` |

## Steps to resolve on VM

1. Connect to `level13` user and notice there is an executable owned by `flag13` user

```bash
su level13
# Enter the token

ls -l
> -rwsr-sr-x 1 flag13 level13 7303 Aug 30  2015 level13
```

2. Check the files

```bash
./level13
> UID 2013 started us but we we expect 4242

./level13 .profile
> UID 2013 started us but we we expect 4242

nm -u level13
> w _Jv_RegisterClasses
> w __gmon_start__
> U __libc_start_main@@GLIBC_2.0
> U exit@@GLIBC_2.0
> U getuid@@GLIBC_2.0
> U printf@@GLIBC_2.0
> U strdup@@GLIBC_2.0
```

It seems like level13 is a C executable, and uses the 'getuid' function to get the UID, and expects it to be 4242 (and not 2013 in our case)

So let's use the debugger GDB to trick him

3. Exploit it with GDB

```bash
gdb level13

disassemble main
> [...]
> 0x08048595 <+9>:     call   0x8048380 <getuid@plt>
> 0x0804859a <+14>:    cmp    $0x1092,%eax
> [...]
```
We can see that getuid is called, and a variable 'eax' is compared to 0x1092, which is 4242 in hexadecimal

Let's put breakpoint to getuid, check the 'eax' value, and try to change it to 4242

```bash
# Still inside gdb
break getuid

run

step # To go to getuid breakpoint

print $eax
> $1 = 2013 # It is indeed showing us our current UID, let's change it

set $eax=4242

continue
> Continuing.
> your token is 2A31L79asukciNyi8uppkEuSx
> [Inferior 1 (process 2343) exited with code 050]
```

---

## Sources

### SHELL

- [How breakpoints works and how ptrace is important](https://majantali.net/2016/10/how-breakpoints-are-set/)
- [GDB ptrace bypass with stub file](https://dev.to/denisnutiu/bypassing-ptrace-calls-with-ldpreload-on-linux-12jl)
- [GDB ptrace bypass with easy gdb command](https://gist.github.com/poxyran/71a993d292eee10e95b4ff87066ea8f2)