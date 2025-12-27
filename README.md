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
curl -fsSL https://raw.githubusercontent.com/pch/dotfiles/refs/heads/master/boot.sh | bash
```

GPG setup isn't triggered by default. Run it manually:

```bash
./install/gpg.sh
```

To install Hyprland packages and dotfiles, run:

```bash
./install/hyprland.sh
```
