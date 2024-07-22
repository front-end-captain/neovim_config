local M = {}

local function open_dashboard(data)
  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  vim.cmd("Dashboard");
end

-- BufEnter
-- vim.api.nvim_create_autocmd({ "BufEnter" }, { callback = open_dashboard })

local spec = {
  "glepnir/dashboard-nvim",
  dependencies = { { "nvim-tree/nvim-web-devicons" } },
  event = "VimEnter",
  config = function()
    require("dashboard").setup({
      theme = "hyper",
      config = {
        week_header = {
          enable = true,
        },
        shortcut = {},
      },
    })
  end,
}

table.insert(M, spec)

return M
