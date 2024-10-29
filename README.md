###### CURRENTLY SUPPORT
<span>
  <img src="https://img.shields.io/badge/-Windows-0883d0.svg?style=flat">
  <img src="https://img.shields.io/badge/-Mac-9f9f9f.svg?logo=apple&style=flat">
  <img src="https://img.shields.io/badge/-Debian-A81D33.svg?logo=debian&style=flat">
  <img src="https://img.shields.io/badge/-Ubuntu-6F52B5.svg?logo=ubuntu&style=flat">
  <img src="https://img.shields.io/badge/-Kali-0087f2.svg?logo=kalilinux&logoColor=ffffff&style=flat">
  <a href="https://www.AlmaLinux.org/"><img src="https://img.shields.io/badge/-AlmaLinux-0a3768.svg?logo=almalinux&logoColor=ffffff&style=flat"></a>
</span>

###### TEST
[![Windows](https://github.com/HackberryA3/dotfiles/actions/workflows/windows.yaml/badge.svg)](https://github.com/HackberryA3/dotfiles/actions/workflows/windows.yaml)
[![Debian](https://github.com/HackberryA3/dotfiles/actions/workflows/debian.yaml/badge.svg)](https://github.com/HackberryA3/dotfiles/actions/workflows/debian.yaml)
[![Ubuntu](https://github.com/HackberryA3/dotfiles/actions/workflows/ubuntu.yaml/badge.svg)](https://github.com/HackberryA3/dotfiles/actions/workflows/ubuntu.yaml)
[![Kali](https://github.com/HackberryA3/dotfiles/workflows/Kali/badge.svg)](https://github.com/HackberryA3/dotfiles/actions/workflows/kali.yaml)
[![AlmaLinux](https://github.com/HackberryA3/dotfiles/actions/workflows/almalinux.yaml/badge.svg)](https://github.com/HackberryA3/dotfiles/actions/workflows/almalinux.yaml)


###### LINT
[![Checkshell](https://github.com/HackberryA3/dotfiles/actions/workflows/checkshell.yaml/badge.svg)](https://github.com/HackberryA3/dotfiles/actions/workflows/checkshell.yaml)
[![PSScriptAnalyzer](https://github.com/HackberryA3/dotfiles/actions/workflows/psscript_analyzer.yaml/badge.svg)](https://github.com/HackberryA3/dotfiles/actions/workflows/psscript_analyzer.yaml)

---

# dotfiles

This is my personal dotfiles for any platforms

## Installation

```sh
cd ~
git clone https://github.com/HackberryA3/dotfiles

./dotfiles/install.sh OS [OPTIONS]
```

```ps1
cd ~
git clone https://github.com/HackberryA3/dotfiles

.\dotfiles\install.ps1 [OPTIONS]
```

### OS

- windows
- mac
- linux
- debian
- ubuntu
- kali: Includes cracking tools
- almalinux

### OPTIONS

- --choice(default): choose what to install interactively
- --all: Install dotfiles, CUI, GUI
- --dotfiles: Install dotfiles
- --cui: Install cui
- --gui: Install gui
