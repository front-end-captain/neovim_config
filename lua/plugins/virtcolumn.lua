local M = {}

vim.wo.signcolumn = "yes"
vim.opt.colorcolumn = "100,120"
vim.g.virtcolumn_char = "'"
vim.g.virtcolumn_priority = 10

local spec = {
  "xiyaowong/virtcolumn.nvim",
}
table.insert(M, spec)

return M
