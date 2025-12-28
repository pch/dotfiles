#!/usr/bin/env bash

source "${DOTFILES_DIR}/install/helpers.sh"

require_cmd "systemctl" "systemd not found, skipping Syncthing configuration." || return

if systemctl --user is-enabled syncthing.service &>/dev/null; then
  log "Syncthing already enabled."
else
  log "Enabling and starting syncthing..."
  systemctl --user enable syncthing.service
  systemctl --user start syncthing.service
fi

log "Syncthing service is enabled."
