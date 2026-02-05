local help = require("help")

local header = {
  [[+++++;:.                                            .:;+++++]],
  [[++xxxxxxx+:.                                    .:+xxxxxxx++]],
  [[.+xxxxxxx++++;.                               ;++++xxxxxxx+.]],
  [[  :+xxx++++++++;.                          .;++++++++x+x+:. ]],
  [[   .xxxxxxx+xxxx++.                      .++xxxxxxxxxxxx.   ]],
  [[    ;xx+++;:+xxxxx+:                    :+xxxxx+:;+++xx;.   ]],
  [[    .++++x;..:xxxxx++.                .;xxxxxx:..;x++++.    ]],
  [[    .+++++++++xxxxxxx+.:            :.+xxxxxxxx++++++++.    ]],
  [[    .+++;++;..;++xxxxx+;.          .;+xxxxx+x;..;++;+++.    ]],
  [[    .+++++++..:x+xx+xxxx;..      ..;+xxx+xxx+:..+++++++.    ]],
  [[     :xxxxxx:..;xxxx++xxx+:.    ..++xx++xxxx;..:xxxxxx;     ]],
  [[     .+xxxxx;..:xxxxxxx++x+:.  .:+x++xxxxxxx;..;xxxxx+.     ]],
  [[      :+xxxx;....xxxxx+xxx++;;;;++xxx+xxxxx....;xxxx+:      ]],
  [[    .+xx++++;:...:;++xxxxxx++x+++xxxxxx++;::..:;++++xx+.    ]],
  [[    :xxxxx+x+;:;;;:+xxxxxxxxxxxxxxxxxxxx+:;;;:;+++xxxxx:    ]],
  [[   .;xxxxxxxxx+...:++xxxx++++x+++++xxxxx+:...+xxxxxxxxx+.   ]],
  [[    :xxxxxxxxxx;:::::;++;;+:.++ :+;;++;:::::;xxxxxxxxxx:    ]],
  [[    :xxxxxxxxxx++..:..;;;;. :++  .;;;;..:..++xxxxxxxxxx:    ]],
  [[     .+xxxxxxxxxx+;:.::::.  ;xx    ::::.:;+xxxxxxxxxx+:     ]],
  [[      :xxxxxxxxxxxx+:::.     ;:     .:::+xxxxxxxxxxxx:      ]],
  [[       .+xxxxxxxxx;;:.                .::;xxxxxxxxx+.       ]],
  [[         :+xxxx+;:.                      .:;+xx++;........]],
}

