local M = {}

vim.o.termguicolors = true

vim.cmd([[highlight ColorColumn guibg=grey]])

local gruvbox = {
  "luisiacc/gruvbox-baby",
  config = function()
    vim.o.background = "dark"
  end,
}
local vscode = {
  "Mofiqul/vscode.nvim",
  config = function()
    vim.o.background = "light"
    require("vscode").setup({
      -- style = "light",
      transparent = true,
      italic_comments = true,
      disable_nvimtree_bg = true,
    })
    require("vscode").load()
  end,
}
local github = {
  "projekt0n/github-nvim-theme",
  config = function()
    vim.o.background = "light"
  end,
}
-- table.insert(M, gruvbox)
table.insert(M, vscode)
-- table.insert(M, github)

-- pcall(vim.cmd, "colorscheme " .. "gruvbox-baby")
pcall(vim.cmd, "colorscheme " .. "vscode")
-- pcall(vim.cmd, "colorscheme " .. "github_light")

return M
