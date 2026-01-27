
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export DOTFILES_DIR="${HOME}/.local/share/dotfiles"
export PATH="./bin:${DOTFILES_DIR}/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.atuin/bin:$HOME/.opencode/bin:$PATH"
export EDITOR="nvim"

export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_DOWNLOAD_DIR="${HOME}/Cloud/Downloads"
export XDG_DESKTOP_DIR="${HOME}/Desktop"
export XDG_TEMPLATES_DIR="${HOME}/Templates"
export XDG_PUBLICSHARE_DIR="${HOME}/Public"
export XDG_DOCUMENTS_DIR="${HOME}/Cloud/Documents"
export XDG_MUSIC_DIR="${HOME}/Cloud/Music"
export XDG_PICTURES_DIR="${HOME}/Cloud/Pictures"
export XDG_VIDEOS_DIR="${HOME}/Cloud/Videos"
# On change adjust `${XDG_CONFIG_HOME}/user-dirs.dirs` as well!

autoload -U compinit
compinit

export XCOMPOSEFILE="${HOME}/.config/XCompose"
export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/rc"
export GNUPGHOME="${XDG_CONFIG_HOME:-$HOME/.config}/gnupg"

export HISTFILE="${HOME}/.zsh_history"
export HISTCONTROL="ignoredups:ignorespace"
export HISTSIZE="100000"
export HISTFILESIZE="200000"
export SAVEHIST="${HISTSIZE}"
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_VERIFY
setopt SHARE_HISTORY

# Use emacs key bindings
bindkey -e

export GPG_TTY=$TTY

alias vim='nvim'

alias cd='z'

if [ "$(uname -s)" = "Darwin" ] && [ -f "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if command -v eza &> /dev/null; then
  alias ls='eza  --time-style=relative --git --octal-permissions --icons --color=auto --binary -lg'
  alias ll='eza  --time-style=long-iso --git --octal-permissions --icons --color=auto --binary -la'
  alias lt='eza --tree --level=2 --long --git --octal-permissions --icons --color=auto --binary'
fi

alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

alias top='btop'

open() {
  xdg-open "$@" >/dev/null 2>&1 &
}

encode64() {
  echo -n "$1" | base64
}

decode64() {
  echo -n "$1" | base64 -d
}

if command -v fzf &> /dev/null; then
  source <(fzf --zsh)
fi

# Ghostty shell integration
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
  builtin source \
    "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
fi

if command -v atuin &> /dev/null; then
  eval "$(atuin init zsh)"
fi

if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi

if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# Auto-source zsh utilities from same directory
for file in ${ZDOTDIR}/*.zsh; do
  [ -f "$file" ] && source "$file"
done

if command -v fortune &> /dev/null; then
  fortune $XDG_DATA_HOME/fortune
  printf "\n"
fi
