local M = {}
local spec = {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- opts = { require 'alpha'.setup(require 'alpha.themes.dashboard'.config) }
  opts = { require("alpha.themes.startify").config },
}
table.insert(M, spec)
return M
