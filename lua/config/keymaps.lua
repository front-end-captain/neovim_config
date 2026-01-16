-- local Snacks = require('snacks')


local function map(mode, lhs, rhs, opts)
  -- local modes = type(mode) == "string" and { mode } or mode
  -- Snacks.keymap.set(modes, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
