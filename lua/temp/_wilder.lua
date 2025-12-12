local M = {}
local spec = {
  "gelguy/wilder.nvim",
  event = "VeryLazy",
  build = ":UpdateRemotePlugins",
  config = function()
    local wilder = require("wilder")
    wilder.setup({
      modes = { ":", "/", "?" },
      next_key = "<C-n>",
      previous_key = "<C-p>",
    })
    wilder.set_option(
      "renderer",
      wilder.renderer_mux({
        [":"] = wilder.popupmenu_renderer({
          highlighter = wilder.basic_highlighter(),
        }),
        ["/"] = wilder.wildmenu_renderer({
          highlighter = wilder.basic_highlighter(),
        }),
      })
    )

    wilder.set_option(
      "renderer",
      wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
        highlights = {
          border = "Normal", -- highlight to use for the border
        },
        -- 'single', 'double', 'rounded' or 'solid'
        -- can also be a list of 8 characters, see :h wilder#popupmenu_border_theme() for more details
        border = "rounded",
      }))
    )
  end,
}
table.insert(M, spec)
return M
