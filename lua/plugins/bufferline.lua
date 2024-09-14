local M = {}

-- Hint = "", "➤"

local map = vim.api.nvim_set_keymap
local opt = { noremap = true, silent = true }

-- go to prev tab and next tab
map("n", "<leader>k", ":BufferLineCyclePrev<CR>", opt)
map("n", "<leader>j", ":BufferLineCycleNext<CR>", opt)

local spec = {
  "akinsho/bufferline.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons", },
  event = "VimEnter",
  config = function()
    require("bufferline").setup({
      options = {
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
          },
        },
        diagnostics = "nvim_lsp",
        -- -@diagnostic disable-next-line: unused-local
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local s = " "
          for e, n in pairs(diagnostics_dict) do
            local sym = e == "error" and "✘" or (e == "warning" and "⚠" or "➤")
            s = s .. n .. sym .. " "
          end
          return s
        end,
        -- 'slant' | 'padded_slant' | 'thick' | 'thin' | 'slope' | 'padded_slope'
        separator_style = "thin",
        always_show_bufferline = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
      },
      highlights = {
        buffer_selected = {
          bold = true,
          italic = true,
        },
        warning_selected = {
          fg = "NONE",
          bg = "NONE",
          sp = "NONE",
          bold = true,
          italic = true,
        },
        error_selected = {
          fg = "NONE",
          bg = "NONE",
          sp = "NONE",
          bold = true,
          italic = true,
        },
      },
    })
  end,
}
table.insert(M, spec)

return M
