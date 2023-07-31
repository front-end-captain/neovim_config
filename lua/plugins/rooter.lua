local M = {}
local spec = {
  "notjedi/nvim-rooter.lua",
  event = "VeryLazy",
  config = function()
    require("nvim-rooter").setup({
      rooter_patterns = { ".git" },
      manual = false,
    })
  end,
}
table.insert(M, spec)
return M
