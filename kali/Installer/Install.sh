#!/bin/bash

cd `dirname $0`
source ../Setup/Setup_apt.sh

echo -n "Do you want to setup git? (y/n) : "
read answer
if [ $answer = "y" ]; then
	source ../Setup/Setup_Git.sh
fi

echo -n "Do you want to install the tools for hacking? (y/n) : "
read answer
if [ $answer = "y" ]; then
	source Install_Tools.sh
fi

echo -n "Do you want to install Google Chrome? (y/n) : "
read answer
if [ $answer = "y" ]; then
	source Install_Chrome.sh
fi

echo -n "Do you want to install fcitx-mozc to input Japanese? (y/n) : "
read answer
if [ $answer = "y" ]; then
	source Install_JapaneseInput.sh
fi

echo -n "Do you want to install Visual Studio Code? (y/n) : "
read answer
if [ $answer = "y" ]; then
	source Install_VSCode.sh
fi

echo -n "Do you want to install Bitwarden? (y/n) : "
read answer
if [ $answer = "y" ]; then
	source Install_Bitwarden.sh
fi

echo -n "Do you want to install GitHub CLI? (y/n) : "
read answer
if [ $answer = "y" ]; then
	source Install_GitHubCLI.sh
fi

echo -n "Do you want to install Oh My Posh? (y/n) : "
read answer
if [ $answer = "y" ]; then
	source Install_OhMyPosh.sh
fi

echo -n "Do you want to setup bash prompt to take logs with timestamp? (y/n) : "
read answer
if [ $answer = "y" ]; then
	source ../Setup/Setup_BashPrompt.sh
fi



echo "Done for all setup!"
