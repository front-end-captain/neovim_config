local M = {}

local null_ls = {
  "jose-elias-alvarez/null-ls.nvim",
  event = { "BufReadPost", "BufNewFile", "BufWritePre", "BufWritePost" },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        -- npm i -g cspell # http://cspell.org/
        null_ls.builtins.diagnostics.cspell.with({
          -- log_level = "info",
          diagnostic_config = {
            -- see :help vim.diagnostic.config()
            underline = false,
            -- underline = { severity_sort = true },
            virtual_text = false,
            signs = true,
            update_in_insert = true,
            severity_sort = false,
          },
          diagnostics_postprocess = function(diagnostic)
            diagnostic.severity = vim.diagnostic.severity["HINT"]
          end,
        }),
      },
      diagnostics_format = "[#{s}] #{m}]",
    })
  end,
}

table.insert(M, null_ls)

-- vim.cmd([[hi def DiagnosticHint guisp=red gui=undercurl term=underline cterm=undercurl]])
-- vim.cmd([[hi def DiagnosticUnderlineError guisp=Red gui=undercurl]])
-- vim.cmd.highlight("highlight-name gui=undercurl")

return M
