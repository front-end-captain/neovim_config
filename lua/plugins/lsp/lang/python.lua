return {
  -- add python to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "python" } },
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {},
      },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "pyright", "black" } },
  },
}
