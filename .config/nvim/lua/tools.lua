local api = vim.api
local uv = vim.loop
local util = require "util"
local win = require "window"
local M = {}

function M.lf_select_current_file()
  local filename = api.nvim_buf_get_name(0)
  local cmd = "FloatermNew lf"
  if uv.fs_stat(filename) ~= nil then
    cmd = cmd .. (" -command 'select %s'"):format(filename)
  end
  vim.cmd(cmd)
end

local qf_open = function(max_size)
  if not max_size then
    max_size = 0
  end
  local vim_qf_size = vim.g.quickfix_size or 20
  local items = #vim.fn.getqflist()
  if items > 0 then
    local qf_size = math.min(items, (max_size > 0) and max_size or vim_qf_size)
    vim.cmd(("copen %d | wincmd k"):format(qf_size))
  end
  return items
end

function M.async_grep(cmd_args) -- Async grep using &grepprg
  vim.validate { cmd_args = { cmd_args, "table" } }
  local grep = vim.o.grepprg
  local grep_args = vim.split(grep, " ")
  local grep_prg = table.remove(grep_args, 1)
  vim.list_extend(grep_args, cmd_args)
  local qf_title = ("[AsyncGrep] %s %s"):format(grep_prg, table.concat(grep_args, " "))

  local on_read = vim.schedule_wrap(function(err, data)
    assert(not err, err)
    vim.fn.setqflist({}, "a", { efm = vim.o.grepformat, title = qf_title, lines = data })
  end)

  local on_exit = vim.schedule_wrap(function()
    if not qf_open(20) then
      nvim.warn "grep: no results found"
    end
  end)

  vim.fn.setqflist({}, " ", { title = qf_title })
  M.spawn { cmd = grep_prg, args = grep_args, on_read = on_read, on_exit = on_exit }
end

function M.scandir(path)
  local d = uv.fs_scandir(vim.fn.expand(path))
  local out = {}
  while true do
    local name, type = uv.fs_scandir_next(d)
    if not name then
      break
    end
    table.insert(out, { name, type })
  end
  print(vim.inspect(out))
end

function M.readdir(path)
  local handle = uv.fs_opendir(vim.fn.expand(path), nil, 10)
  local out = {}
  while true do
    local entry = uv.fs_readdir(handle)
    if not entry then
      break
    end
    -- use list_extend because readdir
    -- outputs table with each iteration
    vim.list_extend(out, entry)
  end
  print(vim.inspect(out))
  uv.fs_closedir(handle)
end

function M.set_executable(file) -- `chmod +x` using libuv (or just use vim-scriptease)
  file = file or api.nvim_buf_get_name(0)
  local get_perm_str = function(dec_mode)
    local mode = string.format("%o", dec_mode)
    local perms = {
      [0] = "---", -- No access.
      [1] = "--x", -- Execute access.
      [2] = "-w-", -- Write access.
      [3] = "-wx", -- Write and execute access.
      [4] = "r--", -- Read access.
      [5] = "r-x", -- Read and execute access.
      [6] = "rw-", -- Read and write access.
      [7] = "rwx", -- Read, write and execute access.
    }
    local chars = {}
    for i = 4, #mode do
      table.insert(chars, perms[tonumber(mode:sub(i, i))])
    end
    return table.concat(chars)
  end
  local stat = uv.fs_stat(file)
  if stat == nil then
    api.nvim_err_writeln(string.format("File '%s' does not exist!", file))
    return
  end
  local orig_mode = stat.mode
  local orig_mode_oct = string.sub(string.format("%o", orig_mode), 4)
  M.spawn {
    cmd = "chmod",
    args = { "u+x", file },
    on_exit = function()
      local new_mode = uv.fs_stat(file).mode
      local new_mode_oct = string.sub(string.format("%o", new_mode), 4)
      local new_mode_str = get_perm_str(new_mode)
      if orig_mode ~= new_mode then
        print(
          ("Permissions changed: %s (%s) -> %s (%s)"):format(
            get_perm_str(orig_mode),
            orig_mode_oct,
            new_mode_str,
            new_mode_oct
          )
        )
      else
        print(("Permissions not changed: %s (%s)"):format(new_mode_str, new_mode_oct))
      end
    end,
  }
