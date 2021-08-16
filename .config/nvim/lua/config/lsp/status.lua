local installed, lsp_status = pcall(require, "lsp-status")

if not installed then
  local noop = function() end
  return { _init = noop, status = noop }
end

local util = require "util"
local messaging = require "lsp-status/messaging"
local messages = messaging.messages

local config = {
  kind_labels = {},
  current_function = true,
  indicator_separator = " ",
  indicator_errors = "",
  indicator_warnings = "",
  indicator_info = "🛈",
  indicator_hint = "❗",
  indicator_ok = "",
  spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
  status_symbol = " 🇻",
  select_symbol = nil,
}

local function init(_, _config)
  config = vim.tbl_extend("force", config, _config)
end

local aliases = { pyls_ms = "MPLS" }

local function statusline_lsp(bufnr)
  bufnr = bufnr or 0
  if #vim.lsp.buf_get_clients(bufnr) == 0 then
    return ""
  end

  local buf_messages = messages()
  local status_parts = {}

  local msgs = {}
  for _, msg in ipairs(buf_messages) do
    local name = aliases[msg.name] or msg.name
    local contents = ""
    local _ = contents -- get rid of luacheck unused var msg
    if msg.progress then
      contents = msg.title
      if msg.message then
        contents = contents .. " " .. msg.message
      end

      if msg.percentage then
        contents = contents .. " (" .. msg.percentage .. ")"
      end

      if msg.spinner then
        contents = config.spinner_frames[(msg.spinner % #config.spinner_frames) + 1] .. " " .. contents
      end
    elseif msg.status then
      contents = msg.content
      if msg.uri then
        local filename = vim.uri_to_fname(msg.uri)
        filename = vim.fn.fnamemodify(filename, ":~:.")
        local space = math.min(60, math.floor(0.6 * vim.api.nvim_win_get_width(0)))
        if #filename > space then
          filename = util.path.shorten(filename)
        end

        contents = "(" .. filename .. ") " .. contents
      end
    else
      contents = msg.content
    end

    table.insert(msgs, name .. " " .. contents)
  end

  local base_status = vim.trim(table.concat(status_parts, " ") .. " " .. table.concat(msgs, " "))
  if base_status ~= "" then
    return base_status
  end
  return ""
end

return {
  _init = init,
  status = statusline_lsp,
  errors = lsp_status.status_errors,
  warnings = lsp_status.status_warnings,
  info = lsp_status.status_info,
  hints = lsp_status.status_hints,
}
