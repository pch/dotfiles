#!/usr/bin/env bash

# Prevent double sourcing
[[ -n "${HELPERS_LOADED:-}" ]] && return
HELPERS_LOADED=1

# Wrapper to use gum if available, otherwise just echo the last argument
# (because gum is not always installed during initial setup)
gum() {
  if command -v gum &> /dev/null; then
    command gum "$@"
  else
    echo "${@: -1}"  # just echo the last argument (the actual text)
  fi
}

log() {
  local script_name
  script_name=$(basename "${BASH_SOURCE[1]}")
  local msg
  msg="[$(date +'%Y-%m-%d %H:%M:%S')] [$script_name] $*"
  echo "$msg" >> "${DOTFILES_DIR}/install.log"
  gum join --horizontal "$(gum style --foreground 240 "[$script_name]")" "$(gum style --foreground 2 " $*")"
}

warn() {
  local script_name
  script_name=$(basename "${BASH_SOURCE[1]}")
  local msg
  msg="[$(date +'%Y-%m-%d %H:%M:%S')] [$script_name] WARNING: $*"
  echo "$msg" >> "${DOTFILES_DIR}/install.log"
  gum join --horizontal "$(gum style --foreground 240 "[$script_name]")" "$(gum style --foreground 3 " WARNING: $*")"
  return 1
}

error() {
  local script_name
  script_name=$(basename "${BASH_SOURCE[1]}")
  local msg
  msg="[$(date +'%Y-%m-%d %H:%M:%S')] [$script_name] ERROR: $*"
  echo "$msg" >> "${DOTFILES_DIR}/install.log"
  gum join --horizontal "$(gum style --foreground 240 "[$script_name]")" "$(gum style --foreground 1 " ERROR: $*")" >&2
  exit 1
}

require_cmd() {
  local cmd="$1"
  local message="${2:-$cmd not found, skipping.}"

  if ! command -v "$cmd" &> /dev/null; then
    warn "$message"
    return 1
  fi
  return 0
}

run_step() {
  local desc="$1"
  local script="$2"

  # If script doesn't start with /, prepend install dir
  if [[ "$script" != /* ]]; then
    script="${DOTFILES_DIR}/install/${script}"
  fi

  echo ""

  if command -v gum &> /dev/null; then
    gum style --border rounded --border-foreground 6 --padding "0 1" --bold "$desc"
  else
    printf "\033[1m==> %s\033[0m\n" "$desc"
  fi

  echo "[$(date +'%Y-%m-%d %H:%M:%S')] Running: $desc" >> "${DOTFILES_DIR}/install.log"
  source "$script" || true
}
