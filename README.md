# My dotfiles

My personal dotfiles for Linux.

Includes:

- Dual GNOME/Hyprland setup
- GNOME tweaks (basic extensions, workspaces, keybindings)
- Hyprland configuration (waybar, fuzzel, swayosd, hyprlock, hyprpaper)
- stow for symlinking the dotfiles directory
- ZSH
- Ghostty
- Syncthing
- PGP

## Compatibility

The `install/install.sh` script assumes Fedora Linux, but it won't hard-fail if run on a different Linux distribution (or macOS). The configs (hyprland, zsh) should work on other distributions, provided that the necessary packages are installed.

The zsh config should work on macOS as well.

## Installation

> [!NOTE]
> These dotfiles are not meant to be generic. Review carefully. Install at your own risk.

```bash
mkdir -p ~/.local/share/dotfiles
git clone https://github.com/pch/dotfiles ~/.local/share/dotfiles
cd ~/.local/share/dotfiles
./install/install.sh
```

GPG setup isn't triggered by default. Run it manually:

```bash
./install/gpg.sh
```
