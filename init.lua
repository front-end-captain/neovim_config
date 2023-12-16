local os = require('os')

local function getHOME ()
  local os_name = os.getenv("OS")
  if os_name == 'Windows_NT' then
    return os.getenv('HOMEDRIVE') .. os.getenv('HOMEPATH')
  end

  if os_name == "Darwin" then
    return os.getenv("HOME")
  end
end

local path_separator = package.config:sub(1,1)

local HOME = getHOME()
local wezterm_config_root = HOME .. path_separator .. table.concat({'.config', 'wezterm', '?.lua'}, path_separator)
-- so we can require lua files in folder '~/.config/wezterm'
package.path = package.path .. ";" .. wezterm_config_root
-- print(package.path)

vim.loader.enable()

require("options")
require("keybindings")
require("setup")
