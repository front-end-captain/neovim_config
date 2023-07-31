local M = {}
local null_ls = {
  "jose-elias-alvarez/null-ls.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "jay-babu/mason-null-ls.nvim",
  },
  config = function()
    local tools = {
      "black",
      "shfmt",
      "stylua",
      "prettier",
      "cspell",
    }
    local mason_null_ls = require("mason-null-ls")
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting
    -- local code_actions = null_ls.builtins.code_actions
    mason_null_ls.setup({
      ensure_installed = nil,
      automatic_installation = true,
      -- handlers = {},
    })
    null_ls.setup({
      sources = {
        formatting.shfmt,
        formatting.stylua,
        formatting.prettier.with({
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "css",
            "scss",
            "less",
            "html",
            "json",
            "jsonc",
            "yaml",
            "graphql",
          },
          prefer_local = "node_modules/.bin",
        }),
        -- npm i --location=global cspell http://cspell.org/
        null_ls.builtins.diagnostics.cspell.with({
          -- log_level = "info",
          diagnostic_config = {
            -- see :help vim.diagnostic.config()
            underline = false,
            virtual_text = false,
            signs = true,
            update_in_insert = true,
            severity_sort = false,
          },
          -- fallback_severity = vim.diagnostic.severity["HINT"],
          diagnostics_format = "[spell][#{m}",
          diagnostics_postprocess = function(diagnostic)
            diagnostic.severity = vim.diagnostic.severity["HINT"]
          end,
        }),
        -- code_actions.eslint,
        -- code_actions.cspell,
      },
      diagnostics_format = "[#{s}] #{m}]",
    })
  end,
}
table.insert(M, null_ls)
return M
