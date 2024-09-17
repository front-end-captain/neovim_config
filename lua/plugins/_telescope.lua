local M = {}

local actions_state = require 'telescope.actions.state'
local utils = require 'telescope.utils'
local Path = require 'plenary.path'

local edit_buffer
do
  local map = {
    edit = 'buffer',
    new = 'sbuffer',
    vnew = 'vert sbuffer',
    tabedit = 'tab sb',
  }

  edit_buffer = function(command, bufnr)
    command = map[command]
    if command == nil then
      error 'There was no associated buffer command'
    end
    vim.cmd(string.format('%s %d', command, bufnr))
  end
end

local function edit_respect_winfixbuf(prompt_bufnr)
  ---@diagnostic disable-next-line: missing-parameter
  actions_state.get_current_history():append(actions_state.get_current_line(),
    actions_state.get_current_picker(prompt_bufnr))
  local command = actions_state.select_key_to_edit_key 'default'
  local entry = actions_state.get_selected_entry()

  if not entry then
    utils.notify('actions.set.edit', {
      msg = 'Nothing currently selected',
      level = 'WARN',
    })
    return
  end

  local filename, row, col

  if entry.path or entry.filename then
    filename = entry.path or entry.filename

    -- TODO: Check for off-by-one
    row = entry.row or entry.lnum
    col = entry.col
  elseif not entry.bufnr then
    -- TODO: Might want to remove this and force people
    -- to put stuff into `filename`
    local value = entry.value
    if not value then
      utils.notify('actions.set.edit', {
        msg = 'Could not do anything with blank line...',
        level = 'WARN',
      })
      return
    end

    if type(value) == 'table' then
      value = entry.display
    end

    local sections = vim.split(value, ':')

    filename = sections[1]
    row = tonumber(sections[2])
    col = tonumber(sections[3])
  end

  -- this is telescope promt buffer
  local entry_bufnr = entry.bufnr

  local picker = actions_state.get_current_picker(prompt_bufnr)
  require('telescope.pickers').on_close_prompt(prompt_bufnr)
  pcall(vim.api.nvim_set_current_win, picker.original_win_id)

  if picker.push_cursor_on_edit then
    vim.cmd "normal! m'"
  end

  if picker.push_tagstack_on_edit then
    local from = { vim.fn.bufnr '%', vim.fn.line '.', vim.fn.col '.', 0 }
    local items = { { tagname = vim.fn.expand '<cword>', from = from } }
    vim.fn.settagstack(vim.fn.win_getid(), { items = items }, 't')
  end

  -- make sure current buffer in this window does not contain following types
  -- if win_id ~= 0 and a.nvim_get_current_win() ~= win_id then
  --   vim.api.nvim_set_current_win(win_id)
  -- end

  -- local filetypes_to_avoid = { 'OverseerList', 'terminal', 'quickfix', 'nofile' }
  -- local win_bufnr = vim.api.nvim_win_get_buf(win_id)
  -- local entry_buf_buftype = vim.api.nvim_get_option_value('buftype', { buf = win_bufnr })
  -- vim.notify('Buftype:' .. entry_buf_buftype)
  -- if vim.tbl_contains(filetypes_to_avoid, entry_buf_buftype) then
  --   vim.notify('Not to replace ' .. entry_buf_buftype)
  --   return false
  -- end
  local windows = vim.api.nvim_list_wins()
  for _, winid in ipairs(windows) do
    if not vim.api.nvim_get_option_value('winfixbuf', { win = winid }) then
      vim.api.nvim_set_current_win(winid)
      break
    end
  end

  if entry_bufnr then
    if not vim.api.nvim_get_option_value('buflisted', { buf = entry_bufnr }) then
      vim.api.nvim_set_option_value('buflisted', true, { buf = entry_bufnr })
    end
    edit_buffer(command, entry_bufnr)
  else
    -- check if we didn't pick a different buffer
    -- prevents restarting lsp server
    if vim.api.nvim_buf_get_name(0) ~= filename or command ~= 'edit' then
      filename = Path:new(filename):normalize(vim.loop.cwd())
      pcall(vim.cmd, string.format('%s %s', command, vim.fn.fnameescape(filename)))
    end
  end

  -- HACK: fixes folding: https://github.com/nvim-telescope/telescope.nvim/issues/699
  if vim.wo.foldmethod == 'expr' then
    vim.schedule(function()
      vim.opt.foldmethod = 'expr'
    end)
  end

  local pos = vim.api.nvim_win_get_cursor(0)
  if col == nil then
    if row == pos[1] then
      col = pos[2] + 1
    elseif row == nil then
      row, col = pos[1], pos[2] + 1
    else
      col = 1
    end
  end

  if row and col then
    local ok, err_msg = pcall(vim.api.nvim_win_set_cursor, 0, { row, col })
    if not ok then
      log.debug('Failed to move to cursor:', err_msg, row, col)
    end
  end
end

local spec = {
  "nvim-telescope/telescope.nvim",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        -- initial_mode = "insert",
        mappings = {
          i = {
            ["<C-n>"] = "move_selection_next",
            ["<C-p>"] = "move_selection_previous",
            ["<Down>"] = "move_selection_next",
            ["<Up>"] = "move_selection_previous",
            ["<C-u>"] = "preview_scrolling_up",
            ["<C-d>"] = "preview_scrolling_down",
            ["<CR>"] = edit_respect_winfixbuf,
          },
        },
        -- file_ignore_patterns = {"*.png", "*.jpeg", "*.jpg", "dist" },
      },
      pickers = {
        live_grep = {
          theme = "dropdown",
          -- "horizontal" | "center" | "cursor" | "vertical" | "flex" | "bottom_pane"
          layout_strategy = "vertical",
          layout_config = {
            prompt_position = "top",
            width = function(_, max_columns, _)
              return math.max(max_columns - 80, 80)
            end,
            height = function(_, _, max_lines)
              return max_lines - 2
            end,
          },
        },
      },
    })
    pcall(telescope.load_extension, "notify")
    pcall(telescope.load_extension, "live_grep_args")
  end,
}

table.insert(M, spec)
-- find file
vim.api.nvim_set_keymap(
  "n",
  "<C-f>",
  ":Telescope find_files<CR>",
  { noremap = true, silent = true }
)
-- global search
vim.api.nvim_set_keymap("n", "<C-g>", ":Telescope live_grep<CR>", { noremap = true, silent = true })

return M
