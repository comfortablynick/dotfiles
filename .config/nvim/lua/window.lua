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
    if vim.startswith(signcolumn, "yes") or
      vim.startswith(signcolumn, "auto") then
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

function M.float_term(command, scale_pct) -- {{{1
  -- From: https://gist.github.com/norcalli/2a0bc2ab13c12d7c64efc7cdacbb9a4d
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
  M.create_centered_floating{width = width, height = height, border = false}
  api.nvim_call_function("termopen", {command})
  vim.cmd"startinsert"
end

function M.create_centered_floating(options) -- {{{1
  -- options
  -- =======
  -- `width`, `height` Integer (absolute) or float (ratio of window size)
  -- `border` Add border lines
  -- `hl` Highlight to use with NormalFloat: (default is "Pmenu", based on fzf)
  options = options or {}
  vim.validate{options = {options, "table", true}}
  vim.validate{
    width = {
      options.width,
      function(v) return not v or v > 0 end,
      "greater than 0",
      true,
    },
    height = {
      options.height,
      function(v) return not v or v > 0 end,
      "greater than 0",
      true,
    },
    border = {options.border, "boolean", true},
    hl = {options.hl, "string", true},
  }
  local cols, lines = (function()
    local ui = api.nvim_list_uis()[1]
    return ui.width, ui.height
  end)()
  local width = (function()
    local usable_w = M.get_usable_width(0)
    if not options.width or options.width < 1 then
      options.width = math.min(math.floor((options.width or 0.6) * usable_w),
                               usable_w)
    end
    return options.width
  end)()
  local height = (function()
    if not options.height or options.height < 1 then
      options.height = math.min(math.floor((options.height or 0.9) * lines),
                                lines)
    end
    return options.height
  end)()
  local top = ((lines - height) / 2) - 1
  local left = (cols - width) / 2
  local win_opts = {
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
  if options.border then
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
  local border_win = api.nvim_open_win(border_buf, true, win_opts)
  -- Create text buffer, window
  win_opts.row = win_opts.row + 1
  win_opts.height = win_opts.height - 2
  win_opts.col = win_opts.col + 2
  win_opts.width = win_opts.width - 4
  local text_buf = api.nvim_create_buf(false, true)
  local text_win = api.nvim_open_win(text_buf, true, win_opts)
  -- Set style
  options.hl = options.hl or "Pmenu"
  api.nvim_win_set_option(border_win, "winhl", "NormalFloat:" .. options.hl)
  api.nvim_win_set_option(text_win, "winhl", "NormalFloat:" .. options.hl)
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
  local buf = M.create_centered_floating{width = 90, border = true}
  api.nvim_set_current_buf(buf)
  vim.bo.filetype = "help"
  vim.bo.buftype = "help"
  vim.cmd("help " .. query)
  api.nvim_buf_set_keymap(buf, "n", "<C-c>",
                          ":call buffer#quick_close()<CR>",
                          {silent = true, noremap = true})
end

function M.create_scratch(lines, mods) -- {{{1
  for _, win in ipairs(api.nvim_list_wins()) do
    if pcall(api.nvim_win_get_var, win, "scratch") then api.nvim_win_close(win, 0) end
  end
  vim.cmd((mods or "").." new")
  vim.w.scratch = 1
  vim.wo.list = false
  vim.wo.relativenumber = false
  local buf = api.nvim_win_get_buf(0)
  vim.bo.buflisted = false
  vim.bo.swapfile = false
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "delete"
  api.nvim_buf_set_keymap(buf, "n", "q", "<Cmd>bdelete!<CR>",
                          {noremap = true, silent = true})
  api.nvim_buf_set_lines(buf, 0, -1, 0, lines or {})
end

return M
