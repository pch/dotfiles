# Set links for Nautilius action icons
sudo ln -snf /usr/share/icons/Adwaita/symbolic/actions/go-previous-symbolic.svg /usr/share/icons/Yaru/scalable/actions/go-previous-symbolic.svg
sudo ln -snf /usr/share/icons/Adwaita/symbolic/actions/go-next-symbolic.svg /usr/share/icons/Yaru/scalable/actions/go-next-symbolic.svg

# Set initial theme
mkdir -p ~/.config/current
ln -snf $DOTFILES_DIR/themes/tokyo-night ~/.config/current/theme
ln -snf ~/.config/current/theme/backgrounds/1-scenery-pink-lakeside-sunset-lake-landscape-scenic-panorama-7680x3215-144.png ~/.config/current/background

mkdir -p ~/.config/btop/themes
ln -snf ~/.config/current/theme/btop.theme ~/.config/btop/themes/current.theme

mkdir -p ~/.config/mako
ln -snf ~/.config/current/theme/mako.ini ~/.config/mako/config

# Add managed policy directories for Chromium for theme changes
# sudo mkdir -p /etc/chromium/policies/managed
# sudo chmod a+rw /etc/chromium/policies/managed

# Gnome theme
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface icon-theme "Yaru-blue"

sudo gtk-update-icon-cache /usr/share/icons/Yaru
