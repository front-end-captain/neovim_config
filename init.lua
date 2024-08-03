local os = require("os")

local function getHostOSHOME()
  local os_name = os.getenv("OS")
  local wsl_distro_name = os.getenv("WSL_DISTRO_NAME") or ""
  local is_wsl_ubuntu = string.find(wsl_distro_name, "Ubuntu")

  if is_wsl_ubuntu then
    return os.getenv("WINDOWS_HOME") or ""
  end

  if os_name == "Windows_NT" then
    return os.getenv("HOMEDRIVE") .. os.getenv("HOMEPATH")
  end

  return os.getenv("HOME")
end

local path_separator = package.config:sub(1, 1)

local wezterm_config_root = getHostOSHOME()
  .. path_separator
  .. table.concat({ ".config", "wezterm", "?.lua" }, path_separator)

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
