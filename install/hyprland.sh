#!/bin/bash
set -euo pipefail

source "${DOTFILES_DIR}/install/helpers.sh"

if ! command -v dnf &>/dev/null; then
  log "dnf not found, skipping Hyprland installation"
  exit 0
fi

PACKAGES=(
  hyprland
  hypridle
  hyprlock
  hyprsunset
  hyprland-guiutils
  hyprpaper
  hyprpicker
  waybar
  fuzzel
  grim
  slurp
  hyprshot
  swayosd
  wiremix
)

COPR_REPOS=(
  sdegler/hyprland
  erikreider/swayosd
)

log "Stowing Hyprland dotfiles..."
stow -d "${DOTFILES_DIR}" -t "${HOME}" dotfiles-hyprland
log "Hyprland dotfiles stowed successfully!"

log "Enabling COPR repositories for Hyprland..."
sudo dnf install -y dnf-plugins-core

for repo in "${COPR_REPOS[@]}"; do
  sudo dnf copr enable -y "$repo"
done

log "Installing Hyprland packages..."
sudo dnf install -y "${PACKAGES[@]}"

log "Hyprland installation completed successfully"
