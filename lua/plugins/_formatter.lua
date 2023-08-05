local M = {}
local formatter_config = {
  "mhartington/formatter.nvim",
  event = "VeryLazy",
  config = function()
    local util = require("formatter.util")
    local defaults = require("formatter.defaults")

    require("formatter").setup({
      logging = true,
      log_level = vim.log.levels.WARN,
      filetype = {
        lua = {
          require("formatter.filetypes.lua").stylua,
        },
        ["javascript"] = {
          require("formatter.filetypes.javascript").prettier,
        },
        ["javascriptreact"] = {
          require("formatter.filetypes.javascriptreact").prettier,
        },
        ["typescript"] = {
          require("formatter.filetypes.typescript").prettier,
        },
        ["typescriptreact"] = {
          require("formatter.filetypes.typescriptreact").prettier,
        },
        ["css"] = {
          require("formatter.filetypes.css").prettier,
        },
        ["less"] = {
          prettier = util.withl(defaults.prettier, "less"),
        },
        ["scss"] = {
          prettier = util.withl(defaults.prettier, "scss"),
        },
        ["json"] = {
          require("formatter.filetypes.json").prettier,
        },
        ["jsonc"] = {
          prettier = util.withl(defaults.prettier, "jsonc"),
        },
        ["html"] = {
          require("formatter.filetypes.html").prettier,
        },
        ["yaml"] = {
          require("formatter.filetypes.yaml").prettier,
        },
        ["sh"] = {
          require("formatter.filetypes.sh").prettier,
        },
        ["python"] = {
          -- pip install black
          require("formatter.filetypes.python").black,
        },
      },
    })
    vim.api.nvim_set_keymap(
      "n",
      "<leader>f",
      ":Format<CR>",
      { noremap = true, silent = true, desc = "Format code" }
    )
    vim.api.nvim_set_keymap(
      "n",
      "<leader>F",
      ":FormatWrite<CR>",
      { noremap = true, silent = true, desc = "Format code" }
    )
  end,
}
table.insert(M, formatter_config)
return M
