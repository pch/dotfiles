#!/bin/bash
#
# Initial user account setup for a remote development machine
#
# Sets up dotfiles, aliases, colors & other basic tools
#
# ssh -t <user>@<IP> "$(cat ~/.dotfiles/ubuntu/user.sh)"
#
set -e

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Dotfiles & colors
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
git clone https://github.com/pch/dotfiles.git ~/.dotfiles
cd .dotfiles
script/bootstrap
cd -

# vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

source ~/.zshrc

base16_tomorrow-night

# ssh agent forwarding fix for tmux
cat > ~/.ssh/rc <<EOF
#!/bin/bash

if test "\$SSH_AUTH_SOCK" ; then
  ln -sf \$SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
fi
EOF

# DigitalOcean
sudo snap install doctl
sudo snap connect doctl:kube-config
doctl auth init
