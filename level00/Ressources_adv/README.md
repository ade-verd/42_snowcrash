# Level00 - Flag00

## Local script usage

```shell
Usage: ./main.sh
```

## Passwords and token

|         |                             |
| ------- | --------------------------- |
| level00 | `level00`                   |
| flag00  | `nottoohardhere`            |
| token   | `x24ti5gi3x0ol2eh4esiuxias` |

## Steps to resolve on VM

1. Find files owned by the user `flag00` or the group `flag00`

```bash
find / -user flag00 2>/dev/null
# or
find / -group flag00 2>/dev/null

> /usr/sbin/john
> /rofs/usr/sbin/john
```

2. Display content

```bash
cat /usr/sbin/john

> cdiiddwpgswtgt
```

3. Use Caesar Cipher decoder to decode this password.
   A shift of 11 seems to be used.

```bash
> nottoohardhere
```

## Notes

In cryptography, a Caesar cipher, also known as Caesar's cipher, the shift cipher, Caesar's code or Caesar shift, is one of the simplest and most widely known encryption techniques. It is a type of substitution cipher in which each letter in the plaintext is replaced by a letter some fixed number of positions down the alphabet. [...]

---

## Sources

### Shell

- [Man find](https://www.man7.org/linux/man-pages/man1/find.1.html)
- [Linux/Unix: Find all the files owned by a aarticular user/group](https://www.cyberciti.biz/faq/how-do-i-find-all-the-files-owned-by-a-particular-user-or-group/)

### Cryptography

- [Wikipedia Caeser cipher](https://en.wikipedia.org/wiki/Caesar_cipher)
- [Caesar Cipher Decoder (Test all possible shifts)](https://www.dcode.fr/caesar-cipher)
- [Decrypting the Caesar cipher using shell](https://chris-lamb.co.uk/posts/decrypting-caesar-cipher-using-shell)
