# My Dotfiles

This is my complete system setup for Arch Linux (GNOME + Hyprland).

Originally based on [Omarchy](https://omarchy.org/), but heavily modified and stripped down.

- Omarchy look/themes and keybindings
- ZSH
- PGP
- Ghostty
- Syncthing

These dotfiles are not meant to be generic, they are tailored to my personal workflow.

Work in progress.

## Arch Linux Setup

In `archinstall`, choose the following options:

| Section                        | Option                                                                         |
| ------------------------------ | ------------------------------------------------------------------------------ |
| Disk configuration             | Partitioning > Default partitioning layout > Select disk (with space + return) |
| Disk > File system             | btrfs (default structure: yes + use compression)                               |
| Disk > Disk encryption         | Encryption type: LUKS + Encryption password + Partitions (select the one)      |
| Disk > btrfs snapshots         | Snapper                                                                        |
| Bootloader                     | Limine                                                                         |
| Authentication > Root password | Set root password                                                              |
| Authentication > User account  | Add a user, set password, set superuser                                        |
| Applications > Audio           | pipewire                                                                       |
| Network configuration          | Networkmanager                                                                 |
| Additional packages            | curl                                                                           |

Once arch is installed, reboot, log in as your user and run the following command:

```bash
curl -fsSL https://raw.githubusercontent.com/pch/dotfiles/refs/heads/master/boot.sh | bash
```
