#!/bin/bash
set -euo pipefail

# Ensure iwd service will be started
sudo systemctl enable iwd.service

# Prevent systemd-networkd-wait-online timeout on boot
sudo systemctl disable systemd-networkd-wait-online.service
sudo systemctl mask systemd-networkd-wait-online.service

# https://wiki.archlinux.org/title/Systemd-resolved
echo "Symlink resolved stub-resolv to /etc/resolv.conf"

sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
