local function sort_pkg_json()
  -- local notify = require("notify")
  local notify = vim.notify

  local filename = vim.fs.basename(vim.api.nvim_buf_get_name(0))
  if filename ~= "package.json" then
    notify("current buffer is not package.json: ", vim.log.levels.WARN, { title = "SortPkgJson" })
    return
  end

  if vim.bo.modified then
    notify("current buffer not saved", vim.log.levels.WARN, { title = "SortPkgJson" })
    return
  end

  local fname = vim.fn.expand("%:p")
  local handle = io.popen("sort-package-json " .. vim.fn.shellescape(fname))
  if not handle then
    notify("call sort-package-json failed", vim.log.levels.ERROR, { title = "SortPkgJson" })
    return
  end

  local output = handle:read("*a")
  handle:close()

  if vim.v.shell_error == 0 then
    vim.cmd("edit!")
    notify("package.json sorted", vim.log.levels.INFO, { title = "SortPkgJson" })
  else
    notify("sort-package-json failed: " .. output, vim.log.levels.ERROR, { title = "SortPkgJson" })
  end
end

vim.api.nvim_create_user_command("SortPkgJson", sort_pkg_json, {})

local supported = {
  "css",
  "graphql",
  "handlebars",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "less",
  "markdown",
  "markdown.mdx",
  "scss",
  "typescript",
  "typescriptreact",
  "vue",
  "yaml",
}

return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ timeout_ms = 3000 }, function(err)
            if err ~= nil then
              vim.notify(err, vim.log.levels.ERROR)
              return
            end
            vim.notify("Formatted", vim.log.levels.INFO)
          end)
        end,
        mode = { "n", "x" },
        desc = "Format Code",
      },
    },
    opts = function()
      ---@type conform.setupOpts
      local opts = {
        default_format_opts = {
          timeout_ms = 3000,
          async = false,
          quiet = false,
          lsp_format = "fallback",
        },
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "black" },
          sh = { "shfmt" },
        },
      }

      for _, ft in ipairs(supported) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], "prettier")
      end

      return opts
    end,
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },

  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "prettier" } },
  },
}
