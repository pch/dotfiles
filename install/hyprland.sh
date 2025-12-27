#!/bin/bash
set -euo pipefail

source "${DOTFILES_DIR}/install/helpers.sh"

packages=(
  hyprland
  hypridle
  hyprlock
  hyprsunset
  hyprland-guiutils
  hyprpaper
  hyprpicker
  waybar
  walker
  elephant
  grim
  slurp
  hyprshot
  swayosd
  wiremix
)

copr_repos=(
  sdegler/hyprland
  errornointernet/walker
  erikreider/swayosd
)

log "Stowing Hyprland dotfiles..."
stow -d "${DOTFILES_DIR}" -t "${HOME}" dotfiles-hyprland
log "Hyprland dotfiles stowed successfully!"

log "Enabling COPR repositories for Hyprland..."
sudo dnf install -y dnf-plugins-core

for repo in "${copr_repos[@]}"; do
  sudo dnf copr enable -y "$repo"
done

log "Installing Hyprland packages..."
sudo dnf install -y "${packages[@]}"

log "Hyprland installation completed successfully"
