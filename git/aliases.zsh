alias gst='git status'

# Remove `+` and `-` from start of diff lines; just rely upon color.
alias gd='git diff --color | sed -E "s/^([^-+ ]*)[-+ ]/\\1/" | less -r'

alias gc='git commit'
alias gca='git commit -a'
alias gco='git checkout'
alias gcb='git copy-branch-name'
