local utils = require("help")

local NVIM_APPNAME = os.getenv("NVIM_APPNAME") or 'nvim'

local DEFAULT_BACKGROUND = "dark"
local DEFAULT_NVIM_COLOR_SCHEME = "tokyonight"

local wezterm_color_scheme_path = utils.get_host_os_home()
  .. utils.path_separator
  .. table.concat({ ".config", "wezterm", "wezterm_color_scheme.lua" }, utils.path_separator)

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

local function extract_color_scheme_names(colorschemes)
  local names = {}

  for _, item in ipairs(colorschemes) do
    if type(item) == "table" and item.name then
      table.insert(names, item.name)
    end
  end

  return names
end

local M = {
  { "folke/tokyonight.nvim" },
  { "sainnhe/gruvbox-material" },
  { "catppuccin/nvim" },
  { "nyoom-engineering/oxocarbon.nvim" },
  { "marko-cerovac/material.nvim" },
}

local colorschemes = {
  {
    name = "tokyonight",
    callback = function(theme)
      ---@diagnostic disable-next-line: missing-fields
      require("tokyonight").setup({ transparent = vim.g.transparent_enabled })
    end,
  },
  {
    name = "gruvbox-material",
    callback = function()
      vim.g.gruvbox_material_foreground = "mix" -- material mix original
      vim.g.gruvbox_material_background = "soft"
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_transparent_background = 2
    end,
  },
  {
    name = "catppuccin",
    callback = function()
      require("catppuccin").setup({
        transparent_background = vim.g.transparent_enabled,
        integrations = { blink_cmp = true },
      })
    end,
  },
  {
    name = "oxocarbon",
  },
  {
    name = "material",
    callback = function(theme)
      if theme == "light" then
        vim.g.material_style = "lighter"
      else
        -- darker oceanic palenight
        vim.g.material_style = "darker"
      end
    end,
  },
}

local function find_callback_by_name(schemes, target_name)
  for _, item in ipairs(schemes) do
    if item.name == target_name then
      return item.callback
    end
  end

  return nil
end

local nvim_color_scheme_filename = "color_scheme"
local nvim_color_scheme_path = os.getenv("HOME")
  .. utils.path_separator
  .. table.concat(
    { ".config", NVIM_APPNAME, "lua", nvim_color_scheme_filename .. ".lua" },
    utils.path_separator
  )

local function setup_color_scheme(args)
  local theme = args.args

  local callback = find_callback_by_name(colorschemes, theme)
  if callback then
    callback(vim.o.background)
  end

  vim.cmd.colorscheme(theme)

  local file, errMsg = io.open(nvim_color_scheme_path, "w")
  if errMsg then
    print(errMsg)
  end
  if file then
    file:write("return '" .. theme .. "'")
    file:close()
  end
end

local function change_wezterm_scheme(args)
  local scheme = args.args

  local bg = find_background(scheme)
  vim.o.background = bg

  local file = io.open(wezterm_color_scheme_path, "w")
  if file then
    file:write("return '" .. scheme .. "'")
    file:close()
  end
end

vim.api.nvim_create_user_command("SwitchWeztermColor", change_wezterm_scheme, {
  nargs = 1,
  complete = function()
    return wezterm_color_scheme_names
  end,
})
vim.api.nvim_create_user_command("ColorScheme", setup_color_scheme, {
  nargs = 1,
  complete = function()
    local names = extract_color_scheme_names(colorschemes)
    return names
  end,
})

local wezterm_color_scheme_ok, wezterm_color_scheme = pcall(require, "wezterm_color_scheme")
local nvim_color_scheme_ok, nvim_color_scheme = pcall(require, nvim_color_scheme_filename)

vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  -- group = "",
  callback = function()
    -- print(wezterm_color_scheme)
    -- print(nvim_color_scheme)

    if wezterm_color_scheme_ok then
      local bg = find_background(wezterm_color_scheme)
      vim.o.background = bg
    end

    if nvim_color_scheme_ok then
      local callback = find_callback_by_name(colorschemes, nvim_color_scheme)
      if callback then
        callback(vim.o.background)
      end
    end

    vim.cmd.colorscheme(nvim_color_scheme_ok and nvim_color_scheme or DEFAULT_NVIM_COLOR_SCHEME)
  end,
})

return M
