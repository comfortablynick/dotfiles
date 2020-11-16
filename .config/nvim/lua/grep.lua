local Job = nvim.packrequire("plenary.nvim", "plenary.job")

local grepper = {}

local get_job = function(str, cwd)
  local grep = vim.o.grepprg
  local grep_args = vim.split(grep, " ")
  local grep_prg = table.remove(grep_args, 1)
  table.insert(grep_args, str)
  local qf_title = ("[AsyncGrep] %s %s"):format(grep_prg,
                                                table.concat(grep_args, " "))
  vim.fn.setqflist({}, " ", {title = qf_title})
  local job = Job:new{
    command = grep_prg,
    args = grep_args,
    cwd = cwd,
    on_stdout = vim.schedule_wrap(function(_, line)
      local split_line = vim.split(line, ":")

      local filename = split_line[1]
      local lnum = split_line[2]
      local col = split_line[3]

      vim.fn.setqflist({
        {filename = filename, lnum = lnum, col = col, text = split_line[4]},
      }, "a")
    end),

    on_exit = vim.schedule_wrap(function()
      local result_ct = #vim.fn.getqflist()
      if result_ct > 0 then
        vim.cmd("cwindow " .. math.min(result_ct, 20))
      else
        nvim.warn"grep: no results found"
      end
    end),
  }

  return job
end

grepper.grep_for_string = function(str, cwd)
  local job = get_job(str, cwd)
  return job:sync()
end

grepper.replace_string = function(search, replace, opts)
  opts = opts or {}

  local job = get_job(search, opts.cwd)
  job:add_on_exit_callback(vim.schedule_wrap(
                             function()
      vim.cmd(string.format("cdo s/%s/%s/g", search, replace))
      vim.cmd[[cdo :update]]
      vim.cmd[[noh]]
    end))

  return job:sync()
end

return grepper
