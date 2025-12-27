#!/bin/bash
set -euo pipefail

source "${DOTFILES_DIR}/install/helpers.sh"

export GPG_TTY=$(tty)
KEY_ID="1E5426A43FB77000"

if ! command -v gpg &>/dev/null; then
  error "GPG is not installed. Please install it first."
fi

if gpg --list-keys "$KEY_ID" &>/dev/null; then
  log "GPG key $KEY_ID is already imported."
  exit 0
fi

log "GPG key $KEY_ID not found. Attempting to import from 1Password..."

if ! command -v op &>/dev/null; then
  error "1Password CLI (op) is not installed. Please install it first."
fi

if ! op account list &>/dev/null; then
  error "Not signed in to 1Password. Please run 'eval \$(op signin)' first."
fi

log "Importing GPG key from 1Password..."
op read "op://Private/GPG Key/private_key" | gpg --import

if gpg --list-keys "$KEY_ID" &>/dev/null; then
  log "Successfully imported GPG key $KEY_ID"

  # Set trust level to ultimate for the key
  echo -e "5\ny\n" | gpg --command-fd 0 --expert --edit-key "$KEY_ID" trust quit

  git config --global user.signingkey "$KEY_ID"
  git config --global commit.gpgsign true
  git config --global tag.gpgSign true

  log "GPG setup complete!"
else
  error "Failed to import GPG key. Please check your 1Password reference."
fi
