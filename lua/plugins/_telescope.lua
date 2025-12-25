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
    local builtin = require("telescope.builtin")
    local telescope_builtin_pickers = require("telescope.builtin")
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
            ["P"] = "select_default",
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
        find_files = {
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
      },
    })
    pcall(telescope.load_extension, "notify")
    pcall(telescope.load_extension, "live_grep_args")

    vim.keymap.set(
      "n",
      "<leader>lr",
      telescope_builtin_pickers.registers,
      { desc = "Telescope list registers" }
    )

    -- find file
    vim.keymap.set(
      "n",
      "<C-f>",
      builtin.find_files,
      { noremap = true, silent = true, desc = "Telescope find files" }
    )
    -- global search
    vim.keymap.set("n", "<C-g>", builtin.live_grep, { noremap = true, silent = true })

    -- resume prev search result
    vim.keymap.set("n", "<leader>r", builtin.resume, { noremap = true, silent = true })
  end,
}

table.insert(M, spec)

return M
