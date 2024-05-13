git config --global init.defaultBranch main

echo -n "Your email address for git : "
read email
git config --global user.email $email

echo -n "Your name for git : "
read name
git config --global user.name $name
