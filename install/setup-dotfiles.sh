#!/bin/bash
set -euo pipefail

source "${DOTFILES_DIR}/install/helpers.sh"

log "Stowing dotfiles..."
stow -d "${DOTFILES_DIR}" -t "${HOME}" config
stow -d "${DOTFILES_DIR}" -t "${HOME}" data

log "Dotfiles stowed successfully!"
