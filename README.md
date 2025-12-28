# My Dotfiles

My personal dotfiles for Fedora Linux (GNOME + Hyprland).

Includes:

- GNOME tweaks
- Hyprland configuration
- stow for symlinking the dotfiles directory
- ZSH
- Ghostty
- Syncthing
- PGP

> [!NOTE]
> These dotfiles are not meant to be generic. Install at your own risk.

## Installation

```bash
mkdir -p ~/.local/share/dotfiles
git clone git@github.com:pch/dotfiles.git ~/.local/share/dotfiles
./install/install.sh
```

GPG setup isn't triggered by default. Run it manually:

```bash
./install/gpg.sh
```
