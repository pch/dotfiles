#!/bin/bash

mkdir -p ~/.config/git
touch ~/.config/git/config

git config --global alias.co checkout
git config --global pull.rebase true
git config --global init.defaultBranch master

full_name=$(gum input --placeholder "Used for git authentication (hit return to skip)" --prompt.foreground="#845DF9" --prompt "Full name> ")
email_address=$(gum input --placeholder "Used for git authentication (hit return to skip)" --prompt.foreground="#845DF9" --prompt "Email address> ")

if [[ -n "$full_name" ]]; then
  git config --global user.name "$full_name"
fi

if [[ -n "$email_address" ]]; then
  git config --global user.email "$email_address"
fi

git config --global user.signingkey 1E5426A43FB77000
git config --global commit.gpgsign true
git config --global tag.gpgSign true
