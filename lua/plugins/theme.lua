local M = {}

vim.o.termguicolors = true

vim.cmd([[highlight ColorColumn guibg=grey]])

local vscode = {
  "Mofiqul/vscode.nvim",
  config = function()
    vim.o.background = "dark"
    local vscode = require("vscode")
    vscode.setup({
      style = 'dark',
      italic_comments = true,
      disable_nvimtree_bg = true,
    })
    vscode.load()
  end,
}

table.insert(M, vscode)

pcall(vim.cmd, "colorscheme " .. "vscode")

local function change_theme_style(args)
  local theme_style = args.args;

  local vscode = require("vscode")
  vim.o.background = theme_style
  vscode.setup({
    style = theme_style,
  })
  vscode.load()
end

vim.api.nvim_create_user_command("ChangeThemeStyle", change_theme_style, {
  nargs = 1,
  complete = function()
    return { "light", "dark" }
  end,
})

return M
