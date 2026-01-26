local help = require("help")
local telescope_builtin = require("telescope.builtin")

local ensure_installed = {}

local public_keys = {
  { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
  {
    "gd",
    -- vim.lsp.buf.definition,
    telescope_builtin.lsp_definitions,
    desc = "Goto Definition",
    has = "definition",
  },
  { "gi", vim.lsp.buf.implementation, desc = "Goto Implementation" },
  { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
  {
    "gh",
    function()
      return vim.lsp.buf.hover()
    end,
    desc = "Hover Doc",
  },
  {
    "<leader>ca",
    vim.lsp.buf.code_action,
    desc = "Code Action",
    mode = { "n", "x" },
    has = "codeAction",
  },
  {
    "<leader>da",
    vim.diagnostic.open_float,
    desc = "Diagnostic",
    mode = { "n", "x" },
    has = "codeAction",
  },
}

return {
  { import = "plugins.lsp.lang.lua" },
  { import = "plugins.lsp.lang.typescript" },
  { import = "plugins.lsp.lang.json" },

  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" }, -- LazyFile
    dependencies = {
      "mason.nvim",
      { "mason-org/mason-lspconfig.nvim", config = function() end },
    },
    opts_extend = { "servers" },
    opts = function(_, opts)
      return vim.list_extend(opts, {})
    end,
    config = vim.schedule_wrap(function(_, opts)
      -- setup keymaps
      require("plugins.lsp.keymaps").set({ name = nil }, public_keys)

      -- local Snacks = require("snacks")
      -- Enable this to enable the builtin LSP code lenses on Neovim.
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the code lenses.
      -- Snacks.util.lsp.on({ method = "textDocument/codeLens" }, function(buffer)
      --   vim.lsp.codelens.refresh()
      --   vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      --     buffer = buffer,
      --     callback = vim.lsp.codelens.refresh,
      --   })
      -- end)

      vim.diagnostic.config({
        underline = true,
        update_in_insert = true,
        virtual_text = false,
        -- virtual_text = {
        --   spacing = 4,
        --   source = "if_many",
        --   prefix = function(diagnostic)
        --     for d, icon in pairs(help.Diagnostic_Icon) do
        --       if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
        --         return icon
        --       end
        --     end
        --     return "●"
        --   end,
        -- },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = help.Diagnostic_Icon.error,
            [vim.diagnostic.severity.WARN] = help.Diagnostic_Icon.warn,
            [vim.diagnostic.severity.HINT] = help.Diagnostic_Icon.hint,
            [vim.diagnostic.severity.INFO] = help.Diagnostic_Icon.info,
          },
        },
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = true,
          header = "",
          prefix = "",
        },
      })

      -- set capabilities
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      opts.servers["*"] = vim.tbl_deep_extend("force", {}, {
        capabilities = capabilities,
      })

      ---@return boolean? exclude automatic setup
      local function configure(server)
        if server == "*" then
          return false
        end

        local sopts = opts.servers[server]
        sopts = sopts == true and {} or (not sopts) and { enabled = false } or sopts --[[@as lazyvim.lsp.Config]]

        vim.lsp.config(server, sopts)
        vim.lsp.enable(server)
        return true
      end

      ensure_installed = vim.tbl_filter(configure, vim.tbl_keys(opts.servers))
      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
        automatic_enable = true,
      })

      require("plugins/lsp/progress")
    end),
  },

  -- cmdline tools and lsp servers
  {

    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = ensure_installed,
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
}
