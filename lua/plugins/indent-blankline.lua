local M = {}
local spec = {
  "lukas-reineke/indent-blankline.nvim",
  -- event = "VeryLazy",
  main = "ibl",
  config = function()
    require("ibl").setup({})
  end,
}
table.insert(M, spec)
return M
