local M = {}

local HOME = os.getenv("HOME")
local wezterm_color_scheme_path = HOME .. "/.config/wezterm/wezterm_color_scheme.lua"

local wezterm_color_scheme = require("wezterm_color_scheme")
local wezterm_color_schemes = require("wezterm_color_schemes")
local wezterm_color_scheme_names = {}
for _, scheme in pairs(wezterm_color_schemes) do
  wezterm_color_scheme_names[#wezterm_color_scheme_names + 1] = scheme.name
end

local function find_background(current_scheme)
  local background = ""
  for _, scheme in pairs(wezterm_color_schemes) do
    if scheme.name == current_scheme then
      background = scheme.background
    end
  end

  return background
end

-- print(wezterm_color_schemes[1].name)

vim.o.termguicolors = true

vim.cmd([[highlight ColorColumn guibg=grey]])

local vscode_theme = {
  "Mofiqul/vscode.nvim",
  config = function()
    local bg = find_background(wezterm_color_scheme)
    vim.o.background = bg
    local vscode = require("vscode")
    vscode.setup({
      style = bg,
      italic_comments = true,
      disable_nvimtree_bg = true,
    })
    vscode.load()
  end,
}

table.insert(M, vscode_theme)

pcall(vim.cmd, "colorscheme " .. "vscode")

local function change_scheme(args)
  local scheme = args.args
  local bg = find_background(scheme)

  local vscode = require("vscode")
  vim.o.background = bg
  vscode.setup({
    style = bg,
  })
  vscode.load()

  local file = io.open(wezterm_color_scheme_path, "w")
  if file then
    file:write("return '" .. scheme .. "'")
    file:close()
  end
end

vim.api.nvim_create_user_command("ChangeScheme", change_scheme, {
  nargs = 1,
  complete = function()
    return wezterm_color_scheme_names
  end,
})

return M
