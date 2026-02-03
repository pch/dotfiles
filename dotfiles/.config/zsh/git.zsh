# https://gist.github.com/dhh/18575558fc5ee10f15b6cd3e108ed844

# Create a new worktree and branch from within current git directory.
gwta() {
  if [[ -z "$1" ]]; then
    echo "Usage: gwta [branch name]"
    return 1
  fi

  local branch="$1"
  local base="$(basename "$PWD")"
  local dest="../${base}--${branch}"

  git worktree add -b "$branch" "$dest"
  builtin cd "$dest"
}

# Remove worktree and branch from within active worktree directory.
gwtd() {
  if gum confirm "Remove worktree and branch?"; then
    local cwd base branch root

    cwd="$(pwd)"
    worktree="$(basename "$cwd")"

    # split on first `--`
    root="${worktree%%--*}"
    branch="${worktree#*--}"

    # Protect against accidentially nuking a non-worktree directory
    if [[ "$root" != "$worktree" ]]; then
      builtin cd "../$root"
      git worktree remove "$worktree" --force
      git branch -D "$branch"
    fi
  fi
}
