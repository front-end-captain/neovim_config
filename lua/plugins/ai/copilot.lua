return {
  -- copilot
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   build = ":Copilot auth",
  --   event = "BufReadPost",
  --   requires = {
  --     "copilotlsp-nvim/copilot-lsp",
  --     init = function()
  --       vim.g.copilot_nes_debounce = 500
  --     end,
  --   },
  --   opts = {
  --     suggestion = {
  --       enabled = true,
  --       auto_trigger = true,
  --       hide_during_completion = true,
  --       keymap = {
  --         accept = false, -- handled by blink.cmp
  --         next = "<M-]>",
  --         prev = "<M-[>",
  --       },
  --     },
  --     panel = { enabled = false },
  --     filetypes = {
  --       javascript = true,
  --       ["*"] = false,
  --     },
  --   },
  -- },
  -- {
  --   "saghen/blink.cmp",
  --   optional = true,
  --   dependencies = { "fang2hou/blink-copilot" },
  --   opts = {
  --     sources = {
  --       default = { "copilot" },
  --       providers = {
  --         copilot = {
  --           name = "copilot",
  --           module = "blink-copilot",
  --           score_offset = 100,
  --           async = true,
  --         },
  --       },
  --     },
  --   },
  -- },

  -- copilot-language-server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        copilot = {
          keys = {
            {
              "<M-]>",
              function()
                vim.lsp.inline_completion.select({ count = 1 })
              end,
              desc = "Next Copilot Suggestion",
              mode = { "i", "n" },
            },
            {
              "<M-[>",
              function()
                vim.lsp.inline_completion.select({ count = -1 })
              end,
              desc = "Prev Copilot Suggestion",
              mode = { "i", "n" },
            },
          },
        },
      },
      setup = {
        copilot = function()
          vim.schedule(function()
            vim.lsp.inline_completion.enable()
          end)
          -- Accept inline suggestions or next edits
          -- LazyVim.cmp.actions.ai_accept = function()
          --   return vim.lsp.inline_completion.get()
          -- end

          vim.lsp.config("copilot", {
            handlers = {
              didChangeStatus = function(err, res, ctx)
                if err then
                  return
                end
                if res.status == "Error" then
                  Snacks.notifier("Please use `:LspCopilotSignIn` to sign in to Copilot")
                end
              end,
            },
          })
        end,
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "copilot" } },
  },
}
