#!/bin/bash
#
# Initial system setup for a remote development machine
#
# ssh -t root@<IP> "$(cat ~/.dotfiles/ubuntu/system.sh)"
#
set -e

printf "User account name: "
read -e USERNAME

# Fix locale
sudo update-locale LC_ALL=en_US.UTF-8
sudo sed -i -e "s/# LC_ALL.*/LC_ALL=\"en_US.UTF-8\"/" /etc/default/locale

sudo apt-get update && sudo apt-get install -y \
  acl \
  unattended-upgrades \
  policykit-1 \
  ntp \
  wget \
  curl \
  vim \
  ack-grep \
  git \
  unzip \
  htop \
  tmux \
  logrotate \
  build-essential \
  zsh \
  silversearcher-ag \
  jq \
  bat \
  htop \
  rsync \
  fail2ban

sudo service ntp start

# Automatic upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
sudo service unattended-upgrades restart

# Firewall: allow only ssh port
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable

# User account
adduser $USERNAME --shell $(which zsh)
usermod -aG sudo $USERNAME

# Copy SSH key
rsync --archive --chown=$USERNAME:$USERNAME ~/.ssh /home/$USERNAME

# Update ssh config: disable root login & password login
sudo sed -i -e "s/PermitRootLogin.*/PermitRootLogin no/" /etc/ssh/sshd_config
sudo sed -i -e "s/PasswordAuthentication.*/PasswordAuthentication no/" /etc/ssh/sshd_config
sudo service ssh restart

# Install docker & docker-compose
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo usermod -aG docker $USERNAME
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm ./kubectl

sudo ufw deny http
sudo ufw deny https

echo
echo "Done!"
echo
