#!/bin/bash

# Plymouth theme
sudo plymouth-set-default-theme bgrt

# Limine / snapper
yay -S --noconfirm --needed limine-snapper-sync limine-mkinitcpio-hook

sudo tee /etc/mkinitcpio.conf.d/arch_hooks.conf <<EOF >/dev/null
HOOKS=(base udev plymouth keyboard autodetect microcode modconf kms keymap consolefont block encrypt filesystems fsck btrfs-overlayfs)
EOF

# Find existing config to extract cmdline
# Check all possible locations (Limine 10.3.0+ checks same dir as EFI app first)
if [[ -f /boot/EFI/Limine/limine.conf ]]; then
  limine_config="/boot/EFI/Limine/limine.conf"
elif [[ -f /boot/EFI/limine/limine.conf ]]; then
  limine_config="/boot/EFI/limine/limine.conf"
elif [[ -f /boot/EFI/BOOT/limine.conf ]]; then
  limine_config="/boot/EFI/BOOT/limine.conf"
elif [[ -f /boot/limine.conf ]]; then
  limine_config="/boot/limine.conf"
else
  echo "Error: No existing Limine config found to extract cmdline" >&2
  exit 1
fi

CMDLINE=$(grep "^[[:space:]]*cmdline:" "$limine_config" | head -1 | sed 's/^[[:space:]]*cmdline:[[:space:]]*//')

# Remove stale EFI configs to prevent sync issues
# Limine 10.3.0+ searches same dir as EFI app first, but limine-update maintains /boot/limine.conf
# See: https://github.com/basecamp/omarchy/issues/3335 and https://github.com/basecamp/omarchy/discussions/3236
echo "Removing stale EFI configs to prevent boot issues..."
sudo rm -f /boot/EFI/limine/limine.conf /boot/EFI/Limine/limine.conf /boot/EFI/BOOT/limine.conf

sudo tee /etc/default/limine <<EOF >/dev/null
TARGET_OS_NAME="Arch Linux"

ESP_PATH="/boot"

KERNEL_CMDLINE[default]="$CMDLINE"
KERNEL_CMDLINE[default]+="quiet splash"

ENABLE_UKI=yes
CUSTOM_UKI_NAME="arch"

ENABLE_LIMINE_FALLBACK=yes

# Find and add other bootloaders
FIND_BOOTLOADERS=yes

BOOT_ORDER="*, *fallback, Snapshots"

MAX_SNAPSHOT_ENTRIES=5

SNAPSHOT_FORMAT_CHOICE=5
EOF

if ! sudo snapper list-configs 2>/dev/null | grep -q "root"; then
  sudo snapper -c root create-config /
fi

if ! sudo snapper list-configs 2>/dev/null | grep -q "home"; then
  sudo snapper -c home create-config /home
fi

# Tweak default Snapper configs
sudo sed -i 's/^TIMELINE_CREATE="yes"/TIMELINE_CREATE="no"/' /etc/snapper/configs/{root,home}
sudo sed -i 's/^NUMBER_LIMIT="50"/NUMBER_LIMIT="5"/' /etc/snapper/configs/{root,home}
sudo sed -i 's/^NUMBER_LIMIT_IMPORTANT="10"/NUMBER_LIMIT_IMPORTANT="5"/' /etc/snapper/configs/{root,home}

systemctl enable --now limine-snapper-sync.service

sudo limine-update
sudo limine-snapper-sync
