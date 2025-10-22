local M = {}
local formatter_config = {
  "mhartington/formatter.nvim",
  event = "VeryLazy",
  config = function()
    local util = require("formatter.util")
    local defaults = require("formatter.defaults")

    require("formatter").setup({
      -- logging = true,
      -- log_level = vim.log.levels.INFO,
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
          util.withl(defaults.prettier, "less"),
        },
        ["scss"] = {
          util.withl(defaults.prettier, "scss"),
        },
        ["json"] = {
          require("formatter.filetypes.json").prettier,
        },
        ["jsonc"] = {
          util.withl(defaults.prettier, "jsonc"),
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
        ["rust"] = {
          require("formatter.filetypes.rust").rustfmt,
        },
        ["go"] = {
          -- go install mvdan.cc/gofumpt@latest
          -- https://github.com/mvdan/gofumpt
          require("formatter.filetypes.go").gofmt,
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
      { noremap = true, silent = true, desc = "Format and Write code" }
    )
  end,
}
local function sort_pkg_json()
  local notify = require("notify")

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

table.insert(M, formatter_config)
return M
