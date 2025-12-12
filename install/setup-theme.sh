# Set links for Nautilius action icons
sudo ln -snf /usr/share/icons/Adwaita/symbolic/actions/go-previous-symbolic.svg /usr/share/icons/Yaru/scalable/actions/go-previous-symbolic.svg
sudo ln -snf /usr/share/icons/Adwaita/symbolic/actions/go-next-symbolic.svg /usr/share/icons/Yaru/scalable/actions/go-next-symbolic.svg

# Set initial theme
mkdir -p ~/.config/current
ln -snf $DOTFILES_DIR/themes/tokyo-night ~/.config/current/theme
ln -snf ~/.config/current/theme/backgrounds/1-scenery-pink-lakeside-sunset-lake-landscape-scenic-panorama-7680x3215-144.png ~/.config/current/background

mkdir -p ~/.config/btop/themes
ln -snf ~/.config/current/theme/btop.theme ~/.config/btop/themes/current.theme

# Add managed policy directories for Chromium for theme changes
# sudo mkdir -p /etc/chromium/policies/managed
# sudo chmod a+rw /etc/chromium/policies/managed

sudo gtk-update-icon-cache /usr/share/icons/Yaru
