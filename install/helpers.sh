#!/bin/bash

# Prevent double sourcing
[[ -n "${HELPERS_LOADED:-}" ]] && return
HELPERS_LOADED=1

# Logging functions
log() {
  local msg
  msg="[$(date +'%Y-%m-%d %H:%M:%S')] $*"
  echo "$msg" >> "${DOTFILES_DIR}/install.log"
  gum style --foreground 2 "$*"
}

error() {
  local msg
  msg="[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $*"
  echo "$msg" >> "${DOTFILES_DIR}/install.log"
  gum style --foreground 1 "ERROR: $*" >&2
  exit 1
}

# Cleanup trap
cleanup() {
  local exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    log "Installation failed with exit code $exit_code"
    log "Check ${DOTFILES_DIR}/install.log for details"
  fi
}

# Run step helper
run_step() {
  local desc="$1"
  local script="$2"
  log "Running: $desc"
  source "$script"
}
