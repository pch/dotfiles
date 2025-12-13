return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()

      -- Add Mason binaries to PATH
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
      vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
    end
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "prettier",
          "prettierd",
        },
      })
    end
  }
}
