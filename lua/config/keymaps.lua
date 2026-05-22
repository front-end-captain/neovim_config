-- local Snacks = require('snacks')

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local function map(mode, lhs, rhs, opts)
  -- local modes = type(mode) == "string" and { mode } or mode
  -- Snacks.keymap.set(modes, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

map("v", "<leader>y", '"+y', { noremap = true, silent = true, desc = "Yank to system clipborad" })
map("n", "<leader>p", '"+p', { noremap = true, silent = true, desc = "Paste to system clipborad" })

-- 在 Visual 模式下，按 p 或 P 粘贴时，自动将被覆盖的内容扔进黑洞寄存器
-- map("v", "p", '"_dP', { noremap = true, silent = true })

map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map("n", "<C-j>", "4j", { noremap = true, silent = true })
map("n", "<C-k>", "4k", { noremap = true, silent = true })
map("n", "<C-u>", "9k", { noremap = true, silent = true })
map("n", "<C-d>", "9j", { noremap = true, silent = true })

map("n", "H", "^", { noremap = true, silent = true, desc = "Jump to line start" })
map("n", "dH", "d^", { noremap = true, silent = true, desc = "Delete to line end" })
map("n", "yH", "y^", { noremap = true, silent = true, desc = "Yank to line end" })
map("n", "L", "$", { noremap = true, silent = true, desc = "Jump to line end" })
map("n", "dL", "d$", { noremap = true, silent = true, desc = "Delete to line end" })
map("n", "yL", "y$", { noremap = true, silent = true, desc = "Yank to line end" })

-- Alt + hjkl jump between windows
map("n", "<A-h>", "<C-w>h", { desc = "Goto Left Window", remap = true })
map("n", "<A-j>", "<C-w>j", { desc = "Goto Lower Window", remap = true })
map("n", "<A-k>", "<C-w>k", { desc = "Goto Upper Window", remap = true })
map("n", "<A-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

map({ "n", "x" }, "<leader>l", "<cmd>nohlsearch<CR>", { desc = "Clear search" })

map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })


-- 双击 Esc 进入终端的normal模式
-- map("t", "<Esc><Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
