local M = {}

local none_ls = {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPost", "BufNewFile", "BufWritePre", "BufWritePost" },
  dependencies = { "davidmh/cspell.nvim" },
  opts = function(_, opts)
    local cspell = require("cspell")
    opts.sources = opts.sources or {}
    table.insert(
      opts.sources,
      cspell.diagnostics.with({
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
          diagnostic.severity = vim.diagnostic.severity.HINT
        end,
      })
    )
    table.insert(opts.sources, cspell.code_actions)
  end,
}

table.insert(M, none_ls)

-- vim.cmd([[hi def DiagnosticHint guisp=red gui=undercurl term=underline cterm=undercurl]])
-- vim.cmd([[hi def DiagnosticUnderlineError guisp=Red gui=undercurl]])
-- vim.cmd.highlight("highlight-name gui=undercurl")

return M
