#!/bin/bash
set -euo pipefail

source "${DOTFILES_DIR}/install/helpers.sh"

log "Stowing dotfiles..."
stow -d "${DOTFILES_DIR}" -t "${HOME}" dotfiles

log "Dotfiles stowed successfully!"
