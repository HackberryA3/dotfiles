---
tags:
  - SSH
---

~~ at Host ~~
ssh-keygen -t rsa -b 4096 -f vps-ssh
ssh user@host

~~ Connected VPS ~~
~ If no user ~
adduser user
usermod -aG sudo user
su - user

~ Copy public key ~
mkdir ~/.ssh
echo 'vps-ssh.pub' > ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

~~ Back to Host ~~
ssh user@host -i vps-ssh

~~ Connedted VPS via key ~~
sudo apt install fail2ban -y
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.conf.bak

~ Setting jail ~
sudo vim /etc/fail2ban/jail.conf

# [sshd]
enabled = true
bantime = 4w
maxretry = 3

~ Setting OpenSSH Config ~
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sudo vim /etc/ssh/sshd_config

LogLevel VERBOSE
PermitRootLogin no
MaxAuthTries 3
MaxSessions 5
HostbasedAuthentication no
PasswordAuthentication no
PermitEmptyPassword no
ChallengeResponseAuthentication yes
UsePAM yes
X11Forwarding no
PrintMotd no
ClientAliveInterval 600
ClientAliveCountMax 0
AllowUsers <username1> <username2> ...
Protocol 2
AuthenticationMethods publickey,keyboard-interactive

~ Setting 2FA ~
sudo apt install libpam-google-authenticator -y
google-authenticator

~ Setting PAM for sshd ~
sudo cp /etc/pam.d/sshd /etc/pam.d/sshd.bak
sudo vim /etc/pam.d/sshd

1. Comment out "@include common-auth"
2. Add "auth required pam_google_authenticator.so"
	   "auth required pam_permit.so" at the end of the file
	   
~ Restart SSH ~
sudo service ssh restart
