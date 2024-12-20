local utils = require("utils")

local M = {}

local DEFAULT_BACKGROUND = "dark"

local wezterm_color_scheme_path = utils.get_host_os_home()
  .. utils.path_separator
  .. table.concat({ ".config", "wezterm", "wezterm_color_scheme.lua" }, utils.path_separator)

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

local function setupTheme(scheme)
  local bg = find_background(scheme)
  vim.o.background = bg

  -- local vscode = require("vscode")
  -- vscode.setup({
  --   style = bg,
  --   italic_comments = true,
  -- })
  -- vscode.load()
  -- vim.cmd.colorscheme("vscode")

  vim.cmd.colorscheme("oxocarbon")
end

local function change_scheme(args)
  local scheme = args.args

  setupTheme(scheme)

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

local vscode_theme = {
  "Mofiqul/vscode.nvim",
  config = function()
    setupTheme(wezterm_color_scheme_ok and wezterm_color_scheme or "")
  end,
}
local oxocarbon_theme = {
  "nyoom-engineering/oxocarbon.nvim",
}

table.insert(M, vscode_theme)
table.insert(M, oxocarbon_theme)

return M
