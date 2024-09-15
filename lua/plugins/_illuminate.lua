local M = {}

local spec = {
  "RRethy/vim-illuminate",
  event = "VeryLazy",
  config = function()
    require("illuminate").configure({
      -- providers: provider used to get references in the buffer, ordered by priority
      providers = {
        -- "lsp",
        "treesitter",
      },
      -- delay: delay in milliseconds
      delay = 100,
      -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
      filetypes_denylist = {
        "aerial",
        "notify",
      },
      -- modes_allowlist: modes to illuminate, this is overriden by modes_denylist
      -- See `:help mode()` for possible values
      modes_allowlist = { "n" },
    })
  end,
}
table.insert(M, spec)

vim.cmd([[hi def IlluminatedWordText cterm=bold gui=bold]])
vim.cmd([[hi def IlluminatedWordRead cterm=bold gui=bold]])
vim.cmd([[hi def IlluminatedWordWrite cterm=bold gui=bold]])

return M
