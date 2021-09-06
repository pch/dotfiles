# set up fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Source: https://github.com/sirupsen/zk
# If you're using fzf with vim, it's recommended to add this to your bash
# configuration. It adds super useful key-bindings to open files in splits
# (Ctrl-X/Ctrl-V) from zkt and zks directly. It also adds Ctrl-O to insert the
# file-name of whatever you're hovering into Vim, which is handy for links!:
export FZF_DEFAULT_OPTS="--height=40% --multi --tiebreak=begin \
  --bind 'ctrl-y:execute-silent(echo {} | pbcopy)' \
  --bind 'alt-down:preview-down,alt-up:preview-up' \
  --bind \"ctrl-v:execute-silent[ \
    tmux send-keys -t \{left\} Escape :vs Space && \
    tmux send-keys -t \{left\} -l {} && \
    tmux send-keys -t \{left\} Enter \
  ]\"
  --bind \"ctrl-x:execute-silent[ \
    tmux send-keys -t \{left\} Escape :sp Space && \
    tmux send-keys -t \{left\} -l {} && \
    tmux send-keys -t \{left\} Enter \
  ]\"
  --bind \"ctrl-o:execute-silent[ \
    tmux send-keys -t \{left\} Escape :read Space ! Space echo Space && \
    tmux send-keys -t \{left\} -l \\\"{}\\\" && \
    tmux send-keys -t \{left\} Enter \
  ]\""
