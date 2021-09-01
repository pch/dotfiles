set nocompatible                " choose no compatibility with legacy vi
syntax enable
set encoding=utf-8
set showcmd                     " display incomplete commands
filetype plugin indent on       " load file type plugins + indentation

set autowrite     " Automatically :write before running commands

set backspace=2   " Backspace deletes like most programs in insert mode
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set laststatus=2  " Always display the status line
set timeout timeoutlen=1000 ttimeoutlen=101 " fast insert with "O"
set cursorline

" Backups (stolen from Steve Losh)
set backup                        " enable backups
set noswapfile                    " it's 2013, Vim.

set history=1000
set undofile
set undoreload=10000

set undodir=~/.vim/tmp/undo//     " undo files
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

set number
set relativenumber

" Auto-reload buffers when file changed on disk
set autoread

" Make it obvious where 90 characters is
set textwidth=90
set colorcolumn=+1

"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

" Mouse
set mouse=a

" set guifont=DejaVu\ Sans\ Mono:h12
set guifont=Fira\ Mono:h12

let mapleader=","

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Switch between files by hitting ,, twice
nnoremap <leader><leader> <c-^>

" Clear search results by hitting Enter
nnoremap <CR> :noh<CR><CR>

" easier navigation between split windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" unmap ex mode: 'Type visual to go into Normal mode.'
nnoremap Q <nop>

" paste lines from the system register and fix indentation
nmap <leader>p "*pV`]=
nmap <leader>P "*PV`]=

" paste lines from the unnamed register and fix indentation
nmap <leader>pp pV`]=
nmap <leader>PP PV`]=

" copy to system clipboard with <leader>y
map <leader>y "*y

" copy current file path to system clipboard
nmap <leader>cs :let @*=expand("%")<CR>
" copy current (full) file path to system clipboard
nmap <leader>cl :let @*=expand("%:p")<CR>

" Formatting, TextMate-style
nnoremap Q gqip
vnoremap Q gq

" Quick save
nmap <leader>s :update<CR>

" display trailing whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" remove traling whitespace on save
" autocmd FileType rb,erb,html,css,js,coffee,sass,haml autocmd BufWritePre <buffer> :%s/\s\+$//e

autocmd BufWritePre * :%s/\s\+$//e " the command above doesn't seem to work

" no beeps!
set visualbell
set t_vb=

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" Map ,f to open fuzzy find (FZF)
nnoremap <Leader>f :Files<cr>

" Map ,b fo open fuzzy find for open buffers
nnoremap <Leader>b :Buffers<cr>

" airline options
" let g:airline_powerline_fonts=1
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_theme='base16'

" Disable annoying markdown folding
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1

" ctags
set tags+=.git/tags
map <Leader>rt :!ctags --tag-relative --extra=+f -Rf.git/tags --exclude=.git,pkg --languages=-javascript,sql<CR><CR>

" easier indentation in visual mode
vmap q <gv
vmap <TAB> >gv

" Use one space, not two, after punctuation.
set nojoinspaces

if executable('rg')
  " Use rg in fzf for listing files. Lightning fast and respects .gitignore
  let $FZF_DEFAULT_COMMAND = 'RIPGREP_CONFIG_PATH=~/.ripgreprc rg --files'

  nnoremap \ :Rg<SPACE>

  " Search for word under cursor
  nnoremap <silent> <Leader>rg :Rg <C-R><C-W><CR>
endif

let base16colorspace=256  " Access colors present in 256 colorspace
set t_Co=256 " 256 color mode

set background=dark

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
  autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx
  autocmd BufRead,BufNewFile aliases.local,zshrc.local,*/zsh/configs/* set filetype=sh
  autocmd BufRead,BufNewFile gitconfig.local set filetype=gitconfig

  autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx
  autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx

  " Fix out-of-sync syntax highlighting in JS files
  autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
  autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

  " Wrap lines in markdown files
  autocmd FileType markdown setlocal wrap
  autocmd FileType markdown setlocal linebreak

  " Automatically wrap at 80 characters for Markdown
  " autocmd BufRead,BufNewFile *.md setlocal textwidth=80

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-

  " Always open quickfix window at the bottom
  autocmd FileType qf wincmd J
augroup END

" ALE linting events
augroup ale
  autocmd!

  autocmd VimEnter *
        \ set updatetime=1000 |
        \ let g:ale_lint_on_text_changed = 0
  autocmd CursorHold * call ale#Queue(0)
  autocmd CursorHoldI * call ale#Queue(0)
  autocmd InsertEnter * call ale#Queue(0)
  autocmd InsertLeave * call ale#Queue(0)
augroup END

" Move between linting errors
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>

let g:ale_linters = {'javascript': ['prettier', 'eslint'], 'typescript': ['tsserver', 'eslint'], 'typescript.tsx': ['tsserver', 'eslint']}
let g:ale_fixers = {'javascript': ['prettier'], 'typescript': ['prettier'], 'typescript.tsx': ['prettier']}
let g:ale_fix_on_save = 1
" Only run linters named in ale_linters settings.
let g:ale_linters_explicit = 1
let g:ale_cache_executable_check_failures = 1

" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
" via Gary Bernhardt
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

function MkNonExDir(file)
    let dir = fnamemodify(a:file, ':h')
    if !isdirectory(dir)
        call mkdir(dir, 'p')
    endif
endfunction

" rename current file, via Gary Bernhardt
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        call MkNonExDir(new_name)
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

" save current file in a new location, without deleting the original
function! CopyFile()
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != ''
        call MkNonExDir(new_name)
        exec ':saveas ' . new_name
        redraw!
    endif
endfunction
map <leader>nn :call CopyFile()<cr>

" Abbreviations / common typos
abbr funciton function
abbr teh the
abbr tempalte template
abbr fitler filter
