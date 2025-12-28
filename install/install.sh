#!/bin/bash
set -euo pipefail

export DOTFILES_DIR="${HOME}/.local/share/dotfiles"
export INSTALL_DIR="${DOTFILES_DIR}/install"

# Cache sudo password
sudo -v

# Install packages
source "${INSTALL_DIR}/packages-fedora.sh"

run_step "Setup dotfiles" "${INSTALL_DIR}/dotfiles.sh"
run_step "Setup xdg directories" "${INSTALL_DIR}/xdg-dirs.sh"
run_step "Setup zsh" "${INSTALL_DIR}/zsh.sh"
run_step "Setup docker" "${INSTALL_DIR}/docker.sh"
run_step "Setup git" "${INSTALL_DIR}/git.sh"
run_step "Setup syncthing" "${INSTALL_DIR}/syncthing.sh"
run_step "Setup fonts" "${INSTALL_DIR}/fonts.sh"
run_step "Setup gnome" "${INSTALL_DIR}/gnome.sh"
run_step "Setup hyprland" "${INSTALL_DIR}/hyprland.sh"

# Run this manually - it requires 1Password vault to be set up first
# run_step "Setup gpg" "${INSTALL_DIR}/gpg.sh"

log "Updating locate database..."
sudo updatedb

log "Installation completed successfully!"
