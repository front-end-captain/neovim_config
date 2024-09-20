local M = {}

local spec = {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim", -- required by telescope
    "MunifTanjim/nui.nvim",

    -- optional
    "nvim-treesitter/nvim-treesitter",
    "rcarriga/nvim-notify",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    lang = "javascript",
    cn = {
      enabled = true,
      translator = true,
      translate_problems = true,
    },
  },
}
table.insert(M, spec)

-- vim.api.nvim_set_keymap("n", "<leader>r", ":Leet run<CR>", { noremap = true, silent = true })

return M
