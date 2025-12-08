#!/bin/bash
set -euo pipefail

export DOTFILES_DIR="${HOME}/.local/share/dotfiles"
export INSTALL_DIR="${DOTFILES_DIR}/install"

# Cache sudo password
sudo -v

# Install packages (yay, gum, and all packages from lists)
source "${INSTALL_DIR}/install-packages.sh"

# Setup dotfiles
source "${INSTALL_DIR}/setup-dotfiles.sh"

clear
gum style --foreground 3 --padding "1 0 0 1" "Installing..."

run_step "Setup keyboard" "${INSTALL_DIR}/hardware/keyboard.sh"
run_step "Setup network" "${INSTALL_DIR}/hardware/network.sh"
run_step "Setup bluetooth" "${INSTALL_DIR}/hardware/bluetooth.sh"
run_step "Setup printer" "${INSTALL_DIR}/hardware/printer.sh"
run_step "Configure USB autosuspend" "${INSTALL_DIR}/hardware/usb-autosuspend.sh"

run_step "Setup gdm" "${INSTALL_DIR}/setup-display-manager.sh"
run_step "Setup bootloader" "${INSTALL_DIR}/setup-bootloader.sh"

run_step "Setup firewall" "${INSTALL_DIR}/setup-firewall.sh"
run_step "Setup mimetypes" "${INSTALL_DIR}/setup-mimetypes.sh"
run_step "Setup theme" "${INSTALL_DIR}/setup-theme.sh"
run_step "Setup walker elephant" "${INSTALL_DIR}/setup-walker-elephant.sh"
run_step "Setup power settings" "${INSTALL_DIR}/setup-power.sh"

run_step "Setup docker" "${INSTALL_DIR}/setup-docker.sh"
run_step "Setup ssh" "${INSTALL_DIR}/setup-ssh.sh"
run_step "Setup gpg" "${INSTALL_DIR}/setup-gpg.sh"
run_step "Setup git" "${INSTALL_DIR}/setup-git.sh"
run_step "Setup syncthing" "${INSTALL_DIR}/setup-syncthing.sh"
run_step "Setup zsh" "${INSTALL_DIR}/setup-zsh.sh"

log "Updating locate database..."
sudo updatedb

log "Installation completed successfully!"

if gum confirm --padding "0 0 0 32" --show-help=false --default --affirmative "Reboot Now" --negative "Reboot Later" ""; then
  clear
  sudo reboot now
else
  log "Reboot skipped. Remember to reboot to complete the installation."
fi
