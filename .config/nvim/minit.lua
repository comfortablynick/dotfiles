local root = "/tmp/nvim-repro"

-- set stdpaths to use .repro
for _, name in ipairs { "config", "data", "state", "cache" } do
  vim.env[("XDG_%s_HOME"):format(name:upper())] = root .. "/" .. name
end

-- bootstrap lazy
local lazypath = root .. "/plugins/lazy.nvim"
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

-- install plugins
local plugins = {
  -- do not remove the colorscheme!
  "folke/tokyonight.nvim",
  -- add any other pugins here
  {
    "alexghergh/nvim-tmux-navigation",
    lazy = true,
    cmd = {
      "NvimTmuxNavigateLeft",
      "NvimTmuxNavigateRight",
      "NvimTmuxNavigateDown",
      "NvimTmuxNavigateUp",
      "NvimTmuxNavigateLastActive",
    },
    init = function()
      vim.keymap.set("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", { desc = "Vim/Tmux navigate left" })
      vim.keymap.set("n", "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>", { desc = "Vim/Tmux navigate down" })
      vim.keymap.set("n", "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>", { desc = "Vim/Tmux navigate up" })
      vim.keymap.set("n", "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", { desc = "Vim/Tmux navigate right" })
      vim.keymap.set(
        "n",
        "<C-p>",
        "<Cmd>NvimTmuxNavigateLastActive<CR>",
        { desc = "Vim/Tmux navigate to last active window" }
      )
    end,
    config = function()
      require "nvim-tmux-navigation"
    end,
  },
}
require("lazy").setup(plugins, {
  root = root .. "/plugins",
})

-- Non-essential settings so I don't annoy myself
vim.keymap.set("n", ";", ":")
vim.keymap.set("x", ";", ":")
vim.keymap.set("o", ";", ":")
vim.keymap.set("n", "g:", ";")
vim.keymap.set("n", "@;", "@:")
vim.keymap.set("n", "q;", "q:")
vim.keymap.set("x", "q;", "q:")
vim.keymap.set("i", "kj", "<Esc>`^")

vim.opt.termguicolors = true

-- do not remove the colorscheme!
vim.cmd [[colorscheme tokyonight]]
