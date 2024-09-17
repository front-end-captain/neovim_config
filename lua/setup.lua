local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local utils = require('utils')

utils.add_package_path()

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- see https://github.com/folke/lazy.nvim#%EF%B8%8F-configuration
local options = {
  install = {
    colorscheme = { "gruvbox-baby" },
  },
}

require("lazy").setup("plugins", options)

vim.loader.enable()

local nvim = vim.version() ~= nil
local nvr_executable = vim.fn.executable("nvr") == 1

if nvim and nvr_executable then
  vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
end
