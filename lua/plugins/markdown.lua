local M = {}
local spec = {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    file_types = { "markdown", "Avante" },
    heading = { icons = { "󰼏 ", "󰎨 " }, sign = false, border = true },
    code = {
      sign = false,
      style = "normal",
    },
  },
}

table.insert(M, spec)

return M
