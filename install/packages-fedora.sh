#!/usr/bin/env bash
set -eu

source "${DOTFILES_DIR}/install/helpers.sh"

require_cmd "dnf" "dnf not found. This script is only for Fedora-based systems." || return

MAIN_PACKAGES=(
  atuin
  bat
  btop
  cargo
  exiftool
  fd
  ffmpeg
  ffmpegthumbnailer
  fortune-mod
  fzf
  git
  gum
  ImageMagick
  jq
  neovim
  pipx
  ripgrep
  rsync
  shellcheck
  stow
  syncthing
  tldr
  unzip
  vips
  zoxide
  zsh
)

COPR_PACKAGES=(
  jdxcode/mise
  scottames/ghostty
)

log "Updating system packages..."
sudo dnf upgrade -y --refresh

install_gum() {
  if ! command -v gum &>/dev/null; then
    echo "Installing gum..."
    sudo dnf install -y gum
  fi
}

# Install gum first so we can have pretty logs
install_gum

install_main_packages() {
  log "Installing main packages..."
  sudo dnf install -y "${MAIN_PACKAGES[@]}" || true
}

install_copr_packages() {
  log "Installing COPR packages..."
  for repo in "${COPR_PACKAGES[@]}"; do
    local package="${repo##*/}"
    log "Enabling COPR repository: $repo..."
    sudo dnf copr enable -y "$repo"
    log "Installing: $package..."
    sudo dnf install -y "$package" || true
  done
}

install_extra() {
  log "Installing extra packages with custom repositories..."

  # Docker
  log "Installing Docker..."
  sudo dnf config-manager addrepo --overwrite --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
  sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  # 1Password (beta)
  if uname -m | grep -q 'aarch64\|arm64'; then
    log "1Password beta is not available for ARM architectures. Skipping installation."
    log "Install manually via: https://support.1password.com/betas/?linux#arm-or-other-distributions-targz"
  else
    log "Installing 1Password (beta)..."
    sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
    sudo sh -c 'echo -e "[1password]\nname=1Password Beta Channel\nbaseurl=https://downloads.1password.com/linux/rpm/beta/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
    sudo dnf install -y 1password 1password-cli
  fi

  log "Installing starship..."
  curl -sS https://starship.rs/install.sh | sh

  log "Installing eza..."
  cargo install eza<D-s>
}

log "Installing Fedora packages..."

install_main_packages
install_copr_packages
install_extra

log "Fedora package installation complete."
