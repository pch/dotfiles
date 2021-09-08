if !exists('g:loaded_telescope') | finish | endif

nnoremap <silent> <leader>f <cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>
nnoremap <silent> <leader>rg <cmd>Telescope live_grep<cr>
nnoremap <silent> <leader>gs <cmd>Telescope grep_string<cr>
nnoremap <silent> \\ <cmd>Telescope buffers<cr>
nnoremap <silent> ;; <cmd>Telescope help_tags<cr>

" find files within [[links]] (notes)
" doesn't allow to select first match, so I'm leaving fzf for now
" nnoremap <silent> <leader>x yi[<cmd>Telescope find_files find_command=rg,--files,--ignore default_text=<C-R>"<CR>

lua << EOF
local actions = require('telescope.actions')
-- Global remapping
------------------------------
require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden"
    },
  }
}
EOF

