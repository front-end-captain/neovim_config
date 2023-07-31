local M = {}

-- local colorscheme = "gruvbox-baby"
-- local colorscheme = "zenbones"

local colorscheme = "material"
-- darker | lighter | oceanic | palenight | deep ocean
vim.g.material_style = "oceanic"

vim.o.background = "dark"
-- vim.o.background = "light"
vim.o.termguicolors = true

vim.cmd([[highlight ColorColumn guibg=grey]])

local gruvbox = {
  "luisiacc/gruvbox-baby",
  config = function()
    pcall(vim.cmd, "colorscheme " .. colorscheme)
  end,
}
local zenbones = {
  "mcchrish/zenbones.nvim",
  dependencies = { "rktjmp/lush.nvim" },
  config = function()
    pcall(vim.cmd, "colorscheme " .. colorscheme)
  end,
}
local material = {
  "marko-cerovac/material.nvim",
  config = function()
    pcall(vim.cmd, "colorscheme " .. colorscheme)
    -- local material = require("material")
  end,
}
table.insert(M, gruvbox)
table.insert(M, zenbones)
table.insert(M, material)

return M
