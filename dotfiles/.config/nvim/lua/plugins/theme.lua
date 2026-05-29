return {
  -- {
  --   "deparr/tairiki.nvim",
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme("tairiki")
  --   end,
  -- },
  -- {
  --   "folke/tokyonight.nvim",
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme("tokyonight-night")
  --   end,
  -- },
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        theme = "wave",
        colors = {
          -- palette = {},
          theme = {
            wave = {},
            lotus = {},
            dragon = {},
            all = {
              ui = {
                bg_gutter = "none"
              }
            }
          },
        },
      })
      vim.cmd.colorscheme("kanagawa")
    end,
  },
}
