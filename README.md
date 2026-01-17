# Neovim Config

## Commands(lua 命令)

形如 `:lua {chunk}` `:luado {chunk}` 这样的命令在neovim中会被作为 lua 代码块被执行
形如 `:luafile {filename}` 这样的命令在neovim中会被作为 lua 文件块被执行

## IMPORTING LUA MODULES(导入lua模块)

neovim 默认情况下从 `runtimepath` 和 `package.path` 这些目录下查找模块

```shell
:lua vim.print(package.path)
:lua vim.print(vim.opt.runtimepath)
```

## Vimscript v:lua interface(vim脚本中的lua接口)

在 neovim 可以用 vim 脚本作为配置文件，在vim脚本配置文件中可以通过 v:lua 访问lua变量、函数等

```vimscript
call v:lua.func(arg1, arg2)
```

## Lua standard modules(Lua标准库)

neovim Lua 的标准库是 `vim` 模块，不需要 require，可以通过 `vim` 直接访问

```shell
:lua vim.print(vim)
```

`vim` 模块内置了很多 API 和 变量，比如：
`vim.api.{func}({...})` 可以调用 neovim 的 API，比如：获取当前行 `vim.api.nvim_get_current_line()`。更多的 API 可以访问 [API](https://neovim.io/doc/user/api.html)
`vim.NIL` 指定一个值为 `NIL`，比如：把 foo 赋值为 `NIL` `local foo = vim.NIL`

更多的内置接口可以访问 [vim.builtin](https://neovim.io/doc/user/lua.html#vim.builtin)

### vim.uv

`vim.uv` 可以在 lua 中访问绑定的 libUV 库，提供了网络、文件系统、进程和事件循环等接口

```lua
-- 一秒后输出 'test'
local timer = vim.uv.new_timer()
timer:start(1000, 0, vim.schedule_wrap(function()
  vim.api.nvim_command('echomsg "test"')
end))
```

### lua vimscript bridge(lua中的vimscript桥)

neovim lua 提供了一个接口可以去访问 vimscript 中的变量、函数和编辑器命令等

#### vim.fn.{func}({...})

比如，调用 vimscript 提供的‘删除数组指定位置的元素’方法:

```lua
local list = { 1, 2, 3 }
local removedItem = vim.fn.remove(list, 1)
vim.print(list) -- { 1, 2, 3 }
vim.print(removedItem) -- 2
```

vimscript 提供的函数清单可以在这里看到[function-list](https://neovim.io/doc/user/usr_41.html#function-list)

#### vim.cmd({command})

执行 vimscript(ex-commands), 比如：

```lua
vim.cmd('echo 42') -- 输出 42
vim.cmd('write! foo.txt') -- 保存文件
```

#### vim-variables

访问 vim 编辑器中各个作用域的变量：

```lua
vim.g.foo -- global
vim.b.foo -- buffer
vim.w.foo -- window
vim.t.foo -- tabpage
```

设置和访问 vim 的配置项：

```lua
vim.o.number = true -- like `set number` in vimscript
vim.bo.number = true -- enable column number on buffer-scoped
vim.wo.number = true -- enable column number on widnow-scoped
```

#### highlight

#### inspector & iter

lua 中的 table 可以被用作字典(dict)和列表(list)，但是在 neovim lua 中：
符合以下条件被定义为 lua-list:

- 空的 table。可以使用 `vim.empty_dict()` 判断是否是空的table
- table 中的 key 是连续的从1开始的整数且没有 NIL。可以使用 `vim.islist` 判断
  符合以下条件被定义为 lua-dict:
- table 的 key 是字符串

#### base64

base64编码和解码

```lua
vim.print(vim.base64.encode("foo"))
vim.print(vim.base64.decode(vim.base64.encode("foo")))
```

#### filetype

可以通过文件名称、文件路径、文件扩展名添加一个文件类型:

```lua
vim.filetype.add({
  filename = {
    [".foorc"] = "toml",
  },
})
```

当打开 .foorc 时，通过 :set ft? 可以看到该文件的类型是 toml
或者通过 `vim.filetype.match` 查看：

```lua
local bufnr = vim.api.nvim_get_current_buf()
vim.print(vim.filetype.match({ buf = bufnr })) -- toml
```

#### fs

文件访问和操作

```lua
vim.print(vim.uv.fs_stat('.foorc')) -- 返回文件状态
vim.fs.rm('.foorc') -- 删除文件
vim.fs.abspath('.foorc') -- 返回绝对路径
```

#### glob & lpeg

#### json

json的编码和解码

```lua
vim.print(vim.json.encode({ foo = "foo" }))
vim.print(vim.json.decode('{ "foo": "foo" }'))
```

#### keymap

键位映射

```lua
-- Map 'x' to a lua function while Normal mode
vim.keymap.set('n', 'x', function() vim.print('real lua func') end)
-- or
-- vim.api.nvim_set_keymap("n", "x", ":lua vim.print('hello')<CR>", {})
-- Map 'X' to a lua function(print current line) while Normal mode or Visual mode
vim.keymap.set({'n', 'v'}, 'X', function() vim.print(tostring(vim.api.nvim_get_current_line())) end)
```

#### loader

lua 模块加载器，常用于在 lazy.nvim 启用插件懒加载

```lua
vim.loader.enable(true)
```

#### regex

#### uri

uri的编码和解码

```lua
vim.print(vim.uri_encode("https://www.baidu.com?foo=bar"))
vim.print(vim.uri_decode(vim.uri_encode("https://www.baidu.com?foo=bar")))
```

#### version-range

语义化版本号的解析和比较

```lua
local parsedVersion = vim.version.parse('1.1.1-rc1+build.2')
vim.print(parsedVersion) -- { major = 1, minor = 1, patch = 1, prerelease = 'rc1', build = 'build.2'}


vim.print(vim.version.cmp({ 1, 0, 3 }, { 1, 0, 2 })) -- 1
vim.print(vim.version.cmp({ 1, 0, 3 }, { 1, 0, 3 })) -- 0
vim.print(vim.version.cmp({ 1, 0, 3 }, { 1, 0, 4 })) -- -1
```

更多关于语义化版本号的API见[version-range](https://neovim.io/doc/user/lua.html#version-range)

## Autocmd(Event Handler) 事件订阅

订阅neovim内置事件

```lua
local group = vim.api.nvim_create_augroup("highlight_yank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    (vim.hl or vim.highlight).on_yank({ higroup = "Visual", timeout = 200 })
  end,
})
```

订阅自定义事件

```lua
local group = vim.api.nvim_create_augroup("GroupName", { clear = true })
vim.api.nvim_create_autocmd("EventType", {
  group = group,
  pattern = "EventName",
  callback = function()
    vim.print("Execute EventName Handler")
  end,
})
vim.api.nvim_exec_autocmds("EventType", { pattern = "EventName" })
```

# UI

- akinsho/bufferline.nvim // tabs, which include filetype icons and close buttons
- nvim-lualine/lualine.nvim // Displays a fancy status line with git status, LSP diagnostics, filetype information, and more
- folke/noice.nvim // UI for messages, cmdline and the popupmenu
- nvim-mini/mini.icons // icons
- MunifTanjim/nui.nvim // ui components
- snacks.nvim //
- sphamba/smear-cursor.nvim // Animates cursor movement with a smear effect
- nvim-mini/mini.indentscope // Active indent guide and indent text objects
- lukas-reineke/indent-blankline.nvim // like 'nvim-mini/mini.indentscope'
- nvim-mini/mini.animate // Animates many common Neovim actions, like scrolling, moving the cursor, and resizing windows
- nvim-treesitter/nvim-treesitter-context // show code context

# Treesitter

- nvim-treesitter/nvim-treesitter // syntax highlighting
- nvim-treesitter/nvim-treesitter-textobjects // Syntax aware text-objects, select, move, swap, and peek support
- windwp/nvim-ts-autotag // Automatically add closing tags for HTML and JSX

# Formatting

- stevearc/conform.nvim // code formatting

# Editor

- MagicDuck/grug-far.nvim // search/replace in multiple files
- folke/flash.nvim // navigate your code with search labels
- folke/which-key.nvim // helps you remember key bindings by showing a popup
- lewis6991/gitsigns.nvim // show git signs highlights text
- folke/trouble.nvim // better diagnostics list and others
- folke/todo-comments.nvim // Finds and lists all of the TODO, HACK, BUG, etc comment
- stevearc/aerial.nvim // Aerial Symbol Browser
- monaqa/dial.nvim // Increment and decrement numbers, dates, and more
- ibhagwan/fzf-lua // Awesome picker for FZF (alternative to Telescope)
- ThePrimeagen/harpoon // see https://github.com/ThePrimeagen/harpoon
- RRethy/vim-illuminate // Automatically highlights other instances of the word under your cursor
-

# ColorScheme

- folke/tokyonight.nvim
- catppuccin/nvim

# Coding

- nvim-mini/mini.pairs // Automatically inserts a matching closing character
- folke/ts-comments.nvim // Improves comment syntax
- JoosepAlviste/nvim-ts-context-commentstring // setting the commentstring option based on the cursor location in the file
- nvim-mini/mini.comment // pre-line commenting
- nvim-mini/mini.ai // Extends the a & i text objects
- folke/lazydev.nvim // Configures LuaLS to support auto-completion and type checking while editing your Neovim configuration
- saghen/blink.cmp // auto completion while insert code
- nvim-mini/mini.snippets // manage and expand snippets
- garymjr/nvim-snippets // vscode style snippets
- L3MON4D3/LuaSnip // lus snippets
- nvim-mini/mini.surround // Fast and feature-rich surround actions
- danymat/neogen // A better annotation generator
- gbprod/yanky.nvim // better yank/paste

# LSP

- neovim/nvim-lspconfig // Lsp Config
- mason.nvim // install and manage LSP servers
- mason-org/mason-lspconfig.nvim // bridges mason.nvim with the neovim/nvim-lspconfig

# Config dir structure

```
├── lua
│   ├── config
│   │   ├── autocmds.lua # auto commands
│   │   ├── keymaps.lua # key map
│   │   ├── options.lua # vim options
│   │   └── init.lua
│   ├── plugins
│   │   ├── autocmds.lua # auto commands
│   └── foo
└── init.lua
```

# Install Rust Tool

```shelll
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source " $ HOME/.cargo/env"
```

# Install TreeSitter

```shelll
git clone https://github.com/tree-sitter/tree-sitter.git
cd tree-sitter

cargo build --release

sudo cp target/release/tree-sitter /usr/local/bin/

tree-sitter --version
```
