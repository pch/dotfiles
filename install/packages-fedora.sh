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
  golang
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

install_rpm_fusion_packages() {
  log "Installing RPM Fusion packages..."

  sudo dnf install -y \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

  sudo dnf upgrade --refresh -y

  sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing || true
  sudo dnf swap -y libavcodec-free libavcodec-freeworld --allowerasing || true

  sudo dnf install -y \
    ffmpeg \
    libavcodec-freeworld \
    libheif-freeworld \
    libheif-tools \
    libwebp \
    libavif \
    ImageMagick \
    gstreamer1-plugins-bad-free \
    gstreamer1-plugins-bad-freeworld \
    gstreamer1-plugins-good \
    gstreamer1-plugins-base \
    gstreamer1-plugin-openh264 \
    gstreamer1-libav \
    lame \
    --allowerasing

  flatpak install -y flathub org.freedesktop.Platform.ffmpeg-full//24.08
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

  # Brave (don't use flatpak, it's a meess: can't be set as default, can't integrate with 1Password)
  log "Installing Brave..."
  sudo dnf config-manager addrepo --overwrite --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
  sudo dnf install -y brave-browser

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
  cargo install eza
}

log "Installing Fedora packages..."

install_main_packages
install_rpm_fusion_packages
install_copr_packages
install_extra

log "Fedora package installation complete."
