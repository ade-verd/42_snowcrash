# Level02 - Flag02

## Local script usage

```shell
Usage: ./main.sh
```

## Passwords and token

|         |                             |
| ------- | --------------------------- |
| level02 | `level02`                   |
| flag02  | `ft_waNDReL0L`              |
| token   | `kooda2puivaav1idi4f57q8iq` |

## Steps to resolve on VM

1. Connect to `level02` user and check the repo to find a PCAP file

```bash
su level02
# Enter the token
ls
> level02.pcap
```

2. Use TCPICK tool to open this PCAP file. (with a docker container)

```bash
# First launch the docker container which will use "kali-script.sh' to run TCPICK
docker run -e SNOW_HOST=$SNOW_HOST -it -v $PWD/$SCRIPT:/$SCRIPT --rm kalilinux/kali-rolling bash kali_script.sh

# After installing the dependencies, we copy 'level02.pcap' file
apt-get update && apt-get install -y openssh-client && apt-get install -y tcpick
scp -q -o "StrictHostKeyChecking no" -P $SNOW_PORT $SNOW_USER@$SNOW_HOST:$PCAP_PATH ./

# We open it with TCPICK with the flag -yU to be able to read Unprintable characters
tcpick -C -yU -r level02.pcap
# It displays the data captured
```

3. Format the found password

```bash
After checking the displayed data, we can see the password "ft_wandr<7f><7f><7f>NDRel<7f>L0L"

"7F" seems to be the "DEL" character in the ASCII table, after some reflexions,
we can understand that we need to reproduce this delete key event

Which finally gives us the real password : "ft_waNDReL0L"
```

4. Now we can connect to 'flag02' and use 'getflag' to get the token

```bash
ssh -t -q $FLAG_LEVEL@$SNOW_HOST -p $SNOW_PORT "getflag"
> Check flag.Here is your token : kooda2puivaav1idi4f57q8iq
```

---

## Sources

### PCAP

- [PCAP explanations](https://www.reviversoft.com/fr/file-extensions/pcap)
- [PCAP how to read it](https://serverfault.com/questions/38626/how-can-i-read-pcap-files-in-a-friendly-format/38632)
- [TCPICK man, to read Unprintable characters](https://linux.die.net/man/8/tcpick)

### ASCII

- [ASCII (DEL key)](http://www.robelle.com/smugbook/ascii.html#:~:text=The%20ASCII%20character%20set%20defines,and%200%20to%20177%20octal)