return {
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "MunifTanjim/nui.nvim", lazy = true },
  {
    "nvim-mini/mini.icons",
    lazy = true,
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },

        [".eslintrc.cjs"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        ["eslint.config.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
        [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
        [".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
        ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
        ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  {
    "snacks.nvim",
    opts = {
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true, margin = { left = 1, bottom = 1 }, top_down = false },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = false }, -- we set this in options.lua
      words = { enabled = true },
      dashboard = { enabled = false },
      terminal = { enabled = false },
      zenmode = { enabled = true },
    },
    keys = {
      {
        "<leader>n",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notification History",
      },
      {
        "<leader>un",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss All Notifications",
      },
      {
        "<leader>Z",
        function()
          Snacks.zen.zen()
        end,
        desc = "Open zen mode",
      },
    },
  },

  -- dashboard
  {
    "goolord/alpha-nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = header
      dashboard.section.buttons.val = {
        dashboard.button("e", "🚴 File Explorer", "<cmd>Neotree toggle<CR>"),
        dashboard.button("m", "🔖 Bookmarks", "<cmd>Telescope bookmarks<CR>"),
        dashboard.button("g", "☕ Git", "<cmd>LazyGit<CR>"),
        dashboard.button("f", "🏂 Find files", "<cmd>Telescope find_files<CR>"),
        dashboard.button("s", "🔍 Global Search", "<cmd>Telescope live_grep<CR>"),
        dashboard.button("q", "✘  Quit NVIM", "<cmd>qa<CR>"),
      }
      dashboard.config.opts.noautocmd = true
      alpha.setup(dashboard.config)
    end,
  },

  -- transparent background
  {
    "xiyaowong/nvim-transparent",
    config = function()
      vim.g.transparent_enabled = true
      local tt = require("transparent")
      tt.setup()
      tt.clear_prefix("BufferLine")
      tt.clear_prefix("NeoTree")
      -- tt.clear_prefix("lualine")
    end,
  },

  -- manage buffers
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = {
      "famiu/bufdelete.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>k", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev Buffer" },
      { "<leader>j", "<Cmd>BufferLineCycleNext<CR>", desc = "Next Buffer" },
      { "<leader>K", "<Cmd>BufferLineMovePrev<CR>", desc = "Move Prev Buffer" },
      { "<leader>J", "<Cmd>BufferLineMoveNext<CR>", desc = "Move Next Buffer" },
      { "<leader>q", "<cmd>:Bdelete<CR>", desc = "Delete current buffer" },
    },
    opts = {
      options = {
        close_command = "bdelete! %d",
        diagnostics = "nvim_lsp",
        separator_style = "thin",
        always_show_bufferline = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)

      vim.api.nvim_create_augroup("alpha_on_empty", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        pattern = "BDeletePre *",
        group = "alpha_on_empty",
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          local name = vim.api.nvim_buf_get_name(bufnr)

          if name == "" then
            vim.cmd([[:Alpha | bd#]])
          end
        end,
      })

      vim.g.transparent_groups = vim.list_extend(
        vim.g.transparent_groups or {},
        vim.tbl_map(function(v)
          return v.hl_group
        end, vim.tbl_values(require("bufferline.config").highlights))
      )
    end,
  },

  -- Displays status line with git status, LSP diagnostics, filetype information
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      -- PERF: we don't need this lualine require madness 🤷
      -- local lualine_require = require("lualine_require")
      -- lualine_require.require = require

      vim.o.laststatus = vim.g.lualine_laststatus

      local opts = {
        options = {
          theme = "auto",
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = {
            statusline = { "dashboard", "alpha" },
            winbar = { "dashboard", "alpha", "outline", "trouble", "terminal" },
          },
          component_separators = { left = "|", right = "|" },
          section_separators = { left = " ", right = "" },
        },
        winbar = {
          lualine_c = {},
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            {
              "diagnostics",
              symbols = { error = "E", warn = "W", info = "I", hint = "H" },
            },
            {
              "filename",
              file_status = true,
              path = 1,
            },
          },
          lualine_x = {
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            "filesize",
            {
              "fileformat",
              symbols = {
                unix = "LF",
                dos = "CRLF",
                mac = "CR",
              },
            },
          },
        },
        extensions = { "neo-tree", "lazy", "fzf", "toggleterm", "trouble" },
      }

      if help.has("trouble.nvim") then
        local trouble = require("trouble")
        local symbols = trouble.statusline({
          mode = "lsp_document_symbols",
          groups = {},
          title = false,
          filter = { range = true },
          format = "{kind_icon}{symbol.name:Normal}",
        })
        table.insert(opts.sections.lualine_c, {
          symbols.get,
          cond = symbols.has,
        })
      end

      return opts
    end,
  },

  -- completely replaces the UI for messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          -- ["cmp.entry.get_documentation"] = true,
        },

        progress = {
          enabled = false,
        },
      },
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end
      require("noice").setup(opts)
    end,
  },

  -- better vim.ui with telescope
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- cololr highlights for color
  {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function()
      require("colorizer").setup({})
    end,
  },

  -- Animates cursor movement with a smear effect.
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      -- hide_target_hack = true,
      -- cursor_color = "none",
      stiffness = 0.5,
      trailing_stiffness = 0.5,
      matrix_pixel_threshold = 0.5,
      legacy_computing_symbols_support = true,
    },
  },
}
