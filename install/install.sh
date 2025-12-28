#!/usr/bin/env bash
set -eu

export DOTFILES_DIR="${HOME}/.local/share/dotfiles"

source "${DOTFILES_DIR}/install/helpers.sh"

# Cache sudo password
sudo -v

run_step "Install packages" "packages-fedora.sh"

run_step "Setup dotfiles" "dotfiles.sh"
run_step "Setup xdg directories" "xdg-dirs.sh"
run_step "Setup zsh" "zsh.sh"
run_step "Setup git" "git.sh"
run_step "Setup gnome" "gnome.sh"
run_step "Setup hyprland" "hyprland.sh"
run_step "Setup fonts" "fonts.sh"
run_step "Setup flatpaks" "flatpaks.sh"
run_step "Setup docker" "docker.sh"
run_step "Setup syncthing" "syncthing.sh"

# Run this manually - it requires 1Password vault to be set up first
# run_step "Setup gpg" "gpg.sh"

if ! require_cmd "locate" "locate command not found, skipping database update."; then
  log "Updating locate database..."
  sudo updatedb
fi

gum spin --spinner "globe" --padding "5 0"  --title "Done! Press any key to close..." -- bash -c 'read -n 1 -s'
