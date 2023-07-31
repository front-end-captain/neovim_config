local M = {}
local spec = {
  "kylechui/nvim-surround",
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup({})
  end,
}
table.insert(M, spec)
return M
