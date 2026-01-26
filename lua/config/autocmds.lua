local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    (vim.hl or vim.highlight).on_yank({ higroup = "Visual", timeout = 500 })
  end,
})

vim.api.nvim_create_augroup("IrreplaceableWindows", { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = "IrreplaceableWindows",
  pattern = "*",
  callback = function()
    local filetypes = { "OverseerList", "neo-tree" }
    local buftypes = { "nofile", "terminal" }
    if
      vim.tbl_contains(buftypes, vim.bo.buftype) and vim.tbl_contains(filetypes, vim.bo.filetype)
    then
      vim.cmd("set winfixbuf")
    end
  end,
})
