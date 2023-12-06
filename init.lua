local HOME = os.getenv("HOME")
local wezterm_config_root = HOME .. "/.config/wezterm/?.lua"
-- so we can require lua files in folder '~/.config/wezterm'
package.path = package.path .. ";" .. wezterm_config_root

vim.loader.enable()

require("options")
require("keybindings")
require("setup")
