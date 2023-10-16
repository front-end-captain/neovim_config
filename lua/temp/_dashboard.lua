local M = {}

-- local custom_header = {
--   [[]],
--   [[███╗   ██╗███████╗██╗  ██╗███████╗███╗   ██╗]],
--   [[████╗  ██║██╔════╝██║  ██║██╔════╝████╗  ██║]],
--   [[██╔██╗ ██║███████╗███████║█████╗  ██╔██╗ ██║]],
--   [[██║╚██╗██║╚════██║██╔══██║██╔══╝  ██║╚██╗██║]],
--   [[██║ ╚████║███████║██║  ██║███████╗██║ ╚████║]],
--   [[╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝]],
-- }

local spec = {
  "glepnir/dashboard-nvim",
  event = "VimEnter",
  dependencies = { { "nvim-tree/nvim-web-devicons" } },
  config = function()
    local dashboard = require("dashboard").setup({
      theme = "hyper",
    })
    -- dashboard.custom_header = custom_header
  end,
}

table.insert(M, spec)

return M
