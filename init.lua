require("keybindings")

if vim.g.vscode then
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  vim.opt.rtp:prepend(lazypath)

  require("lazy").setup()

  local vscode = require("vscode")
  vim.notify = vscode.notify

  vim.keymap.set({ "n" }, "<leader>f", function()
    vscode.action("editor.action.formatDocument")
  end)
  vim.keymap.set({ "n" }, "<leader>k", function()
    vscode.action("workbench.action.previousEditor")
  end)
  vim.keymap.set({ "n" }, "<leader>j", function()
    vscode.action("workbench.action.nextEditor")
  end)
  vim.keymap.set({ "n" }, "<leader>q", function()
    vscode.action("workbench.action.closeActiveEditor")
  end)
  vim.keymap.set({ "n" }, "<leader>e", function()
    vscode.action("workbench.files.action.focusFilesExplorer")
    -- workbench.action.toggleSidebarVisibility
  end)
  vim.keymap.set({ "n" }, "<leader>zz", function()
    vscode.action("editor.toggleFold")
  end)
  vim.keymap.set({ "n", "x" }, "cc", function()
    vscode.action("editor.action.commentLine")
  end)
  vim.keymap.set({ "n", "x" }, "cb", function()
    vscode.action("editor.action.blockComment")
  end)
else
  require("options")
  require("setup")
end
