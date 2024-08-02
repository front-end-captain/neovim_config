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
local wezterm_config_root = ""
if string.find(os.getenv("WSL_DISTRO_NAME"), "Ubuntu") then
  wezterm_config_root = os.getenv("WINDOWS_HOME")
    .. path_separator
    .. table.concat({ ".config", "wezterm", "?.lua" }, path_separator)
else
  wezterm_config_root = HOME
    .. path_separator
    .. table.concat({ ".config", "wezterm", "?.lua" }, path_separator)
end

-- so we can require lua files in folder '~/.config/wezterm'
package.path = package.path
  .. ";"
  .. wezterm_config_root
  .. ";"
  .. vim.fn.getcwd()
  .. "/.vscode/?.lua"
-- print(package.path)

vim.loader.enable()

require("options")
require("keybindings")
require("setup")
