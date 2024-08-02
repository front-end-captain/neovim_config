local M = {}

local os = require("os")

local function getHOME()
  local os_name = os.getenv("OS")
  if os_name == "Windows_NT" then
    return os.getenv("HOMEDRIVE") .. os.getenv("HOMEPATH")
  end

  return os.getenv("HOME")
end

local path_separator = package.config:sub(1, 1)

local HOME = getHOME()

local DEFAULT_BACKGROUND = "dark"

local wezterm_color_scheme_path = ""

if string.find(os.getenv("WSL_DISTRO_NAME"), "Ubuntu") then
  wezterm_color_scheme_path = os.getenv("WINDOWS_HOME")
    .. path_separator
    .. table.concat({ ".config", "wezterm", "wezterm_color_scheme.lua" }, path_separator)
else
  wezterm_color_scheme_path = HOME
    .. path_separator
    .. table.concat({ ".config", "wezterm", "wezterm_color_scheme.lua" }, path_separator)
end

local wezterm_color_scheme_ok, wezterm_color_scheme = pcall(require, "wezterm_color_scheme")
local wezterm_color_schemes_ok, wezterm_color_schemes = pcall(require, "wezterm_color_schemes")

local wezterm_color_scheme_names = {}
if wezterm_color_schemes_ok then
  for _, scheme in pairs(wezterm_color_schemes) do
    wezterm_color_scheme_names[#wezterm_color_scheme_names + 1] = scheme.name
  end
end

local function find_background(current_scheme)
  local background = DEFAULT_BACKGROUND

  if wezterm_color_schemes_ok then
    for _, scheme in pairs(wezterm_color_schemes) do
      if scheme.name == current_scheme then
        background = scheme.background
      end
    end
  end

  return background
end

vim.o.termguicolors = true

vim.cmd([[highlight ColorColumn guibg=grey]])

local vscode_theme = {
  "Mofiqul/vscode.nvim",
  config = function()
    local bg = find_background(wezterm_color_scheme_ok and wezterm_color_scheme or "")
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
