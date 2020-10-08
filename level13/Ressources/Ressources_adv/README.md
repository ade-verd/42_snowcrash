# Level13 - Flag13

## Local script usage

```shell
Usage: ./main.sh
```

## Passwords and token

|         |                             |
| ------- | --------------------------- |
| level13 | `g1qKMiRpXf53AWhDaU7FEkczr` |
| flag13  |                             |
| token   | `2A31L79asukciNyi8uppkEuSx` |

## Steps to resolve on VM

1. Connect to `level13` user and notice there is a binary with setuid bit

```bash
ssh level13@$SNOW_HOST -p 4242
# Enter the password

ls -l

> -rwsr-sr-x 1 flag13 level13 7303 Aug 30  2015 level13
```

2. Check the file

```shell
./level13

> UID 2013 started us but we we expect 4242
```

It appears, the program gets the user id and compares it with an expected UID.

Lets check out id:

```shell
id

> uid=2013(level13) gid=2013(level13) groups=2013(level13),100(users)
```

2013 is well our UID

Does some user have the UID 4242 ?

```shell
cat /etc/passwd | grep 4242
>
```

Nope...

Lets investigate level13

```shell
strings level13

>  (...)
  libc.so.6
  _IO_stdin_used
  exit
  strdup
  printf
  getuid
  \_\_libc_start_main
  GLIBC_2.0
  PTRh`
  UWVS
  [^_]
  0123456
  UID %d started us but we we expect %d
  boe]!ai0FB@.:|L6l@A?>qJ}I
  your token is %s
  (...)
```

It seems we could get the token while launching the program with 4242 UID.

But this UID does not exist and we can not create it.

We could stub the real getuid function and create an other one that returns 4242. This thing is possible if the function symbol `getuid` is part of a shared library. As we can see above, `getuid` is a part of `libc.so.6`, we could try this.

Check sources for LD_PRELOAD explanations.

3. Write our `getuid`

Lets get the original signature of `getuid`

```shell
man getuid
```

> SYNOPSIS <br />
> #include <unistd.h><br />
> #include <sys/types.h><br /><br />
> uid_t getuid(void);

Now we can re-write our own `getuid`:

```shell
vim /tmp/inject
```

```c
#include <sys/types.h>
#include <stdio.h>

uid_t   getuid(void) {
    printf("getuid overrided!\n");
    return (4242);
}
```

4. Compile our injection into a shared library

```shell
cd /tmp
gcc -shared -fPIC -o inject.so inject.c
```

5. Use LD_PRELOAD trick and execute our program

Ise the LD_PRELOAD trick by setting the appropriate environment variable LD_PRELOAD to the path to our shared library, before executing our target program

```shell
LD_PRELOAD=/tmp/inject.so ~/level13

> UID 2013 started us but we we expect 4242
```

... Failed ! It does not work

Why ? Remember level13 has a setuid bit. So LD_PRELOAD is not set in the good environment.

Lets remove it while copying the program

```bash
cp --no-preserve=mode ~/level13 /tmp/level13

# Lets check original program
stat -c '%A %a %n' ~/level13
> -rwsr-sr-x 6755 /tmp/level13

# level13 copy without setuid bit
stat -c '%A %a %n' /tmp/level13
> -rwxr-xr-x 755 /tmp/level13
```

6. Relaunch program and get token

```shell
LD_PRELOAD=/tmp/inject.so /tmp/level13

> getuid overrided!
> your token is 2A31L79asukciNyi8uppkEuSx
```

---

## Sources

### C

- [Stackoverflow - Override a function call in C](https://stackoverflow.com/a/618059/12107958)
- [The LD_PRELOAD trick](http://www.goldsborough.me/c/low-level/kernel/2016/08/29/16-48-53-the_-ld_preload-_trick/)
- [gcc -fPIC option](https://stackoverflow.com/questions/5311515/gcc-fpic-option)
