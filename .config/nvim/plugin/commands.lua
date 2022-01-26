local cmd = function(name, command, opts)
  vim.api.nvim_add_user_command(name, command, opts or {})
end

cmd("LspDisable", function()
  vim.lsp.stop_client(vim.lsp.get_active_clients())
end)

cmd("Lf", require("tools").lf_select_current_file)

cmd("Gpush", function() -- :: Custom git push
  require("tools").term_run { cmd = "git push", mods = "10" }
end)
vim.map.n["<Leader>gp"] = { "<Cmd>Gpush<CR>", "Git push" }

cmd("MRU", function(opts) -- :: Display most recently used files in scratch buffer
  require("window").create_scratch(require("tools").mru_files(opts.args), opts.mods)
end, { nargs = "?" })

cmd("Sh", function(opts) -- :: Run async cmd and output to scratch buffer
  require("tools").sh { cmd = opts.args }
end, { complete = "file", nargs = "+" })

cmd("Term", function(opts) -- :: Run async command in terminal buffer
  require("tools").term_run_cmd(unpack(vim.split(opts.args, " ")))
end, { complete = "shellcmd", nargs = "+" })

cmd("Run", function(opts) -- :: Simple lua version of AsyncRun
  require("tools").async_run(opts.args, opts.bang)
end, { complete = "shellcmd", nargs = "+", bang = true })

cmd("Redir", function(opts) -- :: Redirect output of command to scratch buffer
  require("tools").redir{cmd = opts.args, mods = opts.mods, bang = opts.bang}
end, { complete = "command", nargs = 1, bang = true })

cmd("Grep", function(opts) -- :: Async grep
  require("grep").grep_for_string(opts.args)
end, { complete = "file", nargs = "+" })
