#!/bin/bash
set -eou pipefail

source "${DOTFILES_DIR}/install/helpers.sh"

# Battery monitor
if ls /sys/class/power_supply/BAT* &>/dev/null; then
  # This computer runs on a battery
  powerprofilesctl set balanced || true

  # Enable battery monitoring timer for low battery notifications
  systemctl --user enable --now battery-monitor.timer
else
  # This computer runs on power outlet
  powerprofilesctl set performance || true
fi

# Fast shutdown
sudo mkdir -p /etc/systemd/system.conf.d

cat <<EOF | sudo tee /etc/systemd/system.conf.d/10-faster-shutdown.conf
[Manager]
DefaultTimeoutStopSec=5s
EOF
sudo systemctl daemon-reload

# Disable systemd's default power button shutdown behavior
# This allows Hyprland to handle the power button and show a custom power menu
# See: config/.config/hypr/bindings.conf (bindld XF86PowerOff -> system-menu system)

log "Disabling systemd power button shutdown..."
sudo sed -i 's/.*HandlePowerKey=.*/HandlePowerKey=ignore/' /etc/systemd/logind.conf

log "Power button configured to use custom menu"

# Ensure we use system python3 and not mise's python3
sudo sed -i '/env python3/ c\#!/bin/python3' /usr/bin/powerprofilesctl
