# SnowCrash

## About

> An introductory project on computer security, Snow Crash aims to introduce security in different sub-domains, with a developer-oriented approach. We will familiarize ourselves with several languages ​​(ASM / perl / php ..), develop a certain logic to understand unknown programs, and thus become aware of the problems related to simple "errors" programming.

This is the first project of the Security branch at School 42 Paris

## Content

Each level folders contains these files:

- `flag`: Password for the next user
- `README`: How to find the password
- `main.sh`: Main script to execute. It connects us through ssh and executes `script.sh` on virtual machine

## Setup VM (Ubuntu/Debian)

Requirements:

- VirtualBox
- VirtualBox Guest Addition

```shell
./scripts/vm/createVM.sh
./scripts/vm/startVM.sh
```
