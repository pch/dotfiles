#!/bin/bash
set -euo pipefail

source "${DOTFILES_DIR}/install/helpers.sh"

log "Creating .zshenv..."
cat > "${HOME}/.zshenv" << 'EOF'
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
EOF

if [ "$SHELL" != "$(which zsh)" ]; then
  log "Changing default shell to zsh..."
  chsh -s "$(which zsh)"
else
  log "Default shell is already zsh"
fi
