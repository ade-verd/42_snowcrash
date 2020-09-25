# Level09 - Flag09

## Local script usage

```shell
Usage: ./main.sh
```

## Passwords and token

|         |                             |
| ------- | --------------------------- |
| level09 | `25749xKZ8L7DkSCwJkT9dyv6f` |
| flag09  | `` |
| token   | `s5cAJpM8ev6XHw998pRWG728z` |

## Steps to resolve on VM

1. Connect to `level09` user and notice there is an executable and a token file owned by `flag09` user

```bash
su level09
# Enter the token

ls -l
> -rwsr-sr-x 1 flag09 level09 7640 Mar  5  2016 level09
> ----r--r-- 1 flag09 level09   26 Mar  5  2016 token
```

2. Check the files

```bash
./level09
> You need to provied only one arg.

./level09 token
> tpmhr

cat token
> f4kmm6p|=�p�n��DB�Du{��

echo "test" > /tmp/test
./level09 /tmp/test
> /uos3ykz|

./level09 "test"
> tfuw

./level09 "token"
> tpmhr
```

It seems like the program does take a string as an argument and not a file, and encodes it (always the same length between the argument and the output)

we can assume it was encoded also with this :
```bash
strings level09
> [...]
> You should not reverse this
> [...]
```
And reverse/decode the token file

3. Understand the encoding

```bash
./level09 "aaaaaa"
> abcdef
```
It seems like this program encodes the string by adding the index position of the current character to the character itself (a = a + 0, b = b + 1, c = c + 2, ...)

Let's do a script for that :

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