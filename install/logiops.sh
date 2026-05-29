#!/usr/bin/env bash
set -eu

source "${DOTFILES_DIR}/install/helpers.sh"

CONFIG_SOURCE="${DOTFILES_DIR}/dotfiles/.config/logiops/logid.cfg"
CONFIG_TARGET="/etc/logid.cfg"

if ! command -v logid &>/dev/null; then
  log "Installing logiops..."
  sudo dnf install -y logiops
else
  log "logiops already installed."
fi

log "Installing logiops config..."
chmod 0644 "$CONFIG_SOURCE"

current_target=""
if [[ -e "$CONFIG_TARGET" || -L "$CONFIG_TARGET" ]]; then
  current_target="$(readlink -f "$CONFIG_TARGET" 2>/dev/null || true)"
fi

if [[ -n "$current_target" && ! "$CONFIG_TARGET" -ef "$CONFIG_SOURCE" ]]; then
  backup="${CONFIG_TARGET}.bak.$(date +%Y%m%d%H%M%S)"
  log "Backing up existing logiops config to $backup..."
  sudo cp -a "$CONFIG_TARGET" "$backup"
fi

sudo install -o root -g root -m 0644 "$CONFIG_SOURCE" "$CONFIG_TARGET"

log "Enabling and restarting logid.service..."
sudo systemctl enable logid.service
sudo systemctl restart logid.service

log "logiops is configured."
