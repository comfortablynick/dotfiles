local api = vim.api
local M = {}

function M.get_usable_width(winnr) -- {{{1
  -- Calculate usable width of window
  -- Takes into account sign column, numberwidth, and foldwidth
  local width = api.nvim_win_get_width(winnr or 0)
  local numberwidth = math.max(vim.wo.numberwidth, string.len(api.nvim_buf_line_count(0)) + 1)
  local numwidth = (vim.wo.number or vim.wo.relativenumber) and numberwidth or 0
  local foldwidth = vim.wo.foldcolumn
  local signwidth = 0
  local signs
  if vim.wo.signcolumn == "yes" then
    signwidth = 2
  elseif vim.wo.signcolumn == "auto" then
    signs = vim.split(vim.fn.execute(("sign place buffer=%d"):format(vim.fn.bufnr "")), "\n")
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
    decoration_width = decoration_width + math.max(number_width, actual_number_width)
  end
  -- signs_
  if vim.fn.has "signs" then
    local signcolumn = api.nvim_win_get_option(0, "signcolumn")
    local signcolumn_width = 2
    if vim.startswith(signcolumn, "yes") or vim.startswith(signcolumn, "auto") then
      decoration_width = decoration_width + signcolumn_width
    end
  end
  -- folding
  if vim.fn.has "folding" then
    local folding_width = api.nvim_win_get_option(0, "foldcolumn")
    decoration_width = decoration_width + folding_width
  end
  return decoration_width
end

function M.float_term(command, scale_pct, border, title) -- {{{1
  -- From: https://gist.github.com/norcalli/2a0bc2ab13c12d7c64efc7cdacbb9a4d
  vim.validate {
    scale_pct = {
      scale_pct,
      function(v)
        return v == nil or (v > 0 and v <= 1)
      end,
      "nil or between 0 and 1",
      true,
    },
    border = { border, "b", true },
    title = { title, "s", true },
  }

  -- local scale = string.format("%s%%", scale_pct * 100)
  local width, height
  do
    -- calculate based on pct or leave it as nil
    if scale_pct ~= nil then
      local ui = api.nvim_list_uis()[1]
      width = math.floor(ui.width * scale_pct)
      height = math.floor(ui.height * scale_pct)
    end
  end
  return M.create_centered_floating {
    width = width,
    height = height,
    border = border or false,
    fn = function()
      vim.fn.termopen(command)
      vim.cmd "startinsert"
    end,
  }
end

function M.create_centered_floating(options) -- {{{1
  -- options
  -- =======
  -- `width`, `height` Integer (absolute) or float (ratio of window size)
  -- `border` Add border lines
  -- `fn` Function to call in context of window (before exit keymaps are set)
  -- `hl` Highlight to use with NormalFloat: (default is "Pmenu", based on fzf)
  options = options or {}
  vim.validate { options = { options, "table", true } }
  vim.validate {
    width = {
      options.width,
      function(v)
        return v == nil or v > 0
      end,
      "nil or greater than 0",
    },
    height = {
      options.height,
      function(v)
        return v == nil or v > 0
      end,
      "nil or greater than 0",
    },
    border = { options.border, "boolean", true },
    hl = { options.hl, "string", true },
    winblend = {
      options.winblend,
      function(v)
        return v == nil or (v >= 1 and v <= 100)
      end,
      "between 1 and 100",
    },
    fn = { options.fn, "function", true },
  }
  local cols, lines
  do
    local ui = api.nvim_list_uis()[1]
    cols = ui.width
    lines = ui.height
  end
  local width, height = options.width, options.height
  do
    local usable_w = M.get_usable_width(0)
    if not options.width or options.width < 1 then
      width = math.min(math.floor((options.width or 0.6) * usable_w), usable_w)
    end
    if not options.height or options.height < 1 then
      height = math.min(math.floor((options.height or 0.9) * lines), lines)
    end
  end
  local top = ((lines - height) / 2) - 1
  local left = (cols - width) / 2
  local win_opts = {
    relative = "editor",
    row = top,
    col = left,
    width = width,
    height = height,
    style = "minimal",
    border = options.border and "rounded" or "none",
  }

  -- Create text buffer, window
  win_opts.row = win_opts.row + 1
  win_opts.height = win_opts.height - 2
  win_opts.col = win_opts.col + 2
  win_opts.width = win_opts.width - 4
  local text_buf = api.nvim_create_buf(false, true)
  local text_win = api.nvim_open_win(text_buf, true, win_opts)

  -- Set style
  options.hl = options.hl or "Pmenu"
  vim.wo[text_win].winhl = "NormalFloat:" .. options.hl
  if options.winblend ~= nil then
    vim.wo[text_win].winblend = options.winblend
  end

  -- Call fn if supplied
  if options.fn ~= nil then
    options.fn()
  end

  local exit_keys = { "<C-c>", "q", "<Esc>" }
  for _, key in ipairs(exit_keys) do
    api.nvim_buf_set_keymap(
      text_buf,
      "n",
      key,
      ("<Cmd>lua vim.api.nvim_win_close(%d, true)<CR>"):format(text_win),
      { noremap = true, nowait = true }
    )
  end
  api.nvim_buf_set_option(text_buf, "bufhidden", "wipe")
  return text_buf
end

-- function M.percentage_range_window() --{{{1
local default_win_opts = { winblend = 15, percentage = 0.9 }

local function default_opts(options)
  options = vim.tbl_extend("force", default_win_opts, options)

  local width = math.floor(vim.o.columns * options.percentage)
  local height = math.floor(vim.o.lines * options.percentage)

  local top = math.floor(((vim.o.lines - height) / 2) - 1)
  local left = math.floor((vim.o.columns - width) / 2)

  local opts = {
    relative = "editor",
    row = top,
    col = left,
    width = width,
    height = height,
    style = "minimal",
  }

  return opts
end

--- Create window that takes up certain percentags of the current screen.
---
--- Works regardless of current buffers, tabs, splits, etc.
-- @param col_range number | Table:
--                  If number, then center the window taking up this percentage of the screen.
--                  If table, first index should be start, second_index should be end
-- @param row_range number | Table:
--                  If number, then center the window taking up this percentage of the screen.
--                  If table, first index should be start, second_index should be end
function M.percentage_range_window(col_range, row_range, options)
  options = vim.tbl_extend("force", default_win_opts, options or {})

  local win_opts = default_opts(options)
  win_opts.relative = "editor"

  local height_percentage, row_start_percentage
  if type(row_range) == "number" then
    assert(row_range <= 1)
    assert(row_range > 0)
    height_percentage = row_range
    row_start_percentage = (1 - height_percentage) / 2
  elseif type(row_range) == "table" then
    height_percentage = row_range[2] - row_range[1]
    row_start_percentage = row_range[1]
  else
    error(string.format("Invalid type for 'row_range': %p", row_range))
  end

  win_opts.height = math.ceil(vim.o.lines * height_percentage)
  win_opts.row = math.ceil(vim.o.lines * row_start_percentage)

  local width_percentage, col_start_percentage
  if type(col_range) == "number" then
    assert(col_range <= 1)
    assert(col_range > 0)
    width_percentage = col_range
    col_start_percentage = (1 - width_percentage) / 2
  elseif type(col_range) == "table" then
    width_percentage = col_range[2] - col_range[1]
    col_start_percentage = col_range[1]
  else
    error(string.format("Invalid type for 'col_range': %p", col_range))
  end

  do
    local ui = api.nvim_list_uis()[1]
    win_opts.col = math.floor(ui.width * col_start_percentage)
    win_opts.width = math.floor(ui.width * width_percentage)
  end
  local bufnr = options.bufnr or api.nvim_create_buf(false, true)
  local win_id = api.nvim_open_win(bufnr, true, win_opts)
  api.nvim_win_set_buf(win_id, bufnr)

  vim.wo[win_id].cursorcolumn = false
  vim.wo[win_id].winblend = options.winblend

  return { bufnr = bufnr, win_id = win_id }
end

function M.floating_help(query) -- {{{1
  return M.create_centered_floating {
    width = 90,
    border = true,
    fn = function()
      vim.bo.filetype = "help"
      vim.bo.buftype = "help"
      vim.cmd("help " .. query)
    end,
  }
end

function M.create_scratch(lines, mods, replace_existing) -- {{{1
  if replace_existing then
    for _, win in ipairs(api.nvim_list_wins()) do
      if pcall(api.nvim_win_get_var, win, "scratch") then
        api.nvim_win_close(win, 0)
      end
    end
  end
  vim.cmd((mods or "") .. " new")
  vim.w.scratch = 1
  vim.wo.list = false
  vim.wo.relativenumber = false
  local buf = api.nvim_win_get_buf(0)
  vim.bo.buflisted = false
  vim.bo.swapfile = false
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "delete"
  api.nvim_buf_set_keymap(buf, "n", "q", "<Cmd>bdelete!<CR>", { noremap = true, silent = true })
  api.nvim_buf_set_lines(buf, 0, -1, 0, lines or {})
end

return M
