local cmd = function(name, command, opts)
  vim.api.nvim_create_user_command(name, command, opts or {})
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
  require("tools").redir { cmd = opts.args, mods = opts.mods, bang = opts.bang }
end, { complete = "command", nargs = 1, bang = true })

cmd("Grep", function(opts) -- :: Async grep
  require("grep").grep_for_string(opts.args)
end, { complete = "file", nargs = "+", desc = "Async grep and show results in quickfix" })

cmd("Synstack", "echo syntax#synstack()", { desc = "Show syntax stack under cursor" })

cmd("Option", function(opts)
  vim.pretty_print(vim.api.nvim_get_option_info(opts.args))
end, { complete = "option", nargs = 1, desc = "Pretty print option info from api" })

cmd("Help", function(opts)
  require("window").floating_help(opts.args)
end, { complete = "help", nargs = "?", desc = "Display help item in floating window" })
vim.fn["map#cabbr"]("H", "Help")

cmd("Root", function(opts)
  local root = require("util").get_current_root()
  vim.cmd.lcd { root, mods = { silent = true } }
end, { desc = "Change to root dir" })

