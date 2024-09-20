local M = {}

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


local spec = {
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
      dashboard.button("e", "🚴 File Explorer", ":Neotree toggle<CR>"),
      dashboard.button("m", "🔖 Bookmarks", ":Telescope bookmarks<CR>"),
      dashboard.button("g", "☕ Git", ":LazyGit<CR>"),
      dashboard.button("f", "🏂 Find files", ":Telescope find_files<CR>"),
      dashboard.button("s", "🔍 Global Search", ":Telescope live_grep<CR>"),
      dashboard.button("q", "✘  Quit NVIM", ":qa<CR>"),
    }
    local handle = io.popen("fortune")
    local fortune = handle:read("*a")
    handle:close()
    dashboard.section.footer.val = fortune

    dashboard.config.opts.noautocmd = true

    -- vim.cmd([[autocmd User AlphaReady echo 'ready']])

    alpha.setup(dashboard.config)
  end,
}
table.insert(M, spec)
return M
