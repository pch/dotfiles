vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Ctrl+c as Esc
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Save file with Ctrl+s
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<Cmd>w<CR>', { desc = 'Save file' })

vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- Splits
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below" })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right" })

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })

-- buffers
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting the buffer, visual mode" })
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d", { desc = "Delete without yanking" })
-- Move Lines
vim.keymap.set("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
vim.keymap.set("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
vim.keymap.set("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

vim.keymap.set("n", "<CR>", ":noh<CR><CR>", { desc = "Clear search result" })

-- Make the current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Rename current file, move to a new location, create directories if needed
local function rename_file()
  local old_name = vim.fn.expand('%')
  local new_name = vim.fn.input('New file name: ', old_name, 'file')

  if new_name ~= '' and new_name ~= old_name then
    -- Create directory if it doesn't exist
    local new_dir = vim.fn.fnamemodify(new_name, ':h')
    if vim.fn.isdirectory(new_dir) == 0 then
      vim.fn.mkdir(new_dir, 'p')
    end

    -- Save as new file and delete old file
    vim.cmd('saveas ' .. vim.fn.fnameescape(new_name))
    vim.fn.delete(old_name)
    vim.cmd('redraw!')
  end
end

vim.keymap.set("n", "<leader>fR", rename_file, { desc = "Rename File" })

-- Copy current file to a new location, create directories if needed
local function copy_file()
  local current_name = vim.fn.expand('%')
  local new_name = vim.fn.input('Copy file to: ', current_name, 'file')

  if new_name ~= '' then
    -- Create directory if it doesn't exist
    local new_dir = vim.fn.fnamemodify(new_name, ':h')
    if vim.fn.isdirectory(new_dir) == 0 then
      vim.fn.mkdir(new_dir, 'p')
    end

    -- Save as new file (stays in the new file buffer)
    vim.cmd('saveas ' .. vim.fn.fnameescape(new_name))
    vim.cmd('redraw!')
  end
end

vim.keymap.set("n", "<leader>fC", copy_file, { desc = "Copy File" })

-- Create a new file, create directories if needed
local function new_file()
  local new_name = vim.fn.input('New file path: ', '', 'file')

  if new_name ~= '' then
    -- Create directory if it doesn't exist
    local new_dir = vim.fn.fnamemodify(new_name, ':h')
    if vim.fn.isdirectory(new_dir) == 0 then
      vim.fn.mkdir(new_dir, 'p')
    end

    -- Open the new file in a buffer
    vim.cmd('edit ' .. vim.fn.fnameescape(new_name))
    vim.cmd('redraw!')
  end
end

vim.keymap.set("n", "<leader>fN", new_file, { desc = "New File" })

-- Copy file paths to system clipboard
vim.keymap.set("n", "<leader>yr", function()
  local path = vim.fn.expand('%:.')
  vim.fn.setreg('+', path)
  print('Copied relative path: ' .. path)
end, { desc = "Yank Relative Path" })

vim.keymap.set("n", "<leader>ya", function()
  local path = vim.fn.expand('%:p')
  vim.fn.setreg('+', path)
  print('Copied absolute path: ' .. path)
end, { desc = "Yank Absolute Path" })
