return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = {
        "c", "lua", "vim", "vimdoc", "go", "javascript", "html", "python", "typescript", "ruby", "markdown"
      },
      sync_install = false,
      highlight = { enable = true },
      indent = {
        enable = true,
        disable = { "ruby" },
      },
    })
  end
}
