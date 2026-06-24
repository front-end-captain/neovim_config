local help = require("help")

help.add_package_path()

local M = {}

function M.setup()
  require("config.autocmds")
  require("config.keymaps")

  require("config.options")
  require("config.lazy")
end

return M
