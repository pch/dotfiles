#!/bin/bash

echo "Updating system packages..."
sudo pacman -Syu --noconfirm

echo "Installing base development tools..."
sudo pacman -S --needed --noconfirm base-devel git

install_yay() {
  if ! command -v yay &>/dev/null; then
    echo "Installing yay AUR helper..."
    local tmpdir
    tmpdir=$(mktemp -d)
    trap 'rm -rf "$tmpdir"' RETURN
    git clone https://aur.archlinux.org/yay.git "$tmpdir/yay" || { echo "Failed to clone yay"; exit 1; }
    cd "$tmpdir/yay" || exit 1
    makepkg -si --noconfirm || { echo "Failed to build yay"; exit 1; }
    cd - >/dev/null || exit 1
    echo "yay installed successfully"
  else
    echo "yay already installed"
  fi
}

install_gum() {
  if ! command -v gum &>/dev/null; then
    echo "Installing gum..."
    yay -S --needed --noconfirm gum
  fi
}

install_packages() {
  log "Reading package list..."
  mapfile -t packages < <(grep -v '^#' "$DOTFILES_DIR/install/packages.txt" | grep -v '^$')

  log "Installing packages..."
  yay -S --needed --noconfirm "${packages[@]}"
}

# Run installation
install_yay
install_gum

# Source helper functions now that gum is available
source "${DOTFILES_DIR}/install/helpers.sh"
trap cleanup EXIT

install_packages
