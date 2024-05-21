###### TEST
[![debian](https://github.com/HackberryA3/dotfiles/actions/workflows/debian.yaml/badge.svg)](https://github.com/HackberryA3/dotfiles/actions/workflows/debian.yaml)

###### LINT
[![lint](https://github.com/HackberryA3/dotfiles/actions/workflows/lint.yaml/badge.svg)](https://github.com/HackberryA3/dotfiles/actions/workflows/lint.yaml)

###### CURRENTLY SUPPORT
<img src="https://img.shields.io/badge/-Debian-A81D33.svg?logo=debian&style=flat"> <img src="https://img.shields.io/badge/-Ubuntu-6F52B5.svg?logo=ubuntu&style=flat"> <img src="https://img.shields.io/badge/-Kali-0087f2.svg?logo=kalilinux&logoColor=ffffff&style=flat">

# dotfiles

This is my personal dotfiles for any platforms

## Installation

```sh
cd ~
git clone https://github.com/HackberryA3/dotfiles
```

<details>
	<summary>Debian</summary>

```sh
sudo ./dotfiles/unix/linux/debian/scripts/install.sh # install all
sudo ./dotfiles/unix/linux/debian/scripts/install_cui.sh # install only CUI tools
sudo ./dotfiles/unix/linux/debian/scripts/install_gui.sh # install only GUI tools
sudo ./dotfiles/unix/linux/debian/scripts/dotfiles.sh # install only dotfiles
```

> Don't need `sudo` if you are already as root
</details>

<details>
	<summary>Kali</summary>

install_cui.sh for kali additionaly installs cracking tools. If you don't want them, You can run debian/scripts/install.sh instead.
```sh
sudo ./dotfiles/unix/linux/debian/kali/scripts/install.sh # install all
sudo ./dotfiles/unix/linux/debian/kali/scripts/install_cui.sh # install only CUI tools
sudo ./dotfiles/unix/linux/debian/kali/scripts/install_gui.sh # install only GUI tools
sudo ./dotfiles/unix/linux/debian/kali/scripts/dotfiles.sh # install only dotfiles
```

> Don't need `sudo` if you are already as root
</details>

<details>
	<summary>Arch</summary>
Coming soon...
</details>

<details>
	<summary>Manjaro</summary>
Coming soon...
</details>

<details>
	<summary>Mac</summary>
Coming soon...
</details>

<details>
	<summary>Windows</summary>
Coming soon...
</details>
