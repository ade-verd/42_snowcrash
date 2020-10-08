# Level09 - Flag09

## Local script usage

```shell
Usage: ./main.sh
```

## Passwords and token

|         |                             |
| ------- | --------------------------- |
| level09 | `25749xKZ8L7DkSCwJkT9dyv6f` |
| flag09  | `f3iji1ju5yuevaus41q1afiuq` |
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

It seems like this program encodes the string by adding the index position of the current character to the character itself (dest[0] = src[0] + 0, dest[1] = src[1] + 1, dest[2] = src[2] + 2, ...)

4. Extract encoded token as hexadecimal
   As some characters are not visible, we use a tool like `hexdump` or `xxd` to extract exact characters code value.

```shell
xxd -c 1 token
# without ending newline:    xxd -c 1 -l 25 token

> 0000000: 66  f
  0000001: 34  4
  0000002: 6b  k
  0000003: 6d  m
  0000004: 6d  m
  0000005: 36  6
  0000006: 70  p
  0000007: 7c  |
  0000008: 3d  =
  0000009: 82  .
  000000a: 7f  .
  000000b: 70  p
  000000c: 82  .
  000000d: 6e  n
  000000e: 83  .
  000000f: 82  .
  0000010: 44  D
  0000011: 42  B
  0000012: 83  .
  0000013: 44  D
  0000014: 75  u
  0000015: 7b  {
  0000016: 7f  .
  0000017: 8c  .
  0000018: 89  .
  0000019: 0a  .
#    |      |  |___ Ascii char
#    |      |______ Hexadecimal value
#    |_____________ Index as hexadecimal
```

4. Decode encoded token

Lets write a script for that

```shell
vim /tmp/decode.sh
```

```bash
#!/bin/bash
function hexToDec {
    echo $((16#$1))
}

function level09Decoder {
    (set -x
    xxd -c 1 -l 25 $1 | tee /tmp/out)
    XXD_OUTPUT=`cat /tmp/out`

    PASSWORD=''

    echo -e "#\tCODE\tCHAR\t\tCODE\tCHAR"
    echo "=============================================="
    while IFS= read -r line; do
        INDEX_16=`echo $line | cut -d: -f1`
        INDEX_10=`hexToDec $INDEX_16`
        echo -en "$INDEX_10\t"

        CHARCODE_16=`echo $line | cut -d ' ' -f2`
        CHARCODE_10=`hexToDec $CHARCODE_16`
        echo -en "$CHARCODE_10\t"

        CHAR=`echo $line | cut -d ' ' -f3`
        echo -en "$CHAR\t"

        DECODED_CHARCODE_10=$(($CHARCODE_10 - $INDEX_10))
        echo -en ">\t$DECODED_CHARCODE_10\t"

        DECODED_CHAR=`printf "\x$(printf %x $DECODED_CHARCODE_10)"`
        echo "$DECODED_CHAR"

        PASSWORD+=$DECODED_CHAR
    done <<< "$XXD_OUTPUT"

    echo -e "\nflag09 Password is: $PASSWORD"
}

level09Decoder ~/token
```

Finally execute it to get the decoded token

```shell
bash /tmp/decode.sh

> #       CODE    CHAR            CODE    CHAR
  ==============================================
  0       102     f       >       102     f
  1       52      4       >       51      3
  2       107     k       >       105     i
  3       109     m       >       106     j
  4       109     m       >       105     i
  5       54      6       >       49      1
  6       112     p       >       106     j
  7       124     |       >       117     u
  8       61      =       >       53      5
  9       130     .       >       121     y
  10      127     .       >       117     u
  11      112     p       >       101     e
  12      130     .       >       118     v
  13      110     n       >       97      a
  14      131     .       >       117     u
  15      130     .       >       115     s
  16      68      D       >       52      4
  17      66      B       >       49      1
  18      131     .       >       113     q
  19      68      D       >       49      1
  20      117     u       >       97      a
  21      123     {       >       102     f
  22      127     .       >       105     i
  23      140     .       >       117     u
  24      137     .       >       113     q

flag09 Password is: f3iji1ju5yuevaus41q1afiuq
```

5. Get level flag

```bash
su flag09
# Enter password

> Don t forget to launch getflag !

getflag

> Check flag.Here is your token : s5cAJpM8ev6XHw998pRWG728z
```

---

## Sources

### SHELL

- [Man xxd](https://linux.die.net/man/1/xxd)
