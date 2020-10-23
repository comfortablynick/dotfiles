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

function M.only()
  -- Adapted from: https://github.com/numToStr/BufOnly.nvim
  -- Delete non-modifiable buffers like NERDTree
  local del_non_modifiable = true
  local cur = api.nvim_get_current_buf()
  local deleted = 0
  local modified = 0

  -- I think there is a bug in nvim_list_bufs
  -- It doesn't update when bdelete is called
  for _, n in ipairs(api.nvim_list_bufs()) do
    -- To mitigate the above issue I have to check if buffer is loaded or not
    if api.nvim_buf_is_loaded(n) then
      -- If the iter buffer is modified one, then don't do anything
      if api.nvim_buf_get_option(n, "modified") then
        modified = modified + 1
        -- if iter is not equal to current buffer and it is modifiable then delete it
        -- `modifiable` check is needed as it will prevent closing file tree ie. NERD_tree
      elseif n ~= cur and
        (api.nvim_buf_get_option(n, "modifiable") or del_non_modifiable) then
        vim.cmd("bdelete " .. n)
        deleted = deleted + 1
      end
    end
  end

  local status = "BufOnly:"
  if deleted == 0 and modified == 0 then
    status = status .. " no buffers to delete!"
    nvim.warn(status)
  else
    if deleted > 0 then
      status = string.format("%s %d deleted buffer%s", status, deleted,
                             deleted > 1 and "s" or "")
    end
    if modified > 0 then
      status = string.format("%s %d modified buffer%s", status, modified,
                             modified > 1 and "s" or "")
    end
    print(status)
  end
end

return M
