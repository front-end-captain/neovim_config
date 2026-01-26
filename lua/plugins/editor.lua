local help = require("help")
-- local edit_respect_winfixbuf = require("help.edit_respect_winfixbuf")

return {
  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    depends = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, reveal = true })
        end,
        desc = "Explorer NeoTree",
      },
      {
        "<leader>E",
        function()
          require("neo-tree.command").execute({ action = "focus", reveal = true })
        end,
        desc = "Explorer NeoTree",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
      -- because `cwd` is not set up properly.
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
        desc = "Start Neo-tree with directory",
        once = true,
        callback = function()
          if package.loaded["neo-tree"] then
            return
          else
            local stats = vim.uv.fs_stat(vim.fn.argv(0))
            if stats and stats.type == "directory" then
              require("neo-tree")
            end
          end
        end,
      })
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = false,
      sort_case_insensitive = false,
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
      },
      window = {
        position = "right",
        mappings = {
          ["<cr>"] = "open",
          ["<space>"] = {
            "toggle_node",
            nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
          },
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "Copy Path to Clipboard",
          },
          ["O"] = {
            function(state)
              require("lazy.util").open(state.tree:get_node().path, { system = true })
            end,
            desc = "Open with System Application",
          },
          ["P"] = { "toggle_preview", config = { use_float = false } },
          ["G"] = help.findKeywordInCurrentFolder,
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
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
      },
    },
  },
  -- code fold/unfold
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    event = "BufRead",
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
      },
      {
        "<leader>z",
        function()
          require("ufo").closeFoldsWith(1)
        end,
      },
      {
        "<leader>zz",
        function()
          require("ufo").closeFoldsWith(2)
        end,
      },
      {
        "<leader>zzz",
        function()
          require("ufo").closeFoldsWith(3)
        end,
      },
      {
        "K",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
      },
    },
    config = function()
      vim.o.foldcolumn = "0"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

      vim.api.nvim_set_keymap("n", "zz", "<Cmd>foldclose<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "Z", "<Cmd>foldopen<CR>", { noremap = true, silent = true })

      local ufo = require("ufo")
      ufo.setup({
        fold_virt_text_handler = help.fold_virt_text_handler,
        preview = {
          win_config = {
            winhighlight = "Normal:Folded",
            winblend = 0,
          },
          mappings = {
            scrollU = "<C-u>",
            scrollD = "<C-d>",
            jumpTop = "[",
            jumpBot = "]",
          },
        },
        provider_selector = function()
          return { "lsp", "indent" }
        end,
      })
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    lazy = false,
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = true,
      },
    },
    opts = function()
      local actions = require("telescope.actions")

      return {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          -- open files in the first window that is an actual file.
          -- use the current window if no other window is available.
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "" then
                return win
              end
            end
            return 0
          end,
          initial_mode = "insert",
          mappings = {
            i = {
              ["<C-n>"] = "move_selection_next",
              ["<C-p>"] = "move_selection_previous",
              ["<Down>"] = "move_selection_next",
              ["<Up>"] = "move_selection_previous",
              ["<C-u>"] = "preview_scrolling_up",
              ["<C-d>"] = "preview_scrolling_down",
              -- ["<CR>"] = edit_respect_winfixbuf.edit_respect_winfixbuf,
            },
            n = {
              ["q"] = actions.close,
              -- ["<CR>"] = edit_respect_winfixbuf.edit_respect_winfixbuf,
              ["P"] = "select_default",
              ["p"] = function(prompt_bufnr)
                local actions_state = require("telescope.actions.state")
                local current_picker = actions_state.get_current_picker(prompt_bufnr)
                local text = vim.fn.getreg('"'):gsub("\n", "\\n")
                current_picker:set_prompt(text, false)
              end,
            },
          },
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
          lsp_definitions = {
            theme = "cursor",
            initial_mode = "normal",
            layout_strategy = "flex",
            layout_config = {
              width = 0.8,
            },
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      telescope.setup(opts)

      pcall(telescope.load_extension, "live_grep_args")
      pcall(telescope.load_extension, "yank_history")

      -- find file
      vim.keymap.set(
        "n",
        "<C-f>",
        builtin.find_files,
        { noremap = true, silent = true, desc = "Telescope find files" }
      )
      -- recent opened files
      vim.keymap.set("n", "<leader>F", function()
        builtin.oldfiles({ only_cwd = true })
      end, { noremap = true, silent = true })
      -- global search
      vim.keymap.set("n", "<C-g>", builtin.live_grep, { noremap = true, silent = true })

      -- resume prev search result
      vim.keymap.set("n", "<leader>r", builtin.resume, { noremap = true, silent = true })

      vim.keymap.set("n", "<leader>ch", builtin.command_history, { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>sh", builtin.search_history, { noremap = true, silent = true })
    end,
  },

  -- Git integration: signs, hunk actions, blame
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = function()
      require("gitsigns").setup({
        current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
        },
      })
    end,
  },

  -- lazygit integration
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>g", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
    config = function()
      vim.g.lazygit_floating_window_winblend = 0 -- transparency of floating window
      vim.g.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window
      vim.g.lazygit_floating_window_border_chars =
        { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } -- customize lazygit popup window border characters
      vim.g.lazygit_floating_window_use_plenary = 0 -- use plenary.nvim to manage floating window if available
      vim.g.lazygit_use_neovim_remote = 1 -- fallback to 0 if neovim-remote is not installed

      require("lazygit").setup()
    end,
  },

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {
      focus = true,
      -- win = { position = "right", width = 100 },
    },
    keys = {
      {
        "<leader>x",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
    },
    config = function(_, opts)
      require("trouble").setup(opts)
    end,
  },

  -- Finds and lists all of the TODO, HACK, BUG, etc comment
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "VeryLazy",
    opts = {
      keywords = {
        FIX = {
          icon = " ", -- icon used for the sign, and in search results
          color = "error", -- can be a hex color, or a named color (see below)
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
    },
    keys = {
      { "<leader>tt", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    },
    config = function(_, opts)
      require("todo-comments").setup(opts)
    end,
  },

  -- list symbols outline
  {
    "hedyhli/outline.nvim",
    keys = { { "<leader>o", "<cmd>Outline<cr>", desc = "Toggle Outline" } },
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    opts = {},
    config = function(_, opts)
      require("outline").setup(opts)
    end,
  },

  -- terminal integration
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      shell = os.getenv("OS") == "Windows_NT" and "pwsh" or vim.o.shell,
      open_mapping = [[<c-\>]],
      insert_mappings = true,
      terminal_mappings = true,
      hide_numbers = true,
      start_in_insert = true,
    },
    keys = {
      {
        "<leader>t",
        "<Cmd>ToggleTerm<CR>",
        { desc = "Toggle terminal" },
      },
      {
        "<leader>T",
        "<Cmd>ToggleTerm direction=vertical<CR>",
        { desc = "Toggle vertical terminal" },
      },
    },
    config = function(_, opts)
      function _G.set_terminal_keymaps()
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { buffer = 0 })
      end

      local terminal_augroup = vim.api.nvim_create_augroup("TerminalSetup", { clear = true })
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*",
        callback = set_terminal_keymaps,
        group = terminal_augroup,
      })

      require("toggleterm").setup(opts)
    end,
  },
}
