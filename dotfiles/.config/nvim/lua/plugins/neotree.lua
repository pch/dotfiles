return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = true,
      sources = {
        "filesystem",
        "buffers",
        "git_status",
      },
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      window = {
        position = "left",
        width = 32,
      },
    })

    vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file explorer" })
    vim.keymap.set("n", "<leader>E", "<cmd>Neotree reveal<cr>", { desc = "Reveal current file" })
    vim.keymap.set("n", "<leader>fe", "<cmd>Neotree filesystem reveal left<cr>", { desc = "File explorer" })
    vim.keymap.set("n", "<leader>gb", "<cmd>Neotree git_status<cr>", { desc = "Git status explorer" })
    vim.keymap.set("n", "<leader>be", "<cmd>Neotree buffers<cr>", { desc = "Buffer explorer" })
  end,
}
