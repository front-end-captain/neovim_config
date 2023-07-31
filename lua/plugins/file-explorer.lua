local M = {}

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

local function open_nvim_tree(data)
  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- change to the directory
  vim.cmd.cd(data.file)

  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

local function on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts("Toggle"))
  vim.api.nvim_set_keymap("n", "<leader>d", ":NvimTreeFocus<CR>", opts("Focus"))
  vim.api.nvim_set_keymap("n", "<leader>H", ":NvimTreeResize +10<CR>", opts("+Size"))
  vim.api.nvim_set_keymap("n", "<leader>L", ":NvimTreeResize -10<CR>", opts("-Size"))
end

local spec = {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      on_attach = on_attach,
      git = {
        enable = true,
        ignore = false,
      },
      update_cwd = true,
      update_focused_file = {
        enable = true,
        update_cwd = true,
      },
      -- which dir will hide
      filters = {
        dotfiles = false,
        custom = { ".idea" },
      },
      view = {
        width = 50,
        side = "right",
        hide_root_folder = false,
        number = true,
        relativenumber = true,
        signcolumn = "yes",
      },
      notify = {
        threshold = vim.log.levels.ERROR,
        absolute_path = true,
      },
      -- log = {
      -- enable = true,
      -- truncate = true,
      -- types = {
      -- all = false,
      -- config = true,
      -- copy_paste = false,
      -- dev = false,
      -- diagnostics = false,
      -- git = false,
      -- profile = false,
      -- watcher = false,
      -- },
      -- },
    })
  end,
}
table.insert(M, spec)

return M
