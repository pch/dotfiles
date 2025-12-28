#!/usr/bin/env bash
set -eu

source "${DOTFILES_DIR}/install/helpers.sh"

require_cmd "stow" "GNU Stow not found, please install it first." || exit 1

log "Stowing dotfiles..."
stow -d "${DOTFILES_DIR}" -t "${HOME}" dotfiles

log "Dotfiles stowed."
