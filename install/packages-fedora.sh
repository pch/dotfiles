#!/bin/bash
set -euo pipefail

if ! command -v dnf &>/dev/null; then
  echo "Error: dnf not found. This script is only for Fedora-based systems."
  exit 1
fi

MAIN_PACKAGES=(
  bat
  btop
  cargo
  eza
  fd
  ffmpeg
  ffmpegthumbnailer
  fzf
  git
  gum
  ImageMagick
  jq
  neovim
  ripgrep
  rsync
  starship
  stow
  tldr
  unzip
  zoxide
  atuin
  exiftool
  fortune-mod
  vips
  shellcheck
  syncthing
  pipx
)

COPR_PACKAGES=(
  jdxcode/mise
  scottames/ghostty
)

echo "Updating system packages..."
sudo dnf upgrade -y --refresh

install_gum() {
  if ! command -v gum &>/dev/null; then
    echo "Installing gum..."
    sudo dnf install -y gum
  fi
}

# Install gum first so we can use log function
install_gum

# Source helper functions now that gum is available
source "${DOTFILES_DIR}/install/helpers.sh"
trap cleanup EXIT

install_main_packages() {
  log "Installing main packages..."
  sudo dnf install -y "${MAIN_PACKAGES[@]}" || true
}

install_copr_packages() {
  log "Installing COPR packages..."
  for repo in "${COPR_PACKAGES[@]}"; do
    local package="${repo##*/}"
    log "Enabling COPR repository: $repo"
    sudo dnf copr enable -y "$repo"
    log "Installing: $package"
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
    sudo dnf install -y 1password
  fi

  # wl-cliboard (built from source for the --sensitive option support)
  log "Installing wl-clipboard from source..."
  sudo dnf install -y meson ninja-build
  TEMP_DIR=$(mktemp -d)
  git clone https://github.com/bugaevc/wl-clipboard.git "${TEMP_DIR}/wl-clipboard"
  pushd "${TEMP_DIR}/wl-clipboard" >/dev/null
  meson setup build
  cd build
  ninja
  sudo ninja install
  popd >/dev/null
  rm -rf "${TEMP_DIR}"
}

clear
gum style --foreground 3 --padding "1 0 0 1" "Installing..."

install_main_packages
install_copr_packages
install_extra
