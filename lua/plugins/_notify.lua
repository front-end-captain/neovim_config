local M = {}

local function notifyLSP()
  local client_notifs = {}
  vim.cmd([[
  highlight NotifyINFOTitle guifg=#79b949
  highlight NotifyINFOIcon guifg=#79b949
]])

  local notify = require("notify")
  local function get_notif_data(client_id, token)
    if not client_notifs[client_id] then
      client_notifs[client_id] = {}
    end

    if not client_notifs[client_id][token] then
      client_notifs[client_id][token] = {}
    end

    return client_notifs[client_id][token]
  end

  local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

  local function update_spinner(client_id, token)
    local notif_data = get_notif_data(client_id, token)

    if notif_data.spinner then
      local new_spinner = (notif_data.spinner + 1) % #spinner_frames
      notif_data.spinner = new_spinner

      notif_data.notification = notify(nil, nil, {
        hide_from_history = true,
        icon = spinner_frames[new_spinner],
        replace = notif_data.notification,
      })

      vim.defer_fn(function()
        update_spinner(client_id, token)
      end, 100)
    end
  end

  local function format_title(title, client_name)
    return client_name .. (#title > 0 and ": " .. title or "")
  end

  local function format_message(message, percentage)
    return (percentage and percentage .. "%\t" or "") .. (message or "")
  end
  local function progress_handler(err, result, ctx, config)
    local client_id = ctx.client_id
    local client_name = vim.lsp.get_client_by_id(client_id).name

    if client_name == "null-ls" then
      return
    end

    local val = result.value
    local task = result.token

    if not val.kind then
      return
    end
    if not task then
      -- Notification missing required token??
      return
    end

    local notif_data = get_notif_data(client_id, result.token)

    if val.kind == "begin" then
      local message = format_message(val.message, val.percentage)

      notif_data.notification = notify(message, "info", {
        title = format_title(val.title, client_name),
        icon = spinner_frames[1],
        timeout = false,
        hide_from_history = false,
      })

      notif_data.spinner = 1
      update_spinner(client_id, result.token)
    elseif val.kind == "report" and notif_data then
      notif_data.notification = notify(format_message(val.message, val.percentage), "info", {
        replace = notif_data.notification,
        hide_from_history = false,
      })
    elseif val.kind == "end" and notif_data then
      notif_data.notification =
        notify(val.message and format_message(val.message) or "Complete", "info", {
          icon = "",
          replace = notif_data.notification,
          timeout = 1000,
        })

      notif_data.spinner = nil
    end
  end

  -- local old_progress_handler = vim.lsp.handlers["$/progress"]
  -- vim.lsp.handlers["$/progress"] = function(err, result, ctx, config)
  -- if old_progress_handler then
  --   old_progress_handler(err, result, ctx, config)
  --   return
  -- end
  --   progress_handler(err, result, ctx, config)
  -- end

  -- FIXME: "$/progress" event trigger twice
  if vim.lsp.handlers["$/progress"] then
    local old_handler = vim.lsp.handlers["$/progress"]
    vim.lsp.handlers["$/progress"] = function(...)
      old_handler(...)
      progress_handler(...)
    end
  else
    vim.lsp.handlers["$/progress"] = progress_handler
  end
end

local spec = {
  "rcarriga/nvim-notify",
  -- event = "Verylazy",
  config = function()
    local notify = require("notify")
    local stages_util = require("notify.stages.util")

    notify.setup({
      -- background_colour = "#121212",
      stages = {
        function(state)
          local next_height = state.message.height + 2
          local next_row = stages_util.available_slot(
            state.open_windows,
            next_height,
            stages_util.DIRECTION.BOTTOM_UP
          )
          if not next_row then
            return nil
          end
          return {
            relative = "editor",
            anchor = "NE",
            width = state.message.width,
            height = state.message.height,
            col = vim.opt.columns:get(),
            row = next_row,
            border = "rounded",
            style = "minimal",
            opacity = 0,
          }
        end,
        function()
          return {
            opacity = { 100 },
            col = { vim.opt.columns:get() },
          }
        end,
        function()
          return {
            col = { vim.opt.columns:get() },
            time = true,
          }
        end,
        function()
          return {
            width = {
              1,
              frequency = 2.5,
              damping = 0.9,
              complete = function(cur_width)
                return cur_width < 3
              end,
            },
            opacity = {
              0,
              frequency = 2,
              complete = function(cur_opacity)
                return cur_opacity <= 4
              end,
            },
            col = { vim.opt.columns:get() },
          }
        end,
      },
    })
    notifyLSP()
  end,
}
table.insert(M, spec)

return M
