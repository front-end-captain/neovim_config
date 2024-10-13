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

-- local vscode_theme = {
--   "Mofiqul/vscode.nvim",
--   config = function()
--     local bg = find_background(wezterm_color_scheme_ok and wezterm_color_scheme or "")
--     vim.o.background = bg
--     local vscode = require("vscode")
--     vscode.setup({
--       style = bg,
--       italic_comments = true,
--     })
--     vscode.load()
--   end,
-- }

local vscode_theme = {
  "projekt0n/github-nvim-theme",
  config = function()
    local bg = find_background(wezterm_color_scheme_ok and wezterm_color_scheme or "")
    vim.o.background = bg
    vim.cmd.colorscheme("github_" .. bg)
  end,
}

table.insert(M, vscode_theme)

local function change_scheme(args)
  local scheme = args.args
  local bg = find_background(scheme)
  vim.o.background = bg

  -- pcall(vim.cmd, "colorscheme " .. "github_" .. bg)
  vim.cmd.colorscheme("github_" .. bg)

  -- local vscode = require("vscode")
  -- vscode.setup({
  --   style = bg,
  -- })
  -- vscode.load()

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
