-- init.lua
local api = vim.api
local env = vim.env
local uv = vim.loop
local o = vim.opt
local g = vim.g

require"nvim"
require"globals"

vim.fn['plugins#set_source_handler']()

-- Global variables
g.python3_host_prog = env.NVIM_PY3_DIR
g.mapleader = ","
g.c_syntax_for_h = 1
g.window_width = o.columns

-- Disable default vim plugins
g.loaded_gzip = 1
g.loaded_tarPlugin = 1
g.loaded_2html_plugin = 1
g.loaded_zipPlugin = 1
g.loaded_getscriptPlugin = 1
g.loaded_html_plugin = 1
g.loaded_rrhelper = 1
g.loaded_tarPlugin = 1
g.loaded_tutor_mode_plugin = 1
g.loaded_vimballPlugin = 1
g.vimsyn_embed = 'lP'

-- Disable providers
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_python_provider = 0

-- Directories
-- TODO: create if they don't exist
o.undodir = env.XDG_CACHE_HOME .. "/nvim/undo//"
o.shadafile = vim.fn.stdpath('data').."/shada/main.shada"
o.backupdir = env.HOME .. "/.vim/backup//"

o.swapfile = false
o.backup = true
o.undofile = true

o.shell = "/bin/sh"
o.hidden = true
o.termguicolors = true
o.inccommand = 'split'
o.mouse = 'a'
o.winblend = 10
o.history = 5000
o.synmaxcol = 300
o.showtabline = 2
o.visualbell = true
o.wrap = false
o.shortmess:append{c = true}
o.clipboard = "unnamed"
o.ruler = false
o.showmatch = true
o.updatetime = 700
o.signcolumn = "yes"
o.scrolloff = 10
o.timeoutlen = 300
o.mouse = "a"
o.conceallevel = 1
o.virtualedit = {onemore = true}
o.wildignore:append{"__pycache__", ".mypy_cache", ".git"}
o.list = true
o.listchars = {tab = "▸ ", nbsp = "␣", trail = "·"}
o.title = true

o.dictionary:append"/usr/share/dict/words-insane"

o.expandtab = true
o.smartindent = true
o.tabstop = 4
o.shiftwidth = 0

o.smartcase = true

o.cmdwinheight = 10
o.splitright = true
o.splitbelow = true

o.number = true
o.relativenumber = true
o.numberwidth = 2
