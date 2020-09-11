# Level03 - Flag03

## Local script usage

```shell
Usage: ./main.sh
```

## Passwords and token

|         |                             |
| ------- | --------------------------- |
| level03 | `kooda2puivaav1idi4f57q8iq` |
| flag03  | `ft_waNDReL0L`              |
| token   | `kooda2puivaav1idi4f57q8iq` |

## Steps to resolve on VM

1. Connect to `level03` user and check the repo to find an executable with 's'(setuid) permission

```bash
su level03
# Enter the token

ls -l
> total 12
> -rwsr-sr-x 1 flag03 level03 8627 Mar  5  2016 level03

# The 's' means that by executing this 'level03',
# we will get the persmissions of the individual or group that owns the file
./level03
> Exploit me
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

### SHELL

- [What does s permission means ?](https://askubuntu.com/questions/431372/what-does-s-permission-means#:~:text=s%20(setuid)%20means%20set%20user%20ID%20upon%20execution.&text=In%20this%20s%20permission%20was,user%2DID%20mode%20is%20set.)
