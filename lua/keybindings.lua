-- https://neovim.io/doc/user/usr_40.html#40.1

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- see https://neovim.io/doc/user/api.html#nvim_set_keymap()
local map = vim.api.nvim_set_keymap
local opt = { noremap = true, silent = true }

map("n", "<leader>l", ":nohlsearch<CR>", opt)
map("n", "<leader>w", ":w<CR>", opt)

-- map("n", "<leader>sv", ":vsp<CR>", opt)
-- map("n", "<leader>sh", ":sp<CR>", opt)
-- map("n", "<leader>sc", "<C-w>c", opt)
-- map("n", "<leader>so", "<C-w>o", opt)

-- Alt + hjkl jump between windows
map("n", "<A-h>", "<C-w>h", opt)
map("n", "<A-j>", "<C-w>j", opt)
map("n", "<A-k>", "<C-w>k", opt)
map("n", "<A-l>", "<C-w>l", opt)

-- indent line
map("v", "<", "<gv", opt)
map("v", ">", ">gv", opt)
-- move current line
-- map("v", "J", ":move '>+1<CR>gv=gv", opt)
-- map("v", "K", ":move '<-2<CR>gv=gv", opt)

map("n", "<C-j>", "4j", opt)
map("n", "<C-k>", "4k", opt)
map("n", "<C-u>", "9k", opt)
map("n", "<C-d>", "9j", opt)

-- yank to system clipborad
map("v", "<leader>y", '"+y', opt)
-- paste from system clipborad
map("n", "<leader>p", '"+p', opt)

-- in visual mode, not paste while yank
map("v", "p", '"_dP', opt)

-- jump to line start
map("n", "H", "^", opt)
-- delete to line end
map("n", "dH", "d^", opt)
-- yank to line end
map("n", "yH", "y^", opt)
-- jump to line end
map("n", "L", "$", opt)
-- delete to line end
map("n", "dL", "d$", opt)
-- yank to line end
map("n", "yL", "y$", opt)

-- bring you to your last change position
map("n", "<leader>b", "`.", opt)
