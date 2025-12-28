#!/bin/bash

source "${DOTFILES_DIR}/install/helpers.sh"

if ! command -v systemctl &> /dev/null; then
  warn "systemd not found, skipping Syncthing configuration." || return
fi

if systemctl --user is-enabled syncthing.service &>/dev/null; then
  warn "Syncthing already enabled"
else
  log "Enabling and starting syncthing..."
  systemctl --user enable syncthing.service
  systemctl --user start syncthing.service
fi

log "Syncthing service is enabled"
