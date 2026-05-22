local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- -- Highlight on yank
-- vim.api.nvim_create_autocmd("TextYankPost", {
--   group = augroup("highlight_yank"),
--   callback = function()
--     (vim.hl or vim.highlight).on_yank({ higroup = "Visual", timeout = 500 })
--   end,
-- })

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

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    -- "PlenaryTestPopup",
    -- "checkhealth",
    -- "dbout",
    -- "gitsigns-blame",
    -- "grug-far",
    "help",
    "lspinfo",
    -- "neotest-output",
    -- "neotest-output-panel",
    -- "neotest-summary",
    "notify",
    -- "qf",
    -- "spectre_panel",
    -- "startuptime",
    -- "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- Auto reload file when changed externally
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = augroup("auto_reload"),
  pattern = "*",
  command = "checktime",
})

-- Copy current file path to default register
vim.api.nvim_create_user_command("CopyPath", function(opts)
  local abs = vim.api.nvim_buf_get_name(0)
  local path
  if opts.bang then
    path = abs
  else
    local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
    if vim.v.shell_error ~= 0 or not root then
      path = vim.fn.fnamemodify(abs, ":~:.")
    else
      path = vim.fn.fnamemodify(abs, ":p"):sub(#root + 2)
    end
  end
  vim.fn.setreg('"', path)
  vim.notify('Copied: ' .. path, vim.log.levels.INFO)
end, {
  bang = true,
  desc = "Copy file path to default register (bang for absolute path)",
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})
