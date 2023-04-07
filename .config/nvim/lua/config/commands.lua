local cmd = function(name, command, opts)
  vim.api.nvim_create_user_command(name, command, opts or {})
end

cmd("LspDisable", function()
  vim.lsp.stop_client(vim.lsp.get_active_clients())
end, { desc = "Stop all LSP clients" })

cmd("Gpush", function() -- :: Custom git push
  require("tools").term_run { cmd = "git push", mods = "10" }
end)
vim.keymap.set("n", "<Leader>gp", "<Cmd>Gpush<CR>", { desc = "Git push" })

cmd("MRU", function(opts) -- :: Display most recently used files in scratch buffer
  require("window").create_scratch(require("tools").mru_files(opts.args), opts.mods)
end, { nargs = "?", desc = "Display most recently used files in scratch buffer" })

cmd("Sh", function(opts) -- :: Run async cmd and output to scratch buffer
  require("tools").sh { cmd = opts.args }
end, { complete = "file", nargs = "+", desc = "Run async cmd and output to scratch buffer" })

cmd("Term", function(opts) -- :: Run async command in terminal buffer
  require("tools").term_run_cmd(unpack(vim.split(opts.args, " ")))
end, { complete = "shellcmd", nargs = "+" })

cmd("Run", function(opts) -- :: Simple lua version of AsyncRun
  require("tools").async_run(opts.args, opts.bang)
end, { complete = "shellcmd", nargs = "+", bang = true })

cmd("Redir", function(opts) -- :: Redirect output of command to scratch buffer
  require("tools").redir(opts.args, opts.mods, opts.bang)
end, { complete = "command", nargs = 1, bang = true })

cmd("Grep", function(opts) -- :: Async grep
  require("grep").grep_for_string(opts.args)
end, { complete = "file", nargs = "+", desc = "Async grep and show results in quickfix" })

cmd("Option", function(opts)
  vim.print(vim.api.nvim_get_option_info2(opts.args, {}))
end, { complete = "option", nargs = 1, desc = "Pretty print option info from api" })

cmd("Help", function(opts)
  require("window").floating_help(opts.args)
end, { complete = "help", nargs = "?", desc = "Display help item in floating window" })
vim.fn["map#cabbr"]("H", "Help")

cmd("Root", function()
  local root = require("util").get_current_root()
  vim.cmd.lcd { root, mods = { silent = true } }
end, { desc = "Change to root dir" })

cmd("S", "AsyncTask file-run", { desc = "Use asynctasks task runner to determine command based on filetype" })

cmd("CopyMode", function()
  vim.opt.signcolumn = "no"
  vim.opt.number = false
  vim.opt.relativenumber = false
end, { desc = "Get rid of window decorations for easy coping from hterm" })

cmd("BufOnly", function(opts)
  vim.fn["buffer#only"] { bang = opts.bang }
end, { desc = "Delete all buffers but the current one" })

-- Misc commonly mistyped commands
cmd("WQ", "wq")
cmd("Wq", "wq")
cmd("Wqa", "wqa")
cmd("W", "w")

cmd(
  "Rg",
  -- Call telescope with the first argument (if nil, it's just empty no crash)
  function(args)
    require("telescope.builtin").grep_string { search = args.fargs[1] }
  end,
  -- Take 0 or 1 arg
  { nargs = "?", desc = "Grep using Telescope" }
)

-- Buffer management
cmd("Only", function(opts)
  require("buffer").only(opts.bang)
end, { bang = true, desc = "Keep only the current buffer (! forces close)" })

cmd("Bdelete", function(opts)
  vim.fn["buffer#sayonara"](opts.bang)
end, { bang = true, desc = "Delete buffer without changing window layout (! do not preserve layout)" })

cmd("Bclose", function(opts)
  vim.fn["buffer#close"](opts.args)
end, { bang = true, nargs = 1, complete = vim.fn["buffer#close_complete"] })

cmd("Scratchify", function()
  vim.bo.buflisted = false
  vim.bo.swapfile = false
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = true
end, { desc = "Convert to scratch buffer" })

cmd("LazyGit", function(opts)
  local ui = vim.api.nvim_list_uis()[1]
  require("toggleterm.terminal").Terminal
    :new({
      cmd = "lazygit",
      count = opts.count,
      float_opts = {
        width = function()
          return math.floor(ui.width * 0.8)
        end,
        height = function()
          return math.floor(ui.height * 0.6)
        end,
      },
    })
    :toggle()
end, { count = true, desc = "Open lazygit in toggleterm" })

cmd("LPrint", function(opts)
  vim.print(vim.api.nvim_eval(opts.args))
end, { complete = "expression", nargs = 1, desc = "Pretty-print viml expression using Lua" })

cmd("PPrint", function(opts)
  print(vim.fn["util#pformat"](vim.api.nvim_eval(opts.args)))
end, { complete = "expression", nargs = 1, desc = "Pretty-print viml expression using Python" })

cmd("Command", function(opts)
  vim.print(opts)
end, { nargs = "*" })
