###### CURRENTLY SUPPORT
<img src="https://img.shields.io/badge/-Debian-A81D33.svg?logo=debian&style=flat"> <img src="https://img.shields.io/badge/-Ubuntu-6F52B5.svg?logo=ubuntu&style=flat"> <img src="https://img.shields.io/badge/-Kali-0087f2.svg?logo=kalilinux&logoColor=ffffff&style=flat">

###### TEST
[![Debian](https://github.com/HackberryA3/dotfiles/actions/workflows/debian.yaml/badge.svg)](https://github.com/HackberryA3/dotfiles/actions/workflows/debian.yaml)
[![Ubuntu](https://github.com/HackberryA3/dotfiles/actions/workflows/ubuntu.yaml/badge.svg)](https://github.com/HackberryA3/dotfiles/actions/workflows/ubuntu.yaml)
[![Kali](https://github.com/HackberryA3/dotfiles/workflows/Kali/badge.svg)](https://github.com/HackberryA3/dotfiles/actions/workflows/kali.yaml)

###### LINT
[![Checkshell](https://github.com/HackberryA3/dotfiles/actions/workflows/checkshell.yaml/badge.svg)](https://github.com/HackberryA3/dotfiles/actions/workflows/checkshell.yaml)

---

# dotfiles

This is my personal dotfiles for any platforms

## Installation

```sh
cd ~
git clone https://github.com/HackberryA3/dotfiles

./dotfiles/install.sh OS [OPTIONS]
```

### OS

- linux
- debian
- ubuntu
- kali: Includes cracking tools

### OPTIONS

- --choice(default): choose what to install interactively
- --all: Install dotfiles, CUI, GUI
- --dotfiles: Install dotfiles
- --cui: Install cui
- --gui: Install gui
