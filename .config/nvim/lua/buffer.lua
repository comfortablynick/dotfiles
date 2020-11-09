local api = vim.api
local M = {}

-- Kill the target buffer (or the current one if 0/nil)
-- TODO: properly handle sending any buffer to target_buf
function M.kill(target_buf, should_force)
  if not should_force and api.nvim_buf_get_option(target_buf, "modified") then
    return api.nvim_err_writeln("Buffer is modified. Force required.")
  end
  local delete_opts = {force = should_force == nil and false or should_force}
  if target_buf == 0 or target_buf == nil then
    target_buf = api.nvim_get_current_buf()
  end
  -- local buffers = vim.tbl_filter(api.nvim_buf_is_loaded, api.nvim_list_bufs())
  -- if #buffers == 1 then
  --   api.nvim_buf_delete(buffers[1], delete_opts)
  --   return
  -- end
  local nextbuf
  -- for i = #buffers, 1, -1 do
  --   local buf = buffers[i]

  -- for i, buf in ipairs(buffers) do
  --   if buf == target_buf then
  --     -- TODO: what does this do?
  --     nextbuf = buffers[i % #buffers + 1]
  --     break
  --   end
  -- end
  local windows = api.nvim_list_wins()
  for i = #windows, 1, -1 do
    local win = windows[i]
    if api.nvim_win_get_buf(win) ~= target_buf then goto continue end
    api.nvim_set_current_win(win)
    local alt_buf = vim.fn.bufnr("#")
    if alt_buf > 0 and api.nvim_buf_is_loaded(alt_buf) then
      vim.cmd[[buffer #]]
    else
      vim.cmd[[bprevious]]
    end
    if api.nvim_get_current_buf() ~= target_buf then goto continue end
    -- Create new buffer before deleting target
    nextbuf = api.nvim_create_buf(false, false)
    ::continue::
  end
  api.nvim_set_current_buf(nextbuf)
  api.nvim_buf_delete(target_buf, delete_opts)
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
    if n == cur then goto continue end
    -- To mitigate the above issue I have to check if buffer is loaded or not
    if api.nvim_buf_is_loaded(n) then
      -- If the iter buffer is modified one, then don't do anything
      if api.nvim_buf_get_option(n, "modified") then
        modified = modified + 1
        -- if it is modifiable then delete it
        -- `modifiable` check is needed as it will prevent closing file tree ie. NERD_tree
        -- elseif n ~= cur and
      elseif (api.nvim_buf_get_option(n, "modifiable") or del_non_modifiable) then
        api.nvim_buf_delete(n, {force = false})
        deleted = deleted + 1
      end
    end
    ::continue::
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
