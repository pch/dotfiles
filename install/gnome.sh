#!/usr/bin/env bash
set -eu

source "${DOTFILES_DIR}/install/helpers.sh"

if uname -s | grep -q "Darwin"; then
  warn "GNOME is not available on macOS, skipping configuration." || return
fi

require_cmd "gsettings" "GNOME is not installed on this system, skipping configuration." || return

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ General                                                                    ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# Center new windows in the middle of the screen
gsettings set org.gnome.mutter center-new-windows true

# Enable 24-hour clock
gsettings set org.gnome.desktop.interface clock-format '24h'

# Hide the date
gsettings set org.gnome.desktop.interface clock-show-date false

# Celsius for weather
gsettings set org.gnome.GWeather4 temperature-unit centigrade

# Theme settings
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Hotkeys                                                                    ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# Caps lock as Ctrl (this is the way) + right Ctrl as Compose key
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps', 'compose:rctrl']"

# Close with Super+W (Alt+F4 is the default)
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>w']"

# Center window
gsettings set org.gnome.desktop.wm.keybindings move-to-center "['<Super><Control>Home']"

# Use 6 fixed workspaces
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 6

# Use alt for pinned apps
gsettings set org.gnome.shell.keybindings switch-to-application-1 "['<Alt>1']"
gsettings set org.gnome.shell.keybindings switch-to-application-2 "['<Alt>2']"
gsettings set org.gnome.shell.keybindings switch-to-application-3 "['<Alt>3']"
gsettings set org.gnome.shell.keybindings switch-to-application-4 "['<Alt>4']"
gsettings set org.gnome.shell.keybindings switch-to-application-5 "['<Alt>5']"
gsettings set org.gnome.shell.keybindings switch-to-application-6 "['<Alt>6']"
gsettings set org.gnome.shell.keybindings switch-to-application-7 "['<Alt>7']"
gsettings set org.gnome.shell.keybindings switch-to-application-8 "['<Alt>8']"
gsettings set org.gnome.shell.keybindings switch-to-application-9 "['<Alt>9']"

# Use super for workspaces
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']"

# Move window to workspace 1-6
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Super><Shift>1']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Super><Shift>2']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Super><Shift>3']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Super><Shift>4']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-5 "['<Super><Shift>5']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-6 "['<Super><Shift>6']"

# Resize windows
gsettings set org.gnome.desktop.wm.keybindings begin-resize "['<Super>BackSpace']"

gsettings set org.gnome.desktop.wm.keybindings switch-input-source "@as []"

custom_keybinding_paths=()

add_custom_keybinding() {
  local id="$1"
  local name="$2"
  local command="$3"
  local binding="$4"
  local path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${id}/"
  local schema="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${path}"

  custom_keybinding_paths+=("'${path}'")
  gsettings set "$schema" name "$name"
  gsettings set "$schema" command "$command"
  gsettings set "$schema" binding "$binding"
}

open_xdg_dir_command() {
  local dir="$1"

  printf "sh -c 'nautilus --new-window \"\$(xdg-user-dir %s)\"'" "$dir"
}

# start a new ghostty window (rather than just switch to the already open one)
add_custom_keybinding 0 'new ghostty window' 'ghostty' '<Shift><Alt>2'

# Copy GPG passphrase
add_custom_keybinding 1 'copy gpg passphrase to clipboard' "$HOME/.local/share/dotfiles/bin/gpg-copy-passphrase" '<Super><Alt>g'

# 1Password quick access
add_custom_keybinding 2 '1Password quick access' '/usr/bin/1password --quick-access' '<Shift><Super>slash'

# Directory quicklinks
add_custom_keybinding 3 'open documents' "$(open_xdg_dir_command DOCUMENTS)" '<Super><Alt>d'

custom_keybindings=$(IFS=, ; echo "[${custom_keybinding_paths[*]}]")
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$custom_keybindings"

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ Extensions                                                                 ║
# ╚════════════════════════════════════════════════════════════════════════════╝

pipx install gnome-extensions-cli --system-site-packages

mkdir -p ~/.local/share/glib-2.0/schemas

extensions=(
  just-perfection-desktop@just-perfection
  blur-my-shell@aunetx
  space-bar@luchrioh
  tophat@fflewddur.github.io
  AlphabeticalAppGrid@stuarthayhurst
  emoji-copy@felipeftn
)

for ext in "${extensions[@]}"; do
  gext install "$ext" || true
  cp ~/.local/share/gnome-shell/extensions/"$ext"/schemas/*.xml ~/.local/share/glib-2.0/schemas/
done

glib-compile-schemas ~/.local/share/glib-2.0/schemas

# Configure Just Perfection
gsettings set org.gnome.shell.extensions.just-perfection animation 2
gsettings set org.gnome.shell.extensions.just-perfection dash-app-running true
gsettings set org.gnome.shell.extensions.just-perfection workspace true
gsettings set org.gnome.shell.extensions.just-perfection workspace-popup false

# Configure Blur My Shell
gsettings set org.gnome.shell.extensions.blur-my-shell.appfolder blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.lockscreen blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.screenshot blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.window-list blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.panel blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.overview blur true
gsettings set org.gnome.shell.extensions.blur-my-shell.overview pipeline 'pipeline_default'
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock blur true
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock brightness 0.6
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock sigma 30
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock static-blur true
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock style-dash-to-dock 0

# Configure Space Bar
gsettings set org.gnome.shell.extensions.space-bar.behavior smart-workspace-names false
gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-activate-workspace-shortcuts false
gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-move-to-workspace-shortcuts true
gsettings set org.gnome.shell.extensions.space-bar.shortcuts open-menu "@as []"

# Configure TopHat
gsettings set org.gnome.shell.extensions.tophat show-icons false
gsettings set org.gnome.shell.extensions.tophat show-cpu false
gsettings set org.gnome.shell.extensions.tophat show-disk false
gsettings set org.gnome.shell.extensions.tophat show-mem false
gsettings set org.gnome.shell.extensions.tophat show-fs false
gsettings set org.gnome.shell.extensions.tophat network-usage-unit bits

# Configure AlphabeticalAppGrid
gsettings set org.gnome.shell.extensions.alphabetical-app-grid folder-order-position 'end'
