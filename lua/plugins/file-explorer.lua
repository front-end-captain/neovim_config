local utils = require("utils")

local M = {}

local function opts(desc)
  return { desc = "nvim-tree: " .. desc, noremap = true, silent = true, nowait = true }
end

local function findKeywordInCurrentFolder(state)
  local node = state.tree:get_node()

  if node.type == "directory" then
    local lga = require("telescope").extensions.live_grep_args
    local relative = utils.path_relative(node:get_id(), vim.fn.getcwd())
    local default_text = vim.fn.getreg('"')

    default_text = string.gsub(default_text, "[\r\n]+", "")

    lga.live_grep_args({
      results_title = relative .. "/",
      cwd = node:get_id(),
      default_text = default_text or "",
    })
  end
end

local spec = {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = false,
  branch = "v3.x",
  requires = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = false,
      open_files_do_not_replace_types = { "terminal", "trouble" }, -- when opening files, do not use windows containing these filetypes or buftypes
      sort_case_insensitive = false, -- used when sorting files and directories in the tree
      default_component_configs = {
        container = {
          enable_character_fade = true,
        },
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          expander_collapsed = "",
          expander_expanded = "",
        },
        modified = {
          symbol = "[+]",
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
        },
        git_status = {
          symbols = {
            added = "✚",
            modified = "",
            unstaged = "", -- "✗"
            staged = "✓",
            unmerged = "",
            renamed = "➜",
            untracked = "★",
            deleted = "",
            ignored = "◌",
          },
        },
        -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
        file_size = {
          enabled = true,
          required_width = 64, -- min width of window required to show this column
        },
        type = {
          enabled = true,
          required_width = 122, -- min width of window required to show this column
        },
        last_modified = {
          enabled = true,
          required_width = 88, -- min width of window required to show this column
        },
        created = {
          enabled = true,
          required_width = 110, -- min width of window required to show this column
        },
        symlink_target = {
          enabled = false,
        },
      },
      window = {
        position = "right",
        width = 50,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ["<space>"] = {
            "toggle_node",
            nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
          },
          ["<2-LeftMouse>"] = "open",
          ["<cr>"] = "open",
          ["<esc>"] = "cancel", -- close preview or floating neo-tree window
          ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
          -- Read `# Preview Mode` for more information
          -- ["l"] = "focus_preview",
          ["a"] = "add",
          ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
          ["d"] = "delete",
          ["r"] = "rename",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["c"] = "copy_to_clipboard",
          ["Y"] = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            local modify = vim.fn.fnamemodify
            local relative_path = modify(filepath, ":.")
            utils.copy_file_path_to_clipboard(relative_path, '"')
          end,
          ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
          ["R"] = "refresh",
          ["?"] = "show_help",
          ["i"] = "show_file_details",
          ["G"] = findKeywordInCurrentFolder,
        },
      },
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
        },
        window = {
          mappings = {
            ["<bs>"] = "navigate_up",
            ["."] = "set_root",
            ["H"] = "toggle_hidden",
            -- ["/"] = "fuzzy_finder",
            -- ["D"] = "filter_on_submit",
            ["f"] = "fuzzy_finder_directory",
            ["<c-x>"] = "clear_filter",
          },
          fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
            ["<down>"] = "move_cursor_down",
            ["<C-n>"] = "move_cursor_down",
            ["<up>"] = "move_cursor_up",
            ["<C-p>"] = "move_cursor_up",
          },
        },
      },
    })

    vim.api.nvim_set_keymap("n", "<leader>e", ":Neotree reveal toggle<CR>", opts("Toggle"))
    vim.api.nvim_set_keymap("n", "<leader>E", ":Neotree reveal focus<CR>", opts("Focus"))
  end,
}
table.insert(M, spec)

return M
