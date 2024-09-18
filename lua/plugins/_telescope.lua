local M = {}

local utils = require("utils")

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
        initial_mode = "insert",
        mappings = {
          i = {
            ["<C-n>"] = "move_selection_next",
            ["<C-p>"] = "move_selection_previous",
            ["<Down>"] = "move_selection_next",
            ["<Up>"] = "move_selection_previous",
            ["<C-u>"] = "preview_scrolling_up",
            ["<C-d>"] = "preview_scrolling_down",
            ["<CR>"] = utils.edit_respect_winfixbuf,
          },
          n = {
            ["<CR>"] = utils.edit_respect_winfixbuf,
            ["p"] = function(prompt_bufnr)
              local actions_state = require("telescope.actions.state")
              local current_picker = actions_state.get_current_picker(prompt_bufnr)
              local text = vim.fn.getreg('"'):gsub("\n", "\\n")
              current_picker:set_prompt(text, false)
            end,
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
-- resume prev search result
vim.api.nvim_set_keymap("n", "<C-r>", ":Telescope resume<CR>", { noremap = true, silent = true })

return M
