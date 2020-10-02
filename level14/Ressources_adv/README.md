# Level14 - Flag14

## Local script usage

```shell
Usage: ./main.sh
```

## Passwords and token

|         |                                           |
| ------- | ----------------------------------------- |
| level14 | `2A31L79asukciNyi8uppkEuSx`               |
| flag14  | `7QiHafiNa3HVozsaXkawuYrTstxbpABHD8CPnHJ` |
| token   | `7QiHafiNa3HVozsaXkawuYrTstxbpABHD8CPnHJ` |

## Steps to resolve on VM

1. Connect to `level14` user and notice there is no file in home for this level

```bash
ssh level14@$SNOW_HOST -p 4242
# Enter the password

ls -l
>
```

```shell
gdb /bin/getflag
(gdb) catch syscall ptrace
      commands 1
      set ($eax) = 0
      continue
      end

(gdb) break getuid
(gdb) run
(gdb) next
(gdb) set $eax=0xbc6
(gdb) next
```

---

## Sources

### C

- [gdb Cheat Sheet](https://darkdust.net/files/GDB%20Cheat%20Sheet.pdf)
- [Linux anti debugging - ptrace](https://seblau.github.io/posts/linux-anti-debugging) how works ptrace
- [Easy bypass for ptrace](https://gist.github.com/poxyran/71a993d292eee10e95b4ff87066ea8f2)
