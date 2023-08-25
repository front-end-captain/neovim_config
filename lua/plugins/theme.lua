local M = {}

vim.o.termguicolors = true

vim.cmd([[highlight ColorColumn guibg=grey]])

local vscode = {
  "Mofiqul/vscode.nvim",
  config = function()
    vim.o.background = "light"
    require("vscode").setup({
      style = "dark",
      italic_comments = true,
      disable_nvimtree_bg = true,
    })
    require("vscode").load()
  end,
}

table.insert(M, vscode)

pcall(vim.cmd, "colorscheme " .. "vscode")

return M
