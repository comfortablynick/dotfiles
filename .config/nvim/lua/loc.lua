local api = vim.api
local M = {}

local no_diagnostics_msg =
  "echohl WarningMsg | echo 'No diagnostics found' | echohl None"

local function get_cursor(winnr)
  local cursor = api.nvim_win_get_cursor(winnr or 0)
  local row = cursor[1]
  local col = cursor[2] + 1 -- api has 0 index for col
  return row, col
end

function M.get_next_loc()
  M.location = vim.fn.getloclist(0)
  if #M.location <= 0 then return -1 end

  local cur_row, cur_col = get_cursor()

  for i, v in ipairs(M.location) do
    if v.lnum > cur_row or (v.lnum == cur_row and v.col > cur_col + 1) then
      return i
    end
  end
  return -1
end

function M.get_prev_loc()
  M.location = vim.fn.getloclist(0)
  if #M.location == 0 then return -1 end

  local cur_row, cur_col = get_cursor()

  for i, v in ipairs(M.location) do
    local is_next = v.lnum > cur_row or (v.lnum == cur_row and v.col > cur_col)
    local is_prev = v.lnum == cur_row and cur_col > v.col
    local same_pos = v.lnum == cur_row and v.col == cur_col
    if is_next or same_pos then
      return i - 1
    elseif is_prev then
      return i
    end
  end
  return #M.location
end

local function jumpToLocation(i)
  if i >= 1 and i <= #M.location then
    vim.cmd("silent! ll" .. i)
    M.openLineDiagnostics()
  end
end

-- Jump to next location
-- Show warning text when no next location is available
function M.jumpNextLocation()
  local i = M.get_next_loc()
  if i >= 1 then
    jumpToLocation(i)
  else
    vim.cmd("echohl WarningMsg | echo 'no next diagnostic' | echohl None")
  end
end

function M.jumpPrevLocation()
  local i = M.get_prev_loc()
  if i >= 1 then
    jumpToLocation(i)
  else
    vim.cmd("echohl WarningMsg | echo 'no prev diagnostic' | echohl None")
  end
end

function M.jumpNextLocationCycle()
  local next_i = M.get_next_loc()
  if next_i > 0 then
    jumpToLocation(next_i)
  elseif M.get_prev_loc() >= 0 then
    jumpToLocation(1)
  else
    return vim.cmd(no_diagnostics_msg)
  end
end

function M.jumpPrevLocationCycle()
  local prev_i = M.get_prev_loc()
  if prev_i > 0 then
    jumpToLocation(prev_i)
  elseif M.get_next_loc() >= 0 then
    jumpToLocation(#M.location)
  else
    return vim.cmd(no_diagnostics_msg)
  end
end

function M.jumpFirstLocation()
  M.location = vim.fn.getloclist(0)
  jumpToLocation(1)
  if #M.location == 0 then return vim.cmd(no_diagnostics_msg) end
end

function M.jumpLastLocation()
  M.location = vim.fn.getloclist(0)
  jumpToLocation(#M.location)
  if #M.location == 0 then return vim.cmd(no_diagnostics_msg) end
end

-- Open line diagnostics when jump
-- Don't do anything if diagnostic_auto_popup_while_jump == 0
-- NOTE need to delay a certain amount of time to show correctly
function M.openLineDiagnostics()
  if vim.g.diagnostic_auto_popup_while_jump == 1 then
    vim.defer_fn(function() vim.lsp.util.show_line_diagnostics() end, 100)
  end
end

-- Open location window and jump back to current window
function M.openDiagnostics()
  vim.cmd[[lopen]]
  vim.cmd[[wincmd p]]
end

return M
