local M = {}

local spec = {
  "xiyaowong/virtcolumn.nvim",
  enabled = false,
  init = function()
    vim.wo.signcolumn = "yes"
    vim.opt.colorcolumn = "100,120"
    vim.g.virtcolumn_char = "'"
    -- vim.g.virtcolumn_char = '▕'
    vim.g.virtcolumn_priority = 10
  end,
}
table.insert(M, spec)

return M
