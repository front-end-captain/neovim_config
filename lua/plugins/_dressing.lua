local m = {}
local spec = {
  "stevearc/dressing.nvim",
  -- event = "Verylazy",
  config = function()
    -- https://github.com/stevearc/dressing.nvim#configuration
    require("dressing").setup({})
  end,
}
table.insert(m, spec)
return m
