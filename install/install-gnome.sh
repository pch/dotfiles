#!/bin/bash

echo "Updating system packages..."
sudo pacman -Syu --noconfirm

install_gnome_packages() {
  log "Reading package list..."
  mapfile -t packages < <(grep -v '^#' "$DOTFILES_DIR/install/packages-gnome.txt" | grep -v '^$')

  log "Installing packages..."
  yay -S --needed --noconfirm "${packages[@]}"
}

# Source helper functions now that gum is available
source "${DOTFILES_DIR}/install/helpers.sh"
trap cleanup EXIT

install_gnome_packages
