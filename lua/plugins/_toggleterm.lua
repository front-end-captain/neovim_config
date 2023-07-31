local M = {}
local spec = {
  "akinsho/toggleterm.nvim",
  event = "VeryLazy",
  config = function()
    require("toggleterm").setup({
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<c-\>]],
      insert_mappings = true,
      terminal_mappings = true,
      hide_numbers = true,
      start_in_insert = true,
    })
  end,
}
table.insert(M, spec)
vim.api.nvim_set_keymap("n", "<leader>t", ":ToggleTerm<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
  "n",
  "<leader>T",
  ":ToggleTerm direction=vertical<CR>",
  { noremap = true, silent = true }
)
return M
