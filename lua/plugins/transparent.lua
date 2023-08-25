local M = {}
vim.g.transparent_enabled = true
local spec = {
  "xiyaowong/nvim-transparent",
  config = function()
    require("transparent").setup({
      extra_groups = {
        "BufferLineFill",
        "NvimTreeNormal",
        "NvimTreeStatuslineNc",
      },
    })
  end,
}
table.insert(M, spec)

return M
