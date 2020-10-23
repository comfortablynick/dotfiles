local api = vim.api
local M = {}

function M.get_loaded()
  local result = {}
  local buffers = api.nvim_list_bufs()
  for _, buf in ipairs(buffers) do
    if api.nvim_buf_is_loaded(buf) then table.insert(result, buf) end
  end
  return result
end

-- Kill the target buffer (or the current one if 0/nil)
-- TODO: properly handle sending any buffer to target_buf
function M.kill(target_buf, should_force)
  if not should_force and vim.bo.modified then
    return api.nvim_err_writeln("Buffer is modified. Force required.")
  end
  local command = "bd"
  if should_force then command = command .. "!" end
  if target_buf == 0 or target_buf == nil then
    target_buf = api.nvim_get_current_buf()
  end
  local buffers = M.get_loaded()
  if #buffers == 1 then
    vim.cmd(command)
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
  vim.cmd(table.concat({command, target_buf}, " "))
end

return M
