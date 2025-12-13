# Set initial theme
mkdir -p ~/.config/current
ln -snf $DOTFILES_DIR/themes/tokyo-night ~/.config/current/theme
ln -snf ~/.config/current/theme/backgrounds/3-Milad-Fakurian-Abstract-Purple-Blue.jpg ~/.config/current/background

mkdir -p ~/.config/btop/themes
ln -snf ~/.config/current/theme/btop.theme ~/.config/btop/themes/current.theme
