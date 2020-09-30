-- Adapted from:
-- https://teukka.tech/vimloop.html
local api = vim.api
local uv = vim.loop
local makeprg, efm, handle

local function has_non_whitespace(str) return str:match("[^%s]") end

local function fill_qflist(lines)
  vim.fn.setqflist({}, "a", {
    title = makeprg,
    lines = vim.tbl_filter(has_non_whitespace, lines),
    efm = efm,
  })
  vim.cmd[[doautocmd QuickFixCmdPost]]
end

local function onread(err, data)
  assert(not err, err)
  if data then
    local lines = vim.split(data, "\n")
    fill_qflist(lines)
  end
end

local function make()
  -- Get local buf opts first
  -- If global opts are missing, we're screwed anyway
  makeprg = npcall(api.nvim_buf_get_option, 0, "makeprg") or vim.o.makeprg
  efm = npcall(api.nvim_buf_get_option, 0, "errorformat") or vim.o.errorformat

  local cmd = vim.fn.expandcmd(makeprg)
  local args = vim.split(cmd, " ")
  local bin = table.remove(args, 1)
  local stdout = uv.new_pipe(false)
  local stderr = uv.new_pipe(false)

  handle = uv.spawn(bin, {args = args, stdio = {nil, stdout, stderr}},
                    function()
    for _, io in ipairs{stdout, stderr} do
      io:read_stop()
      io:close()
    end
    handle:close()
  end)

  -- TODO: only do this if there are results to fill qf
  if vim.fn.getqflist({title = ""}).title == makeprg then
    vim.fn.setqflist({}, "r")
  else
    vim.fn.setqflist({}, " ")
  end

  stderr:read_start(vim.schedule_wrap(onread))
  stdout:read_start(vim.schedule_wrap(onread))
end

return make
