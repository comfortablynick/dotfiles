local root = "/tmp/nvim-repro"

-- set stdpaths to use .repro
for _, name in ipairs { "config", "data", "state", "cache" } do
  vim.env[("XDG_%s_HOME"):format(name:upper())] = root .. "/" .. name
end

-- bootstrap lazy
local lazypath = root .. "/plugins/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

  {
    "liuchengxu/vim-clap",
    cmd = "Clap",
    build = ":call clap#installer#force_download()",
    dependencies = { "liuchengxu/vista.vim" },
    init = function()
      -- vim.cmd.runtime "autoload/plugins/clap.vim"
	vim.g.clap_preview_direction = 'UD'
	vim.g.clap_multi_selection_warning_silent = 1
	vim.g.clap_enable_icon = true
	vim.g.clap_preview_size = 10
	vim.g.clap_enable_background_shadow = false
	vim.g.clap_background_shadow_blend = 50
	vim.g.clap_layout = {relative = 'editor'}
	vim.g.clap_provider_tags_force_vista = true
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
vim.cmd [[colorscheme tokyonight-night]]
