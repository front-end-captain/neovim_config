local M = {}
local spec = {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
    },
  },

  version = "1.*",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = "enter" },

    appearance = {
      nerd_font_variant = "mono",
    },

    completion = {
      documentation = { auto_show = false },
      accept = {
        auto_brackets = {
          enabled = false,
        },
      },
    },

    -- snippets = { preset = "luasnip" },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },

    cmdline = {
      keymap = { preset = "cmdline" },
      completion = { menu = { auto_show = false } },
    },
  },
  opts_extend = { "sources.default" },
}

table.insert(M, spec)

return M
