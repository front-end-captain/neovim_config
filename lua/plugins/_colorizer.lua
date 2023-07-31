local M = {}
local spec = {
  "norcalli/nvim-colorizer.lua",
  event = "VeryLazy",
  config = function()
    require("colorizer").setup({})
  end,
}
table.insert(M, spec)
return M
