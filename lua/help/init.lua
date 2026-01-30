local M = {
  path_separator = package.config:sub(1, 1),
  Diagnostic_Icon = {
    -- ✘  🅴
    error = "🅴",
    -- 🆆 ⚠
    warn = "🆆",
    warning = "🆆",
    -- 🅷  󰃃
    hint = "🅷",
    -- 🅸 
    info = "🅸",
    information = "🅸",
    other = "?",
  },
  Git_Icon = {
    added = " ",
    modified = " ",
    removed = " ",
  },
  Kinds_Icon = {
    Array = " ",
    Boolean = "󰨙 ",
    Class = " ",
    Codeium = "󰘦 ",
    Color = " ",
    Control = " ",
    Collapsed = " ",
    Constant = "󰏿 ",
    Constructor = " ",
    Copilot = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = "󰊕 ",
    Interface = " ",
    Key = " ",
    Keyword = " ",
    Method = "󰊕 ",
    Module = " ",
    Namespace = "󰦮 ",
    Null = " ",
    Number = "󰎠 ",
    Object = " ",
    Operator = " ",
    Package = " ",
    Property = " ",
    Reference = " ",
    Snippet = "󱄽 ",
    String = " ",
    Struct = "󰆼 ",
    Supermaven = " ",
    TabNine = "󰏚 ",
    Text = " ",
    TypeParameter = " ",
    Unit = " ",
    Value = " ",
    Variable = "󰀫 ",
  },
}

function M.norm(path)
  if path:sub(1, 1) == "~" then
    local home = vim.loop.os_homedir()
    if home:sub(-1) == "\\" or home:sub(-1) == "/" then
      home = home:sub(1, -2)
    end
    path = home .. path:sub(2)
  end
  path = path:gsub("\\", "/"):gsub("/+", "/")
  return path:sub(-1) == "/" and path:sub(1, -2) or path
end

function M.is_win()
  return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

function M.realpath(path)
  if path == "" or path == nil then
    return nil
  end
  path = vim.fn.has("win32") == 0 and vim.uv.fs_realpath(path) or path
  return norm(path)
end

function M.cwd()
  return M.realpath(vim.uv.cwd()) or ""
end

function M.get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

---@param plugin string
function M.has(plugin)
  return M.get_plugin(plugin) ~= nil
end

function M.get_host_os_home()
  local os_name = os.getenv("OS")
  local wsl_distro_name = os.getenv("WSL_DISTRO_NAME") or ""
  local is_wsl_ubuntu = string.find(wsl_distro_name, "Ubuntu")

  if is_wsl_ubuntu then
    return os.getenv("WINDOWS_HOME") or ""
  end

  if os_name == "Windows_NT" then
    return os.getenv("HOMEDRIVE") .. os.getenv("HOMEPATH")
  end

  return os.getenv("HOME")
end

---@param path string
---@return string
function M.path_add_trailing(path)
  if path:sub(-1) == M.path_separator then
    return path
  end

  return path .. M.path_separator
end

--- Get a path relative to another path.
---@param path string
---@param relative_to string|nil
---@return string
function M.path_relative(path, relative_to)
  if relative_to == nil then
    return path
  end

  local _, r = path:find(M.path_add_trailing(relative_to), 1, true)
  local p = path
  if r then
    -- take the relative path starting after '/'
    -- if somehow given a completely matching path,
    -- returns ""
    p = path:sub(r + 1)
  end
  return p
end

function M.findKeywordInCurrentFolder(state)
  local node = state.tree:get_node()

  if node.type == "directory" then
    local lga = require("telescope").extensions.live_grep_args
    local relative = M.path_relative(node:get_id(), vim.fn.getcwd())
    local default_text = vim.fn.getreg('"')

    default_text = string.gsub(default_text, "[\r\n]+", "")

    lga.live_grep_args({
      theme = "ivy",
      results_title = relative .. "/",
      cwd = node:get_id(),
      default_text = default_text or "",
    })
  end
end

function M.fold_virt_text_handler(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (" 󰁂 %d "):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtText
end

M.CREATE_UNDO = vim.api.nvim_replace_termcodes("<c-G>u", true, true, true)
function M.create_undo()
  if vim.api.nvim_get_mode().mode == "i" then
    vim.api.nvim_feedkeys(M.CREATE_UNDO, "n", false)
  end
end

return M
