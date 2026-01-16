return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {},
    config = function(_, opts)
      require("snacks").setup(opts)
    end,
  },
  { "MunifTanjim/nui.nvim", lazy = true }, -- move to lua/plugins/ui.lua
  { "nvim-lua/plenary.nvim", lazy = true }, -- move to lua/plugins/util.lua
  { "nvim-tree/nvim-web-devicons", lazy = true }, -- move to lua/plugins/ui.lua
}
