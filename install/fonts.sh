#!/bin/bash
set -euo pipefail

source "${DOTFILES_DIR}/install/helpers.sh"

JETBRAINS_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"
FONT_DIR="${HOME}/.local/share/fonts"
TEMP_DIR=$(mktemp -d)

mkdir -p "${FONT_DIR}"

# Install JetBrains Mono Nerd Font
if fc-list | grep -q "JetBrainsMono Nerd Font"; then
  log "JetBrains Mono Nerd Font already installed, skipping..."
else
  log "Downloading JetBrains Mono Nerd Font..."
  curl -L "${JETBRAINS_URL}" -o "${TEMP_DIR}/JetBrainsMono.zip"

  log "Extracting JetBrains Mono fonts..."
  unzip -o "${TEMP_DIR}/JetBrainsMono.zip" -d "${TEMP_DIR}/JetBrainsMono"

  log "Installing JetBrains Mono fonts..."
  cp "${TEMP_DIR}/JetBrainsMono"/*.ttf "${FONT_DIR}/"

  rm -rf "${TEMP_DIR}"
fi

# Install Inter font
if dnf list installed rsms-inter-fonts &>/dev/null; then
  log "Inter font already installed, skipping..."
else
  log "Installing Inter font..."
  sudo dnf install -y rsms-inter-fonts
fi

log "Rebuilding font cache..."
fc-cache -fv

log "Fonts installed successfully!"
