return {
  { "MunifTanjim/nui.nvim", lazy = true },

  {
    "yetone/avante.nvim",
    build = vim.fn.has("win32") ~= 0
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    event = "VeryLazy",
    opts = {
      -- debug = true,
      provider = "longcat",
      auto_suggestions_provider = "longcat",
      providers = {
        moonshot = {
          endpoint = "https://api.moonshot.cn/v1",
          model = "kimi-k2-0711-preview",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 32768,
          },
        },
        openai = {
          api_key_name = "COMPANY_AI_API_KEY",
          endpoint = os.getenv("COMPANY_AI_ENDPOINT"),
          model = "gpt-3.5-turbo-0301",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
        },
        longcat = {
          __inherited_from = "openai",
          api_key_name = "COMPANY_AI_API_KEY",
          endpoint = os.getenv("COMPANY_AI_ENDPOINT"),
          model = "LongCat-8B-128K-Chat",
          -- timeout = 30000, -- Timeout in milliseconds
          -- extra_request_body = {
          --   temperature = 0.75,
          --   max_tokens = 20480,
          -- },
        },
      },
      selection = {
        hint_display = "none",
      },
      behaviour = {
        auto_suggestions = false,
        auto_set_keymaps = true,
      },
      suggestion = {
        debounce = 300,
        throttle = 300,
      },
    },
  },

  -- support for image pasting
  -- {
  --   "HakonHarnes/img-clip.nvim",
  --   event = "VeryLazy",
  --   optional = true,
  --   opts = {
  --     -- recommended settings
  --     default = {
  --       embed_image_as_base64 = false,
  --       prompt_for_file_name = false,
  --       drag_and_drop = {
  --         insert_mode = true,
  --       },
  --       -- required for Windows users
  --       use_absolute_path = true,
  --     },
  --   },
  -- },

  -- Make sure to set this up properly if you have lazy=true
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    opts = {
      file_types = { "Avante" },
    },
    ft = { "Avante" },
  },

  -- blink.cmp source for avante.nvim
  {
    "saghen/blink.cmp",
    optional = true,
    specs = { "Kaiser-Yang/blink-cmp-avante" },
    opts = {
      sources = {
        default = { "avante" },
        providers = { avante = { module = "blink-cmp-avante", name = "Avante" } },
      },
    },
  },
}
