local api = vim.api
local uv = vim.loop
local util = require"util"
local fn = require"fun"
local Job = require"plenary.job"
local M = {}

local qf_open = function(max_size) -- {{{1
  if not max_size then max_size = 0 end
  local vim_qf_size = vim.g.quickfix_size or 20
  local items = #vim.fn.getqflist()
  if items < 1 then return end
  local qf_size = math.min(items, (max_size > 0) and max_size or vim_qf_size)
  vim.cmd(("copen %d | wincmd k"):format(qf_size))
end

function M.async_grep(term) -- {{{1
  assert(term, "async grep: search term missing")
  local stdout = uv.new_pipe(false)
  local stderr = uv.new_pipe(false)
  local grep = vim.o.grepprg
  local search = vim.fn.expand(term)
  local results = {}
  local handle

  local onread = function(err, data)
    assert(not err, err)
    if not data then return end
    for _, item in ipairs(vim.split(data, "\n")) do
      if item ~= "" then table.insert(results, item) end
    end
  end
  local onexit = function()
    stdout:close()
    stderr:close()
    handle:close()
    vim.fn.setqflist({}, "r", {
      title = "[AsyncGrep] " .. grep .. " " .. search,
      lines = results,
    })
    local result_ct = #results
    if result_ct > 0 then
      vim.cmd("cwindow " .. math.min(result_ct, 10))
    else
      print"grep: no results found"
    end
  end
  local grepprg = vim.split(grep, " ")
  handle = uv.spawn(table.remove(grepprg, 1), {
    args = {search, unpack(grepprg)},
    stdio = {nil, stdout, stderr},
  }, vim.schedule_wrap(onexit))
  uv.read_start(stdout, onread)
  uv.read_start(stderr, onread)
end

-- Test lower level vim apis
function M.scandir(path) -- {{{1
  local d = uv.fs_scandir(vim.fn.expand(path))
  local out = {}
  while true do
    local name, type = uv.fs_scandir_next(d)
    if not name then break end
    table.insert(out, {name, type})
  end
  print(vim.inspect(out))
end

function M.readdir(path) -- {{{1
  local handle = uv.fs_opendir(vim.fn.expand(path), nil, 10)
  local out = {}
  while true do
    local entry = uv.fs_readdir(handle)
    if not entry then break end
    -- use list_extend because readdir
    -- outputs table with each iteration
    vim.list_extend(out, entry)
  end
  print(vim.inspect(out))
  uv.fs_closedir(handle)
end

function M.set_executable(file) -- {{{1
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
    for i = 4, #mode do table.insert(chars, perms[tonumber(mode:sub(i, i))]) end
    return table.concat(chars)
  end
  local stat = uv.fs_stat(file)
  if stat == nil then
    api.nvim_err_writeln(string.format("File '%s' does not exist!", file))
    return
  end
  local orig_mode = stat.mode
  local orig_mode_oct = string.sub(string.format("%o", orig_mode), 4)
  nvim.spawn("chmod", {args = {"u+x", file}}, function()
    local new_mode = uv.fs_stat(file).mode
    local new_mode_oct = string.sub(string.format("%o", new_mode), 4)
    local new_mode_str = get_perm_str(new_mode)
    if orig_mode ~= new_mode then
      printf("Permissions changed: %s (%s) -> %s (%s)", get_perm_str(orig_mode),
             orig_mode_oct, new_mode_str, new_mode_oct)
    else
      printf("Permissions not changed: %s (%s)", new_mode_str, new_mode_oct)
    end
  end)
end

function M.get_history_clap() -- {{{1
  local hist_ct = vim.fn.histnr("cmd")
  local hist = {}
  for i = 1, hist_ct do
    table.insert(hist,
                 string.format("%" .. #tostring(hist_ct) .. "d, %s",
                               hist_ct - i, vim.fn.histget("cmd", -i)))
  end
  return hist
end

function M.get_history_fzf() -- {{{1
  local hist_ct = vim.fn.histnr("cmd")
  local hist = {}
  -- for i = 1, hist_ct do
  for i = hist_ct, 1, -1 do
    hist[string.format("%" .. #tostring(hist_ct) .. "d", hist_ct - i)] =
      vim.fn.histget("cmd", -i)
  end
  return hist
end

function M.get_history() -- {{{1
  local results = {}
  for k, v in string.gmatch(vim.fn.execute("history :"), "(%d+)%s*([^\n]+)\n") do
    results[k] = "\x1b[38;5;205m" .. v .. "\x1b[m"
  end
  -- Using iterators and luafun
  -- fn.each(function(k, v) results[k] = "\x1b[38;5;205m" .. v .. "\x1b[m" end,
  --         fn.dup(vim.fn.execute("history :"):gmatch("(%d+)%s*([^\n]+)\n")))
  return results
end

function M.r(cmd) -- {{{1
  local args = vim.split(cmd, " ")
  local bin = table.remove(args, 1)
  local on_read = function(err, data)
    assert(not err, err)
    vim.fn.setqflist({}, "a", {title = "Command: " .. cmd, lines = data})
  end
  local on_close = qf_open
  vim.fn.setqflist({}, " ", {title = "Command: " .. cmd})
  M.spawn(bin, {args = args}, vim.schedule_wrap(on_read),
          vim.schedule_wrap(on_close))
end

function M.spawn(cmd, opts, read_cb, exit_cb) -- {{{1
  local stdin = uv.new_pipe(false)
  local stdout = uv.new_pipe(false)
  local stderr = uv.new_pipe(false)
  local args = {stdio = {stdin, stdout, stderr}, args = opts.args or {}}
  local process, pid = nil, nil

  process, pid = uv.spawn(cmd, args, function(code)
    local handles = {stdin, stdout, stderr, process}
    for _, handle in ipairs(handles) do uv.close(handle) end
    exit_cb(code)
  end)
  assert(process, pid)

  local on_read = function(err, data)
    if not data then return end
    local lines = vim.split(vim.trim(data), "\n")
    read_cb(err, lines)
  end

  for _, io in ipairs{stdout, stderr} do uv.read_start(io, on_read) end

  if opts.stream then
    uv.write(stdin, opts.stream, function(err)
      assert(not err, err)
      uv.shutdown(stdin, function(err) assert(not err, err) end)
    end)
  end
end

function M.arun(cmd) -- {{{1
  local args = vim.split(cmd, " ")
  local bin = table.remove(args, 1)
  local on_read = function(err, data)
    assert(not err, err)
    vim.fn.setqflist({}, "a", {title = "Command: " .. cmd, lines = data})
  end
  -- M.spawn(bin, {args = args}, vim.schedule_wrap(on_read),
  --         vim.schedule_wrap(on_close))
  local job = Job:new{
    command = bin,
    args = args,
    on_stdout = vim.schedule_wrap(on_read),
    -- on_stderr = vim.schedule_wrap(on_read),
    -- on_exit = vim.schedule_wrap(qf_open),
  }
  job:start()
  job:shutdown()
  -- return job:stderr_result()
end

function M.run(cmd) -- {{{1
  -- Test run command using libuv api
  local stdout = uv.new_pipe(false)
  local stderr = uv.new_pipe(false)
  local args = vim.split(cmd, " ")
  local bin = table.remove(args, 1)
  local handle
  local options = {}
  options.stdio = {nil, stdout, stderr}
  options.args = args

  local onread = function(err, data)
    assert(not err, err)
    if not data then return end
    local lines = vim.split(vim.trim(data), "\n")
    vim.fn.setqflist({}, "a", {title = "Command: " .. cmd, lines = lines})
  end
  local onexit = function(code)
    stdout:close()
    stderr:close()
    handle:close()
    if code ~= 0 then
      vim.g.job_status = "Failed"
    else
      vim.g.job_status = "Success"
    end
    local results = #vim.fn.getqflist()
    if results > 0 then vim.cmd("copen" .. math.min(results, 20)) end
    vim.defer_fn(function()

      vim.cmd("autocmd CursorMoved,CursorMovedI * ++once " ..
                "if exists('g:job_status') | unlet g:job_status | endif")
    end, 10000)
  end

  -- Clear quickfix
  vim.fn.setqflist({},
                   vim.fn.getqflist({title = ""}).title == bin and "r" or " ")

  -- Start process
  handle = uv.spawn(bin, options, vim.schedule_wrap(onexit))
  vim.g.job_status = "Running"
  uv.read_start(stdout, vim.schedule_wrap(onread))
  uv.read_start(stderr, vim.schedule_wrap(onread))
end

function M.sh(cmd, mods, cwd) -- {{{1
  require"window".create_scratch({}, mods or "")
  local args = vim.split(cmd, " ")
  local bin = table.remove(args, 1)
  local stdin = uv.new_pipe(false)
  local stdout = uv.new_pipe(false)
  local stderr = uv.new_pipe(false)
  local options = {args = args, stdio = {stdin, stdout, stderr}}

  local winnr = api.nvim_get_current_win()
  local bufnr = api.nvim_get_current_buf()

  -- Return to previous window
  vim.cmd[[wincmd p]]

  if cwd then
    assert(cwd and util.path.is_dir(cwd), "error: Invalid directory: " .. cwd)
    options.cwd = cwd
  end

  -- luacheck: no unused
  local handle
  handle = uv.spawn(bin, options, function()
    for _, io in ipairs(options.stdio) do io:close() end
  end)

  -- If the buffer closes, then kill our process.
  api.nvim_buf_attach(bufnr, false, {
    on_detach = function()
      if not handle:is_closing() then handle:kill(15) end
    end,
  })

  local output_buf = ""
  local update_chunk = vim.schedule_wrap(
                         function(err, chunk)
      assert(not err, err)
      if chunk then
        output_buf = output_buf .. chunk
        local lines = vim.split(output_buf, "\n", true)
        api.nvim_buf_set_option(bufnr, "modifiable", true)
        api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
        api.nvim_buf_set_option(bufnr, "modifiable", false)
        api.nvim_buf_set_option(bufnr, "modified", false)
        if api.nvim_win_is_valid(winnr) then
          api.nvim_win_set_cursor(winnr, {#lines, 0})
        end
      end
    end)
  stdout:read_start(update_chunk)
  stderr:read_start(update_chunk)
  stdin:write(cmd)
  stdin:write("\n")
  stdin:shutdown()
end

function M.async_run(cmd, bang) -- {{{1
  local results = {}
  local args = vim.split(cmd, " ")
  local command = table.remove(args, 1)
  local qf_size = vim.g.quickfix_size or 20
  local on_read = function(err, lines)
    assert(not err, err)
    nvim.tbl_merge(results, lines)
  end
  local on_exit = function(code)
    if code ~= 0 then
      vim.g.job_status = "Failed"
    else
      vim.g.job_status = "Success"
    end
    if #results > 0 then
      vim.fn.setqflist({}, "r", {title = "Command: " .. cmd, lines = results})
      if bang == "!" then
        print(results[1])
      else
        qf_open(qf_size)
      end
      vim.defer_fn(function()
        if vim.g.job_status then vim.g.job_status = nil end
      end, 10000)
    end
  end
  M.spawn(command, {args = args}, on_read, vim.schedule_wrap(on_exit))
  vim.g.job_status = "Running"
end

function M.mru_files(n) -- {{{1
  local exclude_patterns = {
    "nvim/.*/doc/.*%.txt", -- nvim help files (approximately)
    ".git", -- git dirs
  }
  local file_filter = function(file)
    local is_excluded = function(s) return file:find(s) ~= nil end
    return not fn.iter(exclude_patterns):any(is_excluded) and
             util.path.is_file(file)
  end
  local shorten_path = function(s) return s:gsub(uv.os_homedir(), "~") end
  return fn.iter(vim.v.oldfiles):filter(file_filter):map(shorten_path):take_n(
           n or 999):totable()
end

function M.make() -- {{{1
  local makeprg = npcall(api.nvim_buf_get_option, 0, "makeprg") or vim.o.makeprg
  local efm = npcall(api.nvim_buf_get_option, 0, "errorformat") or
                vim.o.errorformat
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local expanded_cmd = vim.fn.expandcmd(makeprg)
  local args = vim.split(expanded_cmd, " ")
  local cmd = table.remove(args, 1)
  local options = {}
  local handle

  options.stdio = {nil, stdout, stderr}
  options.args = args

  local function has_non_whitespace(str) return str:match("[^%s]") end

  local onread = function(err, data)
    assert(not err, err)
    if not data then return end
    local lines = vim.split(data, "\n")
    vim.fn.setqflist({}, "a", {
      title = expanded_cmd,
      lines = vim.tbl_filter(has_non_whitespace, lines),
      efm = efm,
    })
  end

  local onexit = function()
    stdout:read_stop()
    stdout:close()
    stderr:read_stop()
    stderr:close()
    handle:close()
  end

  if vim.fn.getqflist({title = ""}).title == expanded_cmd then
    vim.fn.setqflist({}, "r")
  else
    vim.fn.setqflist({}, " ")
  end

  handle = uv.spawn(cmd, options, onexit)
  stderr:read_start(vim.schedule_wrap(onread))
  stdout:read_start(vim.schedule_wrap(onread))
end

-- Return module --{{{1
return M
