set nocompatible                " choose no compatibility with legacy vi
syntax enable
set encoding=utf-8
set showcmd                     " display incomplete commands
filetype plugin indent on       " load file type plugins + indentation

set autowrite     " Automatically :write before running commands

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set laststatus=2  " Always display the status line
set timeout timeoutlen=1000 ttimeoutlen=101 " fast insert with "O"

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

" unmap ex mode: 'Type visual to go into Normal mode.'
nnoremap Q <nop>

" paste lines from unnamed register and fix indentation
nmap <leader>p "*pV`]=
nmap <leader>P "*PV`]=

" copy to system clipboard with <leader>y
map <leader>y "*y

" copy current file path to system clipboard
nmap <leader>cs :let @*=expand("%")<CR>
" copy current (full) file path to system clipboard
nmap <leader>cl :let @*=expand("%:p")<CR>

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

" rspec runner
let g:rspec_runner = "os_x_iterm2"

map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

" ctrlp config
let g:ctrlp_map = '<leader>f'
let g:ctrlp_max_height = 30
let g:ctrlp_working_path_mode = 0
let g:ctrlp_match_window_reversed = 0

" airline options
" let g:airline_powerline_fonts=1
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_theme='base16'

"" ctags
set tags+=.git/tags
map <Leader>rt :!ctags --tag-relative --extra=+f -Rf.git/tags --exclude=.git,pkg --languages=-javascript,sql<CR><CR>

" easier indentation in visual mode
vmap q <gv
vmap <TAB> >gv

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  " bind K to grep word under cursor
  nnoremap K :Ag --vimgrep "\b<C-R><C-W>\b"<CR>:cw<CR>

  " bind \ (backward slash) to grep shortcut
  command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

  nnoremap \ :Ag<SPACE>
endif

let base16colorspace=256  " Access colors present in 256 colorspace
set t_Co=256 " 256 color mode

set background=dark
colorscheme base16-tomorrow

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
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-
augroup END

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

" switch between test and production code (works with non-rails projects as well)
" via Gary Bernhardt
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1 || match(current_file, '\<helpers\>') != -1
  if going_to_spec
    if in_app
      let new_file = substitute(new_file, '^app/', '', '')
    end
    let new_file = substitute(new_file, '\.e\?rb$', '_spec.rb', '')
    let new_file = 'spec/' . new_file
  else
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, '^spec/', '', '')
    if in_app
      let new_file = 'app/' . new_file
    end
  endif
  return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>

" Abbreviations / common typos
abbr funciton function
abbr teh the
abbr tempalte template
abbr fitler filter
