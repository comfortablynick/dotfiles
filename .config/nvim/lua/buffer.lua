local api = vim.api

local function get_loaded()
  local result = {}
  local buffers = api.nvim_list_bufs()
  for _, buf in ipairs(buffers) do
    if api.nvim_buf_is_loaded(buf) then table.insert(result, buf) end
  end
  return result
end

-- Kill the target buffer (or the current one if 0/nil)
-- TODO: properly handle sending any buffer to target_buf
local function kill(target_buf, should_force)
  if not should_force and vim.bo.modified then
    return api.nvim_err_writeln("Buffer is modified. Force required.")
  end
  local command = "bd"
  if should_force then command = command .. "!" end
  if target_buf == 0 or target_buf == nil then
    target_buf = api.nvim_get_current_buf()
  end
  local buffers = get_loaded()
  if #buffers == 1 then
    api.nvim_command(command)
    return
  end
  local nextbuf
  -- TODO: this part doesn't seem to work
  -- Closes window if buffer <> 0
  for i, buf in ipairs(buffers) do
    if buf == target_buf then
      nextbuf = buffers[(i - 1 + 1) % #buffers + 1]
      break
    end
  end
  api.nvim_set_current_buf(nextbuf)
  api.nvim_command(table.concat({command, target_buf}, " "))
end

-- Built into nvim as of 5/2020
local function hlyank(event, timeout)
  if event.operator ~= "y" or event.regtype == "" then return end
  local timeout = timeout or 500

  local bn = api.nvim_get_current_buf()
  local ns = api.nvim_create_namespace("hlyank")
  api.nvim_buf_clear_namespace(bn, ns, 0, -1)

  local pos1 = api.nvim_call_function("getpos", {"'["})
  local lin1, col1, off1 = pos1[2] - 1, pos1[3] - 1, pos1[4]
  local pos2 = api.nvim_call_function("getpos", {"']"})
  local lin2, col2, off2 = pos2[2] - 1, pos2[3] - (event.inclusive and 0 or 1),
                           pos2[4]
  for l = lin1, lin2 do
    local c1 = (l == lin1 or event.regtype:byte() == 22) and (col1 + off1) or 0
    local c2 = (l == lin2 or event.regtype:byte() == 22) and (col2 + off2) or -1
    api.nvim_buf_add_highlight(bn, ns, "TextYank", l, c1, c2)
  end
  local timer = vim.loop.new_timer()
  timer:start(timeout, 0, vim.schedule_wrap(
                function() api.nvim_buf_clear_namespace(bn, ns, 0, -1) end))
end

return {get_loaded = get_loaded, kill = kill, hlyank = hlyank}
