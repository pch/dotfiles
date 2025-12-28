#!/bin/bash

source "${DOTFILES_DIR}/install/helpers.sh"

if ! command -v systemctl &> /dev/null; then
  log "systemd not found, skipping Syncthing configuration."
  exit 0
fi

if systemctl --user is-enabled syncthing.service &>/dev/null; then
  log "Syncthing already enabled"
else
  log "Enabling and starting syncthing..."
  systemctl --user enable syncthing.service
  systemctl --user start syncthing.service
fi
