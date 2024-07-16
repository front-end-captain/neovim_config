local M = {}

local spec = {
  "nvim-tree/nvim-web-devicons",
  config = function()
    require("nvim-web-devicons").setup({
      color_icons = true,
    })
  end,
}
table.insert(M, spec)

return M
