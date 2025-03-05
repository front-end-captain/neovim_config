-- load <project_root>/.vscode/settings.lua
local local_config_loaded, local_config = pcall(require, "settings")
local utils = require("utils")

local M = {}
local setDiagnosticSigns = function()
  local signs = {
    { name = "DiagnosticSignError", text = utils.DiagnosticSign.error },
    { name = "DiagnosticSignWarn", text = utils.DiagnosticSign.warn },
    { name = "DiagnosticSignHint", text = utils.DiagnosticSign.hint },
    { name = "DiagnosticSignInfo", text = utils.DiagnosticSign.info },
  }
  vim.diagnostic.config({
    virtual_text = false,
    signs = { active = signs },
    update_in_insert = true,
    underline = { severity_sort = true },
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = true,
      header = "",
      prefix = "",
    },
  })

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end
end

local spec = {
  -- Collections os lsp client configs
  "neovim/nvim-lspconfig",
  -- lazy.nvim's custom events(https://github.com/folke/lazy.nvim#-user-events)
  -- and nvim builtin events(https://neovim.io/doc/user/autocmd.html#autocmd-events)
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    -- package manager for LSP servers, DAP servers, linters, and formatters.
    "williamboman/mason.nvim",
    -- bridges mason.nvim with the nvim-lspconfig
    "williamboman/mason-lspconfig",
    -- manage global and project-local settings.
    "folke/neoconf.nvim",
    -- full signature help, docs and completion for the nvim lua API
    "folke/neodev.nvim",
    -- provide a UI for nvim-lsp's progress handler.
    {
      "j-hui/fidget.nvim",
      tag = "legacy",
    },
    -- improve lsp experences in neovim
    "nvimdev/lspsaga.nvim",
    -- show function signature when you typing
    "ray-x/lsp_signature.nvim",
    --  improve your rust experience
    -- "simrat39/rust-tools.nvim",
    -- providing access to the SchemaStore catalog
    "b0o/schemastore.nvim",
  },
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local lsp_signature = require("lsp_signature")
    local telescope_builtin_pickers = require("telescope.builtin")
    local telescope_builtin_picker_opts = {
      initial_mode = "normal",
    }

    local on_attach = function(_, bufnr)
      local nmap = function(keys, func, desc)
        if desc then
          desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
      end

      nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
      nmap("gd", telescope_builtin_pickers.lsp_definitions, "[G]oto [D]efinition")
      nmap("gi", telescope_builtin_pickers.lsp_implementations, "[G]oto [I]mplementation")
      nmap("gr", telescope_builtin_pickers.lsp_references, "[G]oto [R]eferences")
      nmap("gh", "<cmd>Lspsaga hover_doc<CR>", "Hover Documentation")

      -- nmap("<leader>rn", "<cmd>Lspsaga rename ++project<cr>", "[R]e[n]ame")
      nmap("<leader>ca", "<cmd>Lspsaga code_action<CR>", "[C]ode [A]ction")
      nmap("<leader>da", vim.diagnostic.open_float, "[D]i[A]gnostics")
      nmap("<leader>O", "<cmd>Lspsaga outline<CR>", "[O]utline toggle")

      lsp_signature.on_attach({
        bind = true,
        handler_opts = {
          border = "rounded",
        },
      }, bufnr)
    end

    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
    local servers = {
      lua_ls = {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            format = {
              enable = false,
            },
          },
        },
      },
      pyright = {
        on_attach = on_attach,
        capabilities = capabilities,
      },
      gopls = {
        on_attach = on_attach,
        capabilities = capabilities,
      },
      rust_analyzer = {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
          ["rust-analyzer"] = {
            -- enable clippy on save
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      },
      jsonls = {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      },
      -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#eslint
      eslint = {
        capabilities = capabilities,
        settings = {
          nodePath = local_config_loaded and local_config.eslint.nodePath or "node_modules",
        },
      },
      ts_ls = {
        on_attach = on_attach,
        capabilities = capabilities,
        -- settings = {
        --   maxTsServerMemory = 10240,
        -- },
        -- flags = {
        --   debounce_text_changes = 150,
        -- },
        init_options = {
          hostInfo = "neovim",
          preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      },
      cssls = {
        on_attach = on_attach,
        capabilities = capabilities,
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
    }

    require("neoconf").setup()
    require("neodev").setup()
    require("lspsaga").setup()
    require("mason").setup()

    require("mason-lspconfig").setup({
      ensure_installed = vim.tbl_keys(servers),
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup(servers[server_name] or {})
        end,
      },
    })
    setDiagnosticSigns()
  end,
}


table.insert(M, spec)
return M
