local M = {}

-- https://github.com/charmbracelet/glow

local spec = {
  "ThePrimeagen/harpoon",
  -- event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")

    harpoon.setup({
      tabline = false,
    })

    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")

    vim.keymap.set("n", "<leader>a", function() mark.add_file() end)
    vim.keymap.set("n", "<leader>c", function() mark.clear_all() end)
    vim.keymap.set("n", "<leader>m", function() ui.toggle_quick_menu() end)
  end,
}

table.insert(M, spec)

return M
