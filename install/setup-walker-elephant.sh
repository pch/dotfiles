#!/bin/bash
set -euo pipefail

# Create pacman hook to restart walker after updates
sudo mkdir -p /etc/pacman.d/hooks
sudo tee /etc/pacman.d/hooks/walker-restart.hook >/dev/null <<EOF
[Trigger]
Type = Package
Operation = Upgrade
Target = walker
Target = walker-debug
Target = elephant*

[Action]
Description = Restarting Walker services after system update
When = PostTransaction
Exec = $DOTFILES_DIR/bin/restart-walker
EOF

elephant service enable
systemctl --user start elephant.service
