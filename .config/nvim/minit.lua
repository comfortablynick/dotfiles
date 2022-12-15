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

if vim.fn.empty(vim.fn.glob(packer_install_path)) > 0 then
  packer_bootstrap = vim.fn.system {
    "git",
    "clone",
    "--depth",
    1,
    "https://github.com/wbthomason/packer.nvim",
    packer_install_path,
  }
end

vim.opt.shadafile = tmp_root .. "/tmp.shada"
vim.opt.runtimepath = "$VIMRUNTIME"
vim.opt.packpath = tmp_root
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.shortmess:append "c"
vim.opt.shell = "/bin/sh"
vim.opt.termguicolors = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0
vim.opt.expandtab = true
vim.opt.number = true

-- Non-essential settings so I don't annoy myself
vim.keymap.set("n", ";", ":")
vim.keymap.set("x", ";", ":")
vim.keymap.set("o", ";", ":")
vim.keymap.set("n", "g:", ";")
vim.keymap.set("n", "@;", "@:")
vim.keymap.set("n", "q;", "q:")
vim.keymap.set("x", "q;", "q:")
vim.keymap.set("i", "kj", "<Esc>`^")

-- Put any plugin config that should be loaded after plugins are installed in here
local load_config = function()
  vim.cmd "silent! colorscheme PaperColor"
  require("lualine").setup { theme = "papercolor" }
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
      local grp = vim.api.nvim_create_augroup("minit", { clear = true })
      vim.api.nvim_create_autocmd("User PackerComplete", { group = grp, callback = load_config, once = true })
    else
      load_config()
    end
  end,
  config = { package_root = pack_root, compile_path = packer_compiled },
}
