# Level01 - Flag01

## Local script usage

```shell
Usage: ./Ressources/main.sh
```

## Passwords and token

|         |                                                             |
| ------- | ----------------------------------------------------------- |
| level01 | `x24ti5gi3x0ol2eh4esiuxias`<br />which is the previous flag |
| flag01  | `abcdefg`                                                   |
| token   | `f2av5il02puano7naaf6adaaf`                                 |

## Steps to resolve

1. Display the file /etc/passwd

```bash
cat /etc/passwd | grep flag0[01]

> flag00:x:3000:3000::/home/flag/flag00:/bin/bash
> flag01:42hDRfypTqqnw:3001:3001::/home/flag/flag01:/bin/bash
     |         |       _|     |  |______   |________    |______
     |         |      |       |         |           |          |
  Username:Password:UserID:GroupID:UserID_Info:HomeDirectory:Shell
```

In the password section, an x character indicates that encrypted password is stored in /etc/shadow file.

The flag01 password is a plaintext encrypted password not stored in the shadow file. We can now decrypt it.

2. Use scp to copy the passwd file from remote to local

```bash
scp -P 4242 level01@<HOST>:/etc/passwd /tmp/passwd
```

3. Use john-the-ripper to decrypt the encrypted password

```bash
# considering john is already setup
john /tmp/passwd

# or with docker
docker run -it -v /tmp/passwd:/crackme.txt adamoss/john-the-ripper /crackme.txt
```

---

## Notes

### /etc/passwd and /etc/shadow

`/etc/passwd` is the file where the **user information** (like username, user ID, group ID, location of home directory, login shell, ...) is stored when a new user is created.

`/etc/shadow` is the file where **important information** (like an encrypted form of the password of a user, the day the password expires, whether or not the passwd has to be changed, the minimum and maximum time between password changes, ...) is stored when a new user is created.

Some interesting extra info: [passwd](https://www.cyberciti.biz/faq/understanding-etcpasswd-file-format/) and [shadow](https://www.cyberciti.biz/faq/understanding-etcshadow-file/)

### John the ripper

John the Ripper is a free password cracking software tool. [...] It is among the most frequently used password testing and breaking programs as it combines a number of password crackers into one package, autodetects password hash types, and includes a customizable cracker. It can be run against various encrypted password formats including several crypt password hash types most commonly found on various Unix versions (based on DES, MD5, or Blowfish), Kerberos AFS, and Windows NT/2000/XP/2003 LM hash. Additional modules have extended its ability to include MD4-based password hashes and passwords stored in LDAP, MySQL, and others.

## Sources

### Shell

- [/etc/passwd explained](https://www.cyberciti.biz/faq/understanding-etcpasswd-file-format/)
- [/etc/shadow explained](https://www.cyberciti.biz/faq/understanding-etcshadow-file/)

### Cryptography

- [John the ripper - Wikipedia](https://en.wikipedia.org/wiki/John_the_Ripper)
- [John the ripper usage examples](https://www.openwall.com/john/doc/EXAMPLES.shtml)
