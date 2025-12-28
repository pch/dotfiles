#!/bin/bash
set -euo pipefail

source "${DOTFILES_DIR}/install/helpers.sh"

cat > "${HOME}/.zshenv" << 'EOF'
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
EOF
log "Created ~/.zshenv with custom ZDOTDIR"

if [ "$SHELL" != "$(which zsh)" ]; then
  log "Changing default shell to zsh..."
  chsh -s "$(which zsh)"
else
  warn "Default shell is already zsh, skipping."
fi
