local vim = vim
local api = vim.api
local M = {}

function M.get_usable_width(winnr) -- {{{1
  -- Calculate usable width of window
  -- Takes into account sign column, numberwidth, and foldwidth
  local width = api.nvim_win_get_width(winnr or 0)
  local numberwidth = math.max(vim.wo.numberwidth,
                               string.len(api.nvim_buf_line_count(0)) + 1)
  local numwidth = (vim.wo.number or vim.wo.relativenumber) and numberwidth or 0
  local foldwidth = vim.wo.foldcolumn
  local signwidth = 0
  local signs
  if vim.wo.signcolumn == "yes" then
    signwidth = 2
  elseif vim.wo.signcolumn == "auto" then
    signs = vim.split(vim.fn.execute(("sign place buffer=%d"):format(
                                       vim.fn.bufnr(""))), "\n")
    signwidth = #signs > 3 and 2 or 0
  end
  return width - numwidth - foldwidth - signwidth
end

--  get decoration column with (signs + folding + number)
-- from: https://github.com/pwntester/dotfiles/blob/master/config/nvim/lua/util.lua
function M.get_decoration_width(winnr) -- {{{1
  local decoration_width = 0
  local bufnr = api.nvim_win_get_buf(winnr or 0)
  -- number width
  -- Note: 'numberwidth' is only the minimal width, can be more if...
  local max_number = 0
  if api.nvim_win_get_option(0, "number") then
    -- ...the buffer has many lines.
    max_number = api.nvim_buf_line_count(bufnr)
  elseif api.nvim_win_get_option(0, "relativenumber") then
    -- ...the window width has more digits.
    max_number = vim.fn.winheight(0)
  end
  if max_number > 0 then
    local actual_number_width = string.len(max_number) + 1
    local number_width = api.nvim_win_get_option(0, "numberwidth")
    decoration_width = decoration_width +
                         math.max(number_width, actual_number_width)
  end
  -- signs_
  if vim.fn.has("signs") then
    local signcolumn = api.nvim_win_get_option(0, "signcolumn")
    local signcolumn_width = 2
    if string.startswith(signcolumn, "yes") or
      string.startswith(signcolumn, "auto") then
      decoration_width = decoration_width + signcolumn_width
    end
  end
  -- folding
  if vim.fn.has("folding") then
    local folding_width = api.nvim_win_get_option(0, "foldcolumn")
    decoration_width = decoration_width + folding_width
  end
  return decoration_width
end

-- Adapted From: https://gabrielpoca.com/2019-11-13-a-bit-more-lua-in-your-vim/
function M.new_centered_floating(w, h) -- {{{1
  local cols, lines = (function()
    local ui = api.nvim_list_uis()[1]
    return ui.width, ui.height
  end)()
  local width = w or math.min(cols - 4, math.min(100, cols - 20))
  local height = h or math.min(lines - 4, math.max(20, lines - 10))
  local top = ((lines - h) / 2) - 1
  local left = (cols - w) / 2
  local opts = {
    relative = "editor",
    row = top,
    col = left,
    width = width,
    height = height,
    style = "minimal",
  }
  -- get the editor's max width and height
  -- local ed_width = api.nvim_win_get_width(0)
  -- local ed_height = api.nvim_win_get_height(0)
  -- if not height and not width then
  --     -- window height is 3/4 of the max height, but not more than 30
  --     height = math.min(math.ceil(ed_height * 0.75), 30)
  --     width = math.ceil(ed_width * 0.75)
  -- end
  -- create a new, scratch buffer, for fzf
  local buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_option(buf, "buftype", "nofile")
  -- create a new floating window, centered in the editor
  api.nvim_open_win(buf, true, opts)
end

-- From: https://gist.github.com/norcalli/2a0bc2ab13c12d7c64efc7cdacbb9a4d
function M.float_term(command, scale_pct) -- {{{1
  local width, height = (function()
    if scale_pct then
      local ed_width, ed_height = (function()
        local ui = api.nvim_list_uis()[1]
        return ui.width, ui.height
      end)()
      local width = math.floor(ed_width * scale_pct / 100)
      local height = math.floor(ed_height * scale_pct / 100)
      return width, height
    end
    return nil, nil
  end)()
  M.create_centered_floating(width, height, false)
  api.nvim_call_function("termopen", {command})
end

function M.create_centered_floating(w, h, add_border_lines) -- {{{1
  local cols, lines = (function()
    local ui = api.nvim_list_uis()[1]
    return ui.width, ui.height
  end)()
  local width = w or math.min(cols - 4, math.min(100, cols - 20))
  local height = h or math.min(lines - 4, math.max(20, lines - 10))
  local top = ((lines - height) / 2) - 1
  local left = (cols - width) / 2
  local opts = {
    relative = "editor",
    row = top,
    col = left,
    width = width,
    height = height,
    style = "minimal",
  }
  -- Create border buffer, window
  local border_buf = api.nvim_create_buf(false, true)
  -- Add border lines
  if add_border_lines then
    local border_top = "╭" .. string.rep("─", width - 2) .. "╮"
    local border_mid = "│" .. string.rep(" ", width - 2) .. "│"
    local border_bot = "╰" .. string.rep("─", width - 2) .. "╯"
    local border_lines = {}
    table.insert(border_lines, border_top)
    vim.list_extend(border_lines,
                    vim.split(string.rep(border_mid, height - 2, "\n"), "\n"))
    table.insert(border_lines, border_bot)
    api.nvim_buf_set_lines(border_buf, 0, -1, true, border_lines)
  end
  local border_win = api.nvim_open_win(border_buf, true, opts)
  -- Create text buffer, window
  opts.row = opts.row + 1
  opts.height = opts.height - 2
  opts.col = opts.col + 2
  opts.width = opts.width - 4
  local text_buf = api.nvim_create_buf(false, true)
  local text_win = api.nvim_open_win(text_buf, true, opts)
  -- Set style
  -- api.nvim_win_set_option(border_win, "winhl", "Normal:Floating")
  -- api.nvim_win_set_option(text_win, "winhl", "Normal:Floating")
  -- Set autocmds
  vim.cmd"augroup lua_create_centered_floating"
  vim.cmd"autocmd!"
  vim.cmd(string.format(
            "autocmd WinClosed * ++once if winnr() == %d | :bd! | endif | call nvim_win_close(%d, v:true)",
            text_win, border_win))
  vim.cmd"autocmd WinClosed * ++once doautocmd BufDelete"
  vim.cmd"augroup END"
  return text_buf
end

function M.floating_help(query) -- {{{1
  local buf = M.create_centered_floating(90, nil, false)
  api.nvim_set_current_buf(buf)
  vim.bo.filetype = "help"
  vim.bo.buftype = "help"
  vim.cmd("help " .. query)
end

function M.create_scratch(lines) -- {{{1
  for _, win in ipairs(api.nvim_list_wins()) do
    if vim.fn.getwinvar(win, "scratch") == 1 then api.nvim_win_close(win, 0) end
  end
  vim.cmd"new"
  api.nvim_win_set_var(0, "scratch", 1)
  vim.bo[0].buftype = "nofile"
  vim.bo[0].bufhidden = "wipe"
  vim.bo[0].buflisted = false
  vim.bo[0].swapfile = false
  vim.wo.foldlevel = 99
  api.nvim_buf_set_keymap(0, "n", "q", "<Cmd>bdelete<CR>",
                          {noremap = true, silent = true})
  api.nvim_buf_set_lines(0, 0, -1, 0, lines or {})
end

-- Return module --{{{1
return M
