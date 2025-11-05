#!/bin/bash
set -euo pipefail

sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow ports for LocalSend
sudo ufw allow 53317/udp
sudo ufw allow 53317/tcp

# Allow Syncthing
sudo ufw allow syncthing

# Allow Docker containers to use DNS on host
sudo ufw allow in proto udp from 172.16.0.0/12 to 172.17.0.1 port 53 comment 'allow-docker-dns'

# Turn on the firewall
sudo ufw --force enable
sudo systemctl enable ufw

# Turn on Docker protections
sudo ufw-docker install
sudo ufw reload
