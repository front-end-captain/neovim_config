local M = {}

-- https://github.com/charmbracelet/glow

local spec = {
  "ellisonleao/glow.nvim",
  cmd = "Glow",
  event = "VeryLazy",
  config = function()
    require("glow").setup({
      -- your override config
      -- glow_path = "", -- will be filled automatically with your glow bin in $PATH, if any
      -- install_path = "~/.local/bin", -- default path for installing glow binary
      border = "shadow", -- floating window border config
      style = "dark", -- filled automatically with your current editor background, you can override using glow json style
      pager = false,
      -- width = 80,
      -- height = 100,
      width_ratio = 0.9, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
      height_ratio = 0.8,
    })
  end,
}

table.insert(M, spec)

return M
