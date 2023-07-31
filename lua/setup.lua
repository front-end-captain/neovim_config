local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

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
