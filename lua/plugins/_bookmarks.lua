local M = {}
local spec = {
  "crusj/bookmarks.nvim",
  event = "VeryLazy",
  branch = "main",
  dependencies = { "nvim-web-devicons" },
  config = function()
    require("bookmarks").setup({
      keymap = {
        toggle = "<tab><tab>", -- Toggle bookmarks(global keymap)
        close = "q", -- close bookmarks (buf keymap)
        add = "<leader>m", -- Add bookmarks(global keymap)
        add_global = "<leader>M", -- Add global bookmarks(global keymap), global bookmarks will appear in all projects. Identified with the symbol '󰯾'
        jump = "<CR>", -- Jump from bookmarks(buf keymap)
        delete = "dd", -- Delete bookmarks(buf keymap)
        order = "<space><space>", -- Order bookmarks by frequency or updated_time(buf keymap)
        -- delete_on_virt = "\\dd", -- Delete bookmark at virt text line(global keymap)
        show_desc = "<leader>s", -- show bookmark desc(global keymap)
        focus_tags = "<c-j>", -- focus tags window
        focus_bookmarks = "<c-k>", -- focus bookmarks window
        -- toogle_focus = "<S-Tab>", -- toggle window focus (tags-window <-> bookmarks-window)
      },
      width = 0.9, -- Bookmarks window width:  (0, 1]
      height = 0.9, -- Bookmarks window height: (0, 1]
      preview_ratio = 0.45, -- Bookmarks preview window ratio (0, 1]
      tags_ratio = 0.1, -- Bookmarks tags window ratio
      fix_enable = false, -- If true, when saving the current file, if the bookmark line number of the current file changes, try to fix it.
      virt_text = "m", -- Show virt text at the end of bookmarked lines, if it is empty, use the description of bookmarks instead.
      sign_icon = "󰃃",
      border_style = "rounded", -- border style: "single", "double", "rounded"
    })
    require("telescope").load_extension("bookmarks")
  end,
}

table.insert(M, spec)

return M