end

function M.get_history_clap()
  local hist_ct = vim.fn.histnr "cmd"
  local hist = {}
  for i = 1, hist_ct do
    table.insert(hist, string.format("%" .. #tostring(hist_ct) .. "d, %s", hist_ct - i, vim.fn.histget("cmd", -i)))
  end
  return hist
end

function M.get_history_fzf()
  local hist_ct = vim.fn.histnr "cmd"
  local hist = {}
  -- for i = 1, hist_ct do
  for i = hist_ct, 1, -1 do
    hist[string.format("%" .. #tostring(hist_ct) .. "d", hist_ct - i)] = vim.fn.histget("cmd", -i)
  end
  return hist
end

function M.get_history()
  local results = {}
  for k, v in string.gmatch(vim.fn.execute "history :", "(%d+)%s*([^\n]+)\n") do
    results[k] = "\x1b[38;5;205m" .. v .. "\x1b[m"
  end
  -- Using iterators and luafun
  -- fn.each(function(k, v) results[k] = "\x1b[38;5;205m" .. v .. "\x1b[m" end,
  --         fn.dup(vim.fn.execute("history :"):gmatch("(%d+)%s*([^\n]+)\n")))
  return results
end

function M.r(cmd) -- Test simpler impl by updating qflist in callback
  local args = vim.split(cmd, " ")
  local bin = table.remove(args, 1)
  local on_read = vim.schedule_wrap(function(err, data)
    assert(not err, err)
    vim.fn.setqflist({}, "a", { title = "Command: " .. cmd, lines = data })
  end)
  local on_exit = vim.schedule_wrap(qf_open)
  vim.fn.setqflist({}, " ", { title = "Command: " .. cmd })
  M.spawn { cmd = bin, args = args, on_read = on_read, on_exit = on_exit }
end

-- @param o table
-- @field o.cmd     : Command string
-- @field o.args    : List of args to pass to cmd
-- @field o.env     : Array of env vars to set for cmd
-- @field o.cwd     : String of working directory
-- @field o.stdin   : String to pass to stdin
-- @field o.on_read : Used for stdout and stderr (err, data)
-- @field o.on_exit : Called on exit (code)
function M.spawn(o) -- Run simple commands and output stdout/stderr
  local stdin = uv.new_pipe(false)
  local stdout = uv.new_pipe(false)
  local stderr = uv.new_pipe(false)
  local options = { stdio = { stdin, stdout, stderr }, args = o.args, env = o.env, cwd = o.cwd }
  local process

  local on_exit = function(code)
    for _, handle in ipairs { stdout, stderr } do
      handle:read_stop()
      handle:close()
    end
    process:close()
    if o.on_exit ~= nil then
      o.on_exit(code)
    end
  end

  process = uv.spawn(o.cmd, options, on_exit)

  local on_read = function(err, data)
    if not data then
      return
    end
    local lines = vim.split(vim.trim(data), "\n")
    if o.on_read ~= nil then
      o.on_read(err, lines)
    end
  end

  for _, io in ipairs { stdout, stderr } do
    io:read_start(on_read)
  end

  if o.stdin then
    stdin:write(o.stdin, function(err)
      assert(not err, err)
      stdin:shutdown(function(error)
        assert(not error, error)
      end)
    end)
  end
end

-- @param o table
-- @field o.cmd  : Vim ex command
-- @field o.mods : Mods for scratch window
function M.redir(o) -- Redirect command output to scratch window
  local lines = vim.split(api.nvim_exec(o.cmd, true), "\n")
  win.create_scratch(lines, o.mods or "", o.bang)
end

-- @param o table
-- @field o.cmd string     : Command to run (will be split into args)
-- @field o.cwd string     : Current working directory (will be expanded by vim)
-- @field o.mods string    : Mods for scratch window
-- @field o.autoclose bool : Close scratch window if command returns 0
function M.sh(o) -- Spawn a new job and put output to scratch window
  win.create_scratch({}, o.mods or "20")
  vim.wo.number = false
  local stdin = uv.new_pipe(false)
  local stdout = uv.new_pipe(false)
  local stderr = uv.new_pipe(false)
  local options = { stdio = { stdin, stdout, stderr } }
  local handle, lines
  local output_buf = ""

  local winnr = api.nvim_get_current_win()
  local bufnr = api.nvim_get_current_buf()
  -- Return to previous window
  vim.cmd [[wincmd p]]

  if o.cwd ~= nil then
    options.cwd = vim.fn.expand(o.cwd)
    assert(util.path.is_dir(options.cwd), "error: Invalid directory: " .. options.cwd)
  end

  local update_chunk = vim.schedule_wrap(function(err, chunk)
    assert(not err, err)
    if chunk then
      output_buf = output_buf .. chunk
      lines = vim.split(output_buf, "\n", true)
      for i, line in ipairs(lines) do
        -- Scrub ANSI color codes
        lines[i] = line:gsub("\27%[[0-9;mK]+", "")
      end
      vim.bo[bufnr].modifiable = true
      api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
      vim.bo[bufnr].modifiable = false
      vim.bo[bufnr].modified = false
      if api.nvim_win_is_valid(winnr) then
        api.nvim_win_set_cursor(winnr, { #lines, 0 })
      end
    end
  end)

  local on_exit = vim.schedule_wrap(function(code, signal)
    for _, io in ipairs { stdin, stdout, stderr } do
      io:read_stop()
      io:close()
    end
    handle:close()
    vim.cmd [[au CursorMoved,CursorMovedI * ++once lua vim.defer_fn(function() vim.g.job_status = nil end, 10000)]]
    if code == 0 and signal == 0 then
      vim.g.job_status = "Success"
      if o.autoclose then
        vim.schedule(api.nvim_buf_delete(bufnr, { force = true }))
        return
      end
    else
      vim.g.job_status = "Failed"
    end
    -- Trim buffer if needed
    local trimmed_buf = vim.trim(output_buf)
    if trimmed_buf ~= output_buf then
      output_buf = ""
      update_chunk(nil, trimmed_buf)
    end
    update_chunk(nil, string.format("\n\n[Process exited with code %d / signal %d]", code, signal))
    -- Reduce scratch buffer size if possible
    if api.nvim_win_get_height(winnr) > #lines then
      api.nvim_win_set_height(winnr, #lines)
    end
  end)
  handle = uv.spawn(vim.o.shell, options, on_exit)

  -- If the buffer closes, then kill our process.
  api.nvim_buf_attach(bufnr, false, {
    on_detach = function()
      if not handle:is_closing() then
        handle:kill(15)
      end
    end,
  })

  for _, io in ipairs { stdout, stderr } do
    io:read_start(update_chunk)
  end
  stdin:write(o.cmd)
  stdin:write "\n"
  stdin:shutdown()
end

-- @param o table
-- @field o.cmd string     : Command to run (passed to &shell)
-- @field o.cwd string     : Current working directory (will be expanded by vim)
-- @field o.mods string    : Mods for scratch window
-- @field o.autoclose bool : Close scratch window if command returns 0 (default true)
function M.term_run(o) -- Execute script in terminal buffer
  local options = {}
  if o.cwd then
    o.cwd = vim.fn.expand(o.cwd)
    assert(o.cwd and util.path.is_dir(o.cwd), "sh: Invalid directory")
    options.cwd = o.cwd
  end
  -- switching to insert mode makes the buffer scroll as new output is added
  -- and makes it easy and intuitive to cancel the operation with Ctrl-C
  vim.cmd((o.mods or "20") .. "new | startinsert")
  local bufnr = api.nvim_get_current_buf()
  local shell = vim.o.shell or "sh"
  local on_exit = function(_, code)
    if code == 0 then
      vim.g.job_status = "Success"
      if o.autoclose == (nil or 1 or true) then
        api.nvim_buf_delete(bufnr, { force = true })
      end
    else
      vim.g.job_status = "Failed"
    end
    vim.defer_fn(function()
      vim.cmd [[autocmd CursorMoved,CursorMovedI * ++once unlet! g:job_status]]
    end, 10000)
  end
  options.on_exit = on_exit
  vim.fn.termopen({ shell, "-c", o.cmd }, options)
  -- TODO: adjust size of terminal down if lines < window
  vim.g.job_status = "Running"
end

local parse_raw_args = function(...)
  -- TODO: differentiate between shell command params and vim command args, e.g. `--`
  local parsed = { cmd = {} }
  for _, arg in ipairs { ... } do
    local k, v = arg:match "-*([^&=%s]+)=([^&=%s]+)"
    if k ~= nil then
      parsed[k] = v
    else
      table.insert(parsed.cmd, arg)
    end
  end
  parsed.cmd = table.concat(parsed.cmd, " ")
  return parsed
end

function M.term_run_cmd(...) -- Parse command and args into M.term_run()
  local parsed = parse_raw_args(...)
  M.term_run(parsed)
end

function M.async_run(cmd, bang) -- Simple lua impl of AsyncRun
  local results = {}
  local args = vim.split(cmd, " ")
  local command = table.remove(args, 1)
  local on_read = vim.schedule_wrap(function(err, lines)
    assert(not err, err)
    vim.fn.setqflist({}, "a", { title = cmd, lines = lines })
  end)
  local on_exit = vim.schedule_wrap(function(code)
    if code ~= 0 then
      vim.g.job_status = "Failed"
    else
      vim.g.job_status = "Success"
    end
    if bang then
      do
        local res = results[1]
        if res ~= nil then
          print(res)
        end
      end
    else
      qf_open()
    end
    vim.defer_fn(function()
      vim.g.job_status = nil
    end, 10000)
  end)
  M.spawn { cmd = command, args = args, on_read = on_read, on_exit = on_exit }
  if vim.fn.getqflist({ title = "" }).title == cmd then
    vim.fn.setqflist({}, "r")
  else
    vim.fn.setqflist({}, " ")
  end
  vim.g.job_status = "Running"
end

function M.mru_files(n)
  local fn = require "fun"
  if n ~= nil then
    n = tonumber(n)
  end
  local exclude_patterns = {
    "nvim/.*/doc/.*%.txt", -- nvim help files (approximately)
    ".git", -- git dirs
  }
  local file_filter = function(file)
    local is_excluded = function(s)
      return file:find(s) ~= nil
    end
    return not fn.iter(exclude_patterns):any(is_excluded) and util.path.is_file(file)
  end
  local shorten_path = function(s)
    return s:gsub(uv.os_homedir(), "~")
  end
  return fn.iter(vim.v.oldfiles):filter(file_filter):map(shorten_path):take_n(n or 999):totable()
end

function M.get_maps(mode, bufnr, width) -- luacheck: no unused
  -- `nvim[_buf]_get_keymap`
  -- ================
  -- buffer  (num)
  -- expr    (num)
  -- lhs     (str)
  -- mode    (str)
  -- noremap (num)
  -- nowait  (num)
  -- rhs     (str)
  -- script  (num)
  -- sid     (num)
  -- silent  (num)
  --
  -- {
  --   buffer = 0,
  --   expr = 0,
  --   lhs = "<Tab>",
  --   lnum = 73,
  --   mode = "n",
  --   noremap = 1,
  --   nowait = 0,
  --   rhs = ":bnext<CR>",
  --   script = 0,
  --   sid = 35,
  --   silent = 1
  -- }
  local maps = {}
  mode = mode or ""
  -- TODO: for clap -- get buffer that we are calling this from, not 0
  local data = vim.tbl_extend("keep", api.nvim_buf_get_keymap(bufnr or 0, mode or ""), api.nvim_get_keymap(mode or ""))
  local keys = vim.tbl_keys(data[1])
  local widths = {}

  for _, k in ipairs(keys) do
    local i = 0
    for _, v in ipairs(data) do
      local val = tostring(v[k]):len()
      if val > i then
        i = val
      end
    end
    widths[k] = i
  end

  for _, v in ipairs(data) do
    local attrs = ""
    if v.noremap == 1 then
      attrs = attrs .. "*"
    end
    if v.script == 1 then
      attrs = attrs .. "&"
    end
    if v.buffer > 0 then
      attrs = attrs .. "@"
    end
    local lhs = v.lhs:gsub("%s", "<Space>")
    local rhs = v.rhs ~= "" and v.rhs or "<Nop>"
    -- TODO: calculate width of clap window for rhs
    table.insert(maps, string.format("%-" .. widths.lhs .. "s %3s %s", lhs, attrs, rhs:sub(1, 100)))
  end
  return maps
end

function M.test_cmd(iter_ct)
  local ITERATIONS = iter_ct or 1000000

  local report = function(cmd_string, time)
    print(("%-99s %d iterations in %-.04f"):format(cmd_string, ITERATIONS, time))
  end

  local compare = {
    "vim.fn.pathshorten(vim.fn.expand'%')",
    "vim.call('pathshorten', vim.fn.expand'%')",
    "vim.api.nvim_call_function('pathshorten', {vim.api.nvim_call_function('expand', {'%'})})",
  }

  for _, cmd in ipairs(compare) do
    local start = uv.hrtime()
    for _ = 1, ITERATIONS do
      loadstring(cmd)
    end
    report(cmd, (uv.hrtime() - start) / 1e6)
  end
end

function M.test_fn(iter_ct)
  local report = function(cmd_string, time)
    print(("%-40s %5.02f ms"):format(cmd_string, time))
  end

  local compare = {
    ["vim.fn.pathshorten"] = function()
      vim.fn.pathshorten(vim.fn.expand "%")
    end,
    ["vim.api.nvim_call_function"] = function()
      api.nvim_call_function("pathshorten", { api.nvim_call_function("expand", { "%" }) })
    end,
    ["vim.call"] = function()
      vim.call("pathshorten", vim.fn.expand "%")
    end,
  }

  iter_ct = iter_ct or 1000000
  local timer = uv.hrtime

  print("Test of " .. iter_ct .. " iterations")
  print "------------------------------"
  for name, fn in pairs(compare) do
    local start = timer()
    for _ = 1, iter_ct do
      fn()
    end
    local ms_elapsed = (timer() - start) / 1e6
    report(name, ms_elapsed)
  end
end

function M.startuptime() -- Create floating window and display :StartupTime
  local width = vim.o.columns - 20
  local height = vim.o.lines - 9

  bufnr = win.create_centered_floating {
    width = width,
    height = height,
    border = true,
    winblend = 1,
    fn = function()
      vim.cmd "StartupTime"
    end,
  }

  vim.bo[bufnr].bufhidden = "wipe"
  vim.wo.cursorline = true
end

function M.load_lvimrc() -- Load local vimrc using env var of paths set with direnv
  local sourced = vim.b.localrc_sourced or {}
  local available = uv.os_getenv "LOCAL_VIMRC"
  for path in vim.gsplit(available, ":", true) do
    if not vim.tbl_contains(sourced, path) then
      vim.cmd("source " .. path)
      table.insert(sourced, path)
    end
  end
  vim.b.localrc_sourced = sourced
end
return M
