#!/bin/bash
#
# Dotfiles Bootstrap Script
#
# This script bootstraps the installation of dotfiles from GitHub.
# It clones the repository, prepares the environment, and runs the main installer.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/pch/dotfiles/master/boot.sh | bash
#

set -euo pipefail

DOTFILES_REPO="pch/dotfiles"
DOTFILES_DIR="${HOME}/.local/share/dotfiles"

cat <<"EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║           DOTFILES INSTALLATION BOOTSTRAP                 ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF

echo ""
echo "Repository: ${DOTFILES_REPO}"
echo "Target: ${DOTFILES_DIR}"
echo ""

if ! command -v git &>/dev/null; then
  echo "Git not found. Please install it first."
  exit 1
fi

if [ -d "${DOTFILES_DIR}" ]; then
  echo "Backing up existing dotfiles directory..."
  backup_dir="${DOTFILES_DIR}.bak.$(date +%Y%m%d_%H%M%S)"
  mv "${DOTFILES_DIR}" "${backup_dir}"
  echo "Backup saved to: ${backup_dir}"
fi

echo "Creating dotfiles directory... $DOTFILES_DIR"
mkdir -p "${DOTFILES_DIR}"

echo "Creating .config directory... ${HOME}/.config"
mkdir -p "${HOME}/.config"

echo "Cloning repository from https://github.com/${DOTFILES_REPO}..."
git clone "git@github.com:${DOTFILES_REPO}.git" "${DOTFILES_DIR}"

echo ""
echo "Repository cloned successfully!"
echo "Starting installation..."
echo ""

source "${DOTFILES_DIR}/install/install.sh"
