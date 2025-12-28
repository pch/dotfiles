#!/usr/bin/env bash

source "${DOTFILES_DIR}/install/helpers.sh"

log "Configuring git..."

mkdir -p ~/.config/git
touch ~/.config/git/config

git config --global alias.co checkout
git config --global pull.rebase true
git config --global init.defaultBranch master

if ! git config --global --get user.name &>/dev/null; then
  full_name=$(gum input --placeholder "Used for git authentication (hit return to skip)" --prompt.foreground="#845DF9" --prompt "Full name> ")
  if [[ -n "$full_name" ]]; then
    git config --global user.name "$full_name"
  fi
fi

if ! git config --global --get user.email &>/dev/null; then
  email_address=$(gum input --placeholder "Used for git authentication (hit return to skip)" --prompt.foreground="#845DF9" --prompt "Email address> ")
  if [[ -n "$email_address" ]]; then
    git config --global user.email "$email_address"
  fi
fi

log "Git configuration complete."
