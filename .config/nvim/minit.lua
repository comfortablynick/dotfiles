local api = vim.api
local opt = vim.opt
local fn = vim.fn

local tmp_root = "/tmp/nvim/site"
local pack_root = tmp_root .. "/pack"
local packer_install_path = pack_root .. "/packer/start/packer.nvim"
local packer_compiled = tmp_root .. "/packer_compiled_test.lua"

_G.paths = {
  tmp_root = tmp_root,
  pack_root = pack_root,
  packer_install_path = packer_install_path,
  packer_compiled = packer_compiled,
}

if fn.empty(fn.glob(packer_install_path)) > 0 then
  packer_bootstrap = fn.system {
    "git",
    "clone",
    "--depth",
    1,
    "https://github.com/wbthomason/packer.nvim",
    packer_install_path,
  }
end

opt.shadafile = tmp_root .. "/tmp.shada"
opt.runtimepath = "$VIMRUNTIME"
opt.packpath = tmp_root
opt.completeopt = { "menuone", "noinsert", "noselect" }
opt.shortmess:append "c"
opt.shell = "/bin/sh"
opt.termguicolors = true

-- Debug print
_G.p = function(...)
  print(vim.inspect(...))
end

-- Non-essential settings so I don't annoy myself
do
  local opts = { noremap = true }
  api.nvim_set_keymap("n", ";", ":", opts)
  api.nvim_set_keymap("x", ";", ":", opts)
  api.nvim_set_keymap("o", ";", ":", opts)

  api.nvim_set_keymap("n", "g:", ";", opts)
  api.nvim_set_keymap("n", "@;", "@:", opts)
  api.nvim_set_keymap("n", "q;", "q:", opts)
  api.nvim_set_keymap("x", "q;", "q:", opts)

  api.nvim_set_keymap("i", "kj", "<Esc>`^", opts)
end

opt.tabstop = 4
opt.shiftwidth = 0
opt.expandtab = true
opt.number = true

-- Put any plugin config that should be loaded after plugins are installed in here
_G.load_config = function()
  -- Colors
  vim.cmd [[colorscheme PaperColor]]
  require("lualine").setup { theme = "papercolor" }

  -- Lualine
end

local packer = require "packer"

packer.startup {
  function(use)
    use "wbthomason/packer.nvim"
    use "hoob3rt/lualine.nvim"
    use { "NLKNguyen/papercolor-theme", opt = true }
    use "tpope/vim-scriptease"

    if packer_bootstrap then
      vim.notify "Installing packer.nvim and plugins"
      packer.sync()
      vim.cmd [[autocmd User PackerComplete ++once echo "Ready!" | lua load_config()]]
    else
      _G.load_config()
    end
  end,
  config = { package_root = pack_root, compile_path = packer_compiled },
}
