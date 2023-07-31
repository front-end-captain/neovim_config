local M = {}
local spec = {
  "stevearc/aerial.nvim",
  event = "VeryLazy",
  config = function()
    local aerial = require("aerial")
    aerial.setup({
      backends = { "treesitter", "lsp" },
      layout = {
        max_width = { 40, 0.2 },
        min_width = { 40, 0.2 },
        default_direction = "prefer_right",
        placement = "window",
      },

      on_attach = function(bufnr)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>o", "<cmd>AerialToggle!<CR>", {})
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<A-k>", "<cmd>AerialPrev<CR>", {})
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<A-j>", "<cmd>AerialNext<CR>", {})
      end,
    })
  end,
}

table.insert(M, spec)

return M
