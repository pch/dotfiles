#!/usr/bin/env bash
set -eu

source "${DOTFILES_DIR}/install/helpers.sh"

require_cmd "dnf" "dnf not found, skipping Hyprland installation." || return

if ! gum confirm "Install Hyprland packages and config?"; then
  log "Skipping Hyprland installation."
  return
fi

PACKAGES=(
  fuzzel
  grim
  hyprland
  hyprland-guiutils
  hypridle
  hyprlock
  hyprpaper
  hyprpicker
  hyprshot
  hyprsunset
  slurp
  swayosd
  waybar
  wiremix
  xdg-terminal-exec
)

COPR_REPOS=(
  sdegler/hyprland
  erikreider/swayosd
)

log "Stowing Hyprland dotfiles..."
stow -d "${DOTFILES_DIR}" -t "${HOME}" dotfiles-hyprland
log "Hyprland dotfiles stowed."

log "Enabling COPR repositories for Hyprland..."
sudo dnf install -y dnf-plugins-core

for repo in "${COPR_REPOS[@]}"; do
  sudo dnf copr enable -y "$repo"
done

log "Installing Hyprland packages..."
sudo dnf install -y "${PACKAGES[@]}"

log "Hyprland installation complete."
