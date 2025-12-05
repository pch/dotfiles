#!/bin/bash
set -euo pipefail

# Ensure iwd service will be started
sudo systemctl enable iwd.service

cat <<EOF | sudo tee /etc/NetworkManager/conf.d/networkmanager.conf
[main]
dns=systemd-resolved

[device]
wifi.backend=iwd
EOF

# Prevent systemd-networkd-wait-online timeout on boot
sudo systemctl disable systemd-networkd-wait-online.service
sudo systemctl mask systemd-networkd-wait-online.service

# Mask WPA Supplicant to prevent it from being started by NetworkManager
sudo systemctl mask --now wpa_supplicant.service

# Mask systemd-networkd and its sockets to prevent it from being started
sudo systemctl mask --now systemd-networkd.socket
sudo systemctl mask --now systemd-networkd-varlink.socket
sudo systemctl mask --now systemd-networkd.service

sudo systemctl unmask systemd-resolved.service
sudo systemctl enable --now systemd-resolved.service

# Enable and start NetworkManager
sudo systemctl enable NetworkManager.service

# Prevent NetworkManager-wait-online timeout on boot
sudo systemctl mask NetworkManager-wait-online.service
