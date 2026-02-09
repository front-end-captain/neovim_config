return {
  -- add json to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "css" } },
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = {
          flags = {
            debounce_text_changes = 150,
          },
          settings = {
            css = {
              validate = true,
            },
            less = {
              validate = true,
            },
            scss = {
              validate = true,
            },
          },
        },
      },
    },
  },
}
