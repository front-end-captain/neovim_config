return {
  -- Treesitter is a new parser generator tool that we can
  -- use in Neovim to power faster and more accurate
  -- syntax highlighting.
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- main = "nvim-treesitter.configs",
    branch = "main",
    version = false,
    event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
    -- cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
    -- opts_extend = { "ensure_installed" },
    ---@alias lazyvim.TSFeat { enable?: boolean, disable?: string[] }
    ---@class lazyvim.TSConfig: TSConfig
    opts = {
      indent = { enable = true },
      highlight = { enable = true },
      folds = { enable = true },
      ensure_installed = {
        "html",
        "css",
        "vim",
        "lua",
        "javascript",
        "typescript",
        "tsx",
        "rust",
        "markdown",
        "markdown_inline",
        "json5",
        "hurl",
        "bash",
        "regex",
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
          },
          include_surrounding_whitespace = false,
        },
      },
    },
    -- -@param opts lazyvim.TSConfig
    config = function(_, opts)
      local ts = require("nvim-treesitter")
      ts.setup(opts)

      local installed = ts.get_installed("parsers")
      local missing = vim.tbl_filter(function(lang)
        return not vim.tbl_contains(installed, lang)
      end, opts.ensure_installed)

      if #missing > 0 then
        ts.install(missing)
      end
    end,
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "VeryLazy",
    config = function()
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
      })
      -- For neovim native comment
      local get_option = vim.filetype.get_option
      vim.filetype.get_option = function(filetype, option)
        return option == "commentstring"
            and require("ts_context_commentstring.internal").calculate_commentstring()
          or get_option(filetype, option)
      end
    end,
  },

  -- Automatically add closing tags for HTML and JSX
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {},
  },

  -- Show context of the current function
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" }, -- LazyFile
    opts = {
      mode = "cursor",
      max_lines = 3,
    },
  },
}
