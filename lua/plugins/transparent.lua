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
      exclude_groups = {
        "CursorLine",
        "CursorLineNr",
        "NeoTreeCursorLine",
      },
    })
  end,
}
table.insert(M, spec)

return M
