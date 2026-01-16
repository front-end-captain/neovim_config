require("config").setup()

-- vim.print(package.loaded)
-- vim.print(package.path)
-- :echo nvim_list_runtime_paths()
-- vim.print(vim.opt.runtimepath)

-- local foo = vim.NIL
-- local timer = vim.uv.new_timer()
-- timer:start(1000, 0, vim.schedule_wrap(function()
--   vim.api.nvim_command('echomsg "test"')
--   vim.print(tostring(vim.api.nvim_get_current_line()))
--   vim.print(foo)
-- end))

-- local list = { 1, 2, 3 }
-- local removedItem = vim.fn.remove(list, 1)
-- vim.print(list) -- { 1, 2, 3 }
-- vim.print(removedItem) -- 2

-- vim.cmd('echo "hello"')
-- vim.cmd('echo 42')

-- vim.notify("hello")

-- vim.opt.number = true

-- vim.keymap.set("n", "zS", vim.show_pos)

-- vim.print(vim.mpack.encode({ foo = "foo", bar = "bar" }))

-- local parsedVersion = vim.version.parse("1.1.1-rc1+build.2")
-- vim.print(parsedVersion) -- { major = 1, minor = 1, patch = 1, prerelease = 'rc1', build = 'build.2'}

-- vim.print(vim.version.cmp({ 1, 0, 3 }, { 1, 0, 2 })) -- 1
-- vim.print(vim.version.cmp({ 1, 0, 3 }, { 1, 0, 3 })) -- 0
-- vim.print(vim.version.cmp({ 1, 0, 3 }, { 1, 0, 4 })) -- -1

-- vim.print(vim.uri_encode("https://www.baidu.com?foo=bar"))
-- vim.print(vim.uri_decode(vim.uri_encode("https://www.baidu.com?foo=bar")))

-- vim.o.shiftwidth = 16
-- vim.ui.input({ prompt = "Enter value for shiftwidth: " }, function(input)
--   vim.o.shiftwidth = tonumber(input)
-- end)

-- local bufnr = vim.api.nvim_get_current_buf()
-- vim.print(vim.regex([[opt\.number]]):match_line(bufnr, 25))
-- vim.print(vim.regex([[opt\.number]]):match_str('vim.opt.number = true'))

-- vim.keymap.set("n", "x", function()
--   vim.print("real lua func")
-- end)
-- vim.keymap.set({ "n", "v" }, "X", function()
--   vim.print(tostring(vim.api.nvim_get_current_line()))
-- end)

-- vim.api.nvim_set_keymap("n", "x", ":lua vim.print('hello')<CR>", {
--   nowait = true,
--   noremap = true,
--   desc = "real lua func",
-- })
-- vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)

-- vim.print(vim.json.encode({ foo = "foo" }))
-- vim.print(vim.json.decode('{ "foo": "foo" }'))

-- vim.cmd([[
--   augroup highlight_yank
--   autocmd!
--   au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})
--   augroup END
-- ]])

-- local it = vim.iter({ 1, 2, 3 })
-- it:map(function(item)
--   return item * 2
-- end)
-- vim.print(it:totable())

-- vim.print(vim.base64.encode("foo"))
-- vim.print(vim.base64.decode(vim.base64.encode("foo")))

-- vim.filetype.add({
--   pattern = {
--     ["%.env%.[%w_.-]+"] = "dotenv",
--   },
--   filename = {
--     [".foorc"] = "toml",
--   },
-- })
-- local bufnr = vim.api.nvim_get_current_buf()
-- vim.print(vim.filetype.match({ buf = bufnr }))

-- vim.fs.rm('./.foorc')
-- vim.print(vim.uv.fs_stat('./.foorc'))
-- vim.print(vim.fs.abspath('.foorc'))
-- vim.print(vim.fs.basename('.foorc'))
-- vim.print(vim.fs.dirname('init.lua'))

-- vim.print(vim.glob.to_lpeg('foo/*'):match('foo/bar.lua'))
-- vim.print(vim.glob.to_lpeg('foo/*'):match('bar/bar.lua'))
