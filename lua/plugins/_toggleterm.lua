local os = require("os")

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
      shell = os.getenv("OS") == "Windows_NT" and "pwsh" or vim.o.shell,
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
vim.api.nvim_set_keymap(
  "n",
  "<leader>N",
  ":TermNew<CR>",
  { noremap = true, silent = true }
)

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

return M
