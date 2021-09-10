set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
set termguicolors

" Erase gutter column, so it doesn't interfere with LSP signs
highlight SignColumn guibg=NONE
