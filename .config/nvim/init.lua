-- init.lua
local api = vim.api
local env = vim.env
local uv = vim.loop
local o = vim.opt
local g = vim.g

require"nvim"
require"globals"

vim.fn['plugins#set_source_handler']()

g.python3_host_prog = env.NVIM_PY3_DIR
g.mapleader = ","

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
o.autoread = true
o.termguicolors = true
o.inccommand = 'split'
o.mouse = 'a'
o.winblend = 10
o.fileformat = "unix"
o.history = 5000
o.synmaxcol = 300
o.laststatus = 2
o.showtabline = 2
o.visualbell = true
o.wrap = false
o.showmode = true
o.shortmess:append"c"
o.clipboard = "unnamed"
o.cursorline = false
o.ruler = false
o.showmatch = true
o.updatetime = 700
o.signcolumn = "yes"
o.scrolloff = 10
o.timeoutlen = 300
o.mouse = "a"
o.startofline = false
o.conceallevel = 1
o.virtualedit = "onemore"
o.wildignore:append{"__pycache__", ".mypy_cache", ".git"}

o.number = true
o.relativenumber = true
