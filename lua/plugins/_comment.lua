local M = {}

local spec = {
  "numToStr/Comment.nvim",
  event = "VeryLazy",
  dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
  config = function()
    require("ts_context_commentstring").setup({
      padding = true,
      sticky = true,
      ignore = nil,
      toggler = {
        line = "cc",
        block = "gbc",
      },
      opleader = {
        line = "gc",
        block = "gb",
      },
      extra = {
        above = "gcO",
        below = "gco",
        eol = "gcA",
      },
      mappings = {
        basic = true,
        extra = true,
        extended = false,
      },
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      post_hook = nil,
    })
  end,
}

table.insert(M, spec)

vim.g.skip_ts_context_commentstring_module = true

return M
