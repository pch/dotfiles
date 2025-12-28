#!/bin/bash
set -euo pipefail

source "${DOTFILES_DIR}/install/helpers.sh"

if ! command -v flatpak &> /dev/null; then
  log "Flatpak not found, skipping."
  exit 0
fi

FLATPAKS=(
  com.brave.Browser
  com.slack.Slack
  com.obsproject.Studio
  md.obsidian.Obsidian
  com.visualstudio.code
  org.libreoffice.LibreOffice
  org.localsend.localsend_app
)

if ! flatpak remote-list | grep -q flathub; then
  log "Adding Flathub repository..."
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
else
  log "Flathub repository already configured"
fi

log "Installing Flatpak applications..."
for app in "${FLATPAKS[@]}"; do
  if flatpak list --app | grep -q "$app"; then
    log "Already installed: $app"
  else
    log "Installing: $app"
    flatpak install -y flathub "$app" || log "Failed to install: $app"
  fi
done

log "Flatpak setup complete"
