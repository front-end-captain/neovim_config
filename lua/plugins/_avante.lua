local os = require("os")

--  dispatch_agent/bash 's description too long(>1024), COMPANY_AI_ENDPOINT not support
local disable_tools = {
  "dispatch_agent",
  "bash",
  "git_diff",
  "git_commit",
  "create",
  "rename_file",
  "delete_file",
  "create_dir",
  "rename_dir",
}

local M = {}
local spec = {
  "yetone/avante.nvim",
  -- enable = false,
  event = "VeryLazy",
  lazy = false,
  version = false,
  opts = {
    debug = true,
    provider = "moonshot",
    -- auto_suggestions_provider = "morph",
    providers = {
      openai = {
        api_key_name = "COMPANY_AI_API_KEY",
        endpoint = os.getenv("COMPANY_AI_ENDPOINT"),
        model = "gpt-4o-mini",
        timeout = 30000, -- Timeout in milliseconds
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 20480,
        },
      },
      moonshot = {
        endpoint = "https://api.moonshot.cn/v1",
        model = "kimi-k2-0711-preview",
        timeout = 30000, -- Timeout in milliseconds
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 32768,
        },
      },
      morph = {
        model = "morph-v3-large", -- morph-v3-fast
      },
      groq = {
        __inherited_from = "openai",
        api_key_name = "GROQ_API_KEY",
        endpoint = "https://api.groq.com/openai/v1/",
        model = "llama-3.3-70b-versatile",
      },
    },
    -- disable_tools = disable_tools,
    behaviour = {
      auto_suggestions = false, -- Experimental stage
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
      minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
      enable_token_counting = true, -- Whether to enable token counting. Default to true.
      auto_approve_tool_permissions = false, -- Default: show permission prompts for all tools
      enable_fastapply = true, -- Enable Fast Apply feature
    },
    -- suggestion = {
    --   debounce = 200, -- Default is 600
    --   throttle = 200, -- Default is 600
    -- },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "echasnovski/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    -- {
    --   -- Make sure to set this up properly if you have lazy=true
    --   "MeanderingProgrammer/render-markdown.nvim",
    --   opts = {
    --     -- file_types = { "markdown", "Avante" },
    --     file_types = { "Avante" },
    --   },
    --   ft = { "Avante" },
    -- },
  },
}

table.insert(M, spec)

return M
