local M = {}
vim.g.transparent_enabled = true
local spec = {
  "xiyaowong/nvim-transparent",
  config = function()
    require("transparent").setup({
      extra_groups = {
        "BufferLineFill",
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
