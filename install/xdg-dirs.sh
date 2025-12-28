#!/bin/bash
set -euo pipefail

source "${DOTFILES_DIR}/install/helpers.sh"

if ! command -v xdg-user-dirs-update &> /dev/null; then
  log "xdg-user-dirs-update not found, skipping."
  exit 0
fi

USER_DIRS_FILE="$HOME/.config/user-dirs.dirs"
USER_CONF_FILE="$HOME/.config/user-dirs.conf"

# custom user-dirs (can't be a symlink)
cat > "$USER_DIRS_FILE" << EOF
# This file is written by the user's custom script.
# Disable automatic updates via user-dirs.conf to keep these settings.
XDG_DOWNLOAD_DIR="\$HOME/Cloud/Downloads"
XDG_DESKTOP_DIR="\$HOME/Desktop"
XDG_TEMPLATES_DIR="\$HOME/Templates"
XDG_PUBLICSHARE_DIR="\$HOME/Public"
XDG_DOCUMENTS_DIR="\$HOME/Cloud/Documents"
XDG_MUSIC_DIR="\$HOME/Cloud/Music"
XDG_PICTURES_DIR="\$HOME/Cloud/Pictures"
XDG_VIDEOS_DIR="\$HOME/Cloud/Videos"
EOF

# Without this gnome will overwrite the above
echo "enabled=False" > "$USER_CONF_FILE"

mkdir -p "$HOME/Cloud/Downloads"
mkdir -p "$HOME/Cloud/Documents"
mkdir -p "$HOME/Cloud/Music"
mkdir -p "$HOME/Cloud/Pictures"
mkdir -p "$HOME/Cloud/Videos"

# Ask before removing existing directories
DIRS_TO_REMOVE=(
  "$HOME/Downloads"
  "$HOME/Documents"
  "$HOME/Music"
  "$HOME/Pictures"
  "$HOME/Videos"
)

for dir in "${DIRS_TO_REMOVE[@]}"; do
  if [ -e "$dir" ]; then
    if gum confirm "Remove existing directory: $dir?"; then
      rm -rf "$dir"
      log "Removed $dir"
    else
      log "Skipped removing $dir"
    fi
  fi
done
