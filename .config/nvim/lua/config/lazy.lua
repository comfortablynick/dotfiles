-- bootstrap from github
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
end
vim.opt.runtimepath:prepend(lazypath)

-- load lazy
require("lazy").setup("plugins", {
  defaults = { lazy = true },
  install = { missing = false, colorscheme = { "gruvbox" } },
  checker = { enabled = false, nofity = false },
  change_detection = { enabled = true, nofity = true },
  ui = {
    border = "rounded",
    size = { width = 0.5, height = 0.8 },
    custom_keys = {
      ["<LocalLeader>d"] = function(plugin)
        d(plugin)
      end,
      ["<LocalLeader>g"] = function(plugin)
        require("lazy.util").float_term({ "tig" }, {
          cwd = plugin.dir,
          terminal = true,
          close_on_exit = true,
          enter = true,
        })
      end,
    },
  },
  performance = {
    rtp = {
      reset = true,
    },
  },
  debug = false,
})
