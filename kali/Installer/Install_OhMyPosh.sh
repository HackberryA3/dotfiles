#!/bin/bash
#Install Oh My Posh
cd ~
curl -s https://ohmyposh.dev/install.sh | sudo bash -s

echo -n "Do you want to install Nerdfonts? (y/n) : "
read answer
if [ $answer = "y" ]; then
	oh-my-posh font install --user
fi

echo -n "Do you want to set up Oh My Posh for bash? (y/n) : "
read answer
if [ $answer = "y" ]; then
	cp .bashrc .bashrc.bak
	echo "" >> .bashrc
	echo "#Init Oh-My-Posh" >> .bashrc
	echo 'eval "$(oh-my-posh init bash --config https://gist.githubusercontent.com/HackberryA3/23c7b1c51d868de235eb8d39ea556ba9/raw/ReactiveMonokai.omp.yaml)"' >> .bashrc
fi

echo -n "Do you want to set up Oh My Posh for zsh? (y/n) : "
read answer
if [ $answer = "y" ]; then
	cp .zshrc .zshrc.bak
	echo "" >> .zshrc
	echo "#Init Oh-My-Posh" >> .zshrc
	echo 'eval "$(oh-my-posh init zsh --config https://gist.githubusercontent.com/HackberryA3/23c7b1c51d868de235eb8d39ea556ba9/raw/ReactiveMonokai.omp.yaml)"' >> .zshrc
fi

echo -n "Do you want to set up Oh My Posh for fish? (y/n) : "
read answer
if [ $answer = "y" ]; then
	cp .config/fish/config.fish .config/fish/config.fish.bak
	echo "" >> .config/fish/config.fish
	echo "#Init Oh-My-Posh" >> .config/fish/config.fish
	echo 'eval (oh-my-posh init fish --config https://gist.githubusercontent.com/HackberryA3/23c7b1c51d868de235eb8d39ea556ba9/raw/ReactiveMonokai.omp.yaml)' >> .config/fish/config.fish
fi

echo "Oh My Posh installed successfully!"