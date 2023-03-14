local o = vim.opt
local g = vim.g
local uv = vim.loop
local shell = "/bin/sh"

-- Global variables
vim.env.SHELL = shell -- Some things use $SHELL rather than &shell
g.python3_host_prog = uv.os_getenv "NVIM_PY3_DIR"
g.mapleader = ","
g.c_syntax_for_h = 1
g.window_width = o.columns
g.vimsyn_embed = "lP"

local disabled_built_ins = {
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "html_plugin",
  "2html_plugin",
  "tohtml_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  "tutor_mode_plugin",
}

for _, plugin in ipairs(disabled_built_ins) do
  g["loaded_" .. plugin] = 1
end

for _, provider in ipairs { "ruby", "perl", "python" } do
  g["loaded_" .. provider .. "_provider"] = 0
end

require "config.lazy"
require "nvim"
require "globals"

-- Patterns to detect root dir
g.root_patterns = {
  "init.vim",
  ".envrc",
  ".clasp.json",
  ".git",
  ".git/",
  ".projections.json",
  "package-lock.json",
  "package.json",
  "tsconfig.json",
  ".ansible/",
  ".tasks",
  "tasks.ini",
  "justfile",
}

o.backupdir:remove "." -- Don't save backups in current dir
o.swapfile = false
o.backup = true
o.undofile = true

o.shell = shell
o.hidden = true
o.termguicolors = true
o.inccommand = "split"
o.mouse = "a"
o.history = 5000
o.synmaxcol = 300
o.showtabline = 2
o.visualbell = true
o.wrap = false
o.shortmess = o.shortmess
  + "c" -- don't show completion menu messages
  + "t" -- truncate file message if too long
  + "T" -- truncate other messages in the middle
o.clipboard = "unnamed"
o.ruler = false
o.showmatch = true
o.updatetime = 700
o.signcolumn = "yes"
o.scrolloff = 10
o.timeoutlen = 800
o.mouse = "a"
o.conceallevel = 1
o.virtualedit = "onemore"
o.list = true
o.listchars = {
  tab = "▸ ", -- Tabs
  nbsp = "␣", -- Non-breaking space
  trail = "·", -- Trailing space
}
o.title = true
if nvim.has "nvim-0.9" then
  o.splitkeep = "screen"
end

o.path = {
  ".", -- Directory of current file
  "", -- Current directory
  "**", -- Recursive search
}

o.wildmode = { "longest", "full" }
o.wildoptions = { "pum" }
o.wildignore:append { "__pycache__", ".mypy_cache", ".git" }

-- Grep
if nvim.executable "ugrep" then
  o.grepprg = "ugrep -RInkju --ignore-files --tabs=1"
  o.grepformat = { "%f:%l:%c:%m", "%f+%l+%c+%m", [[%-G%f\|%l\|%c\|%m]] }
elseif nvim.executable "rg" then
  o.grepprg = "rg --vimgrep --hidden"
  o.grepformat = { "%f:%l:%c:%m", "%f:%l:%m" }
end

o.dictionary:append "/usr/share/dict/words-insane"

o.expandtab = true
o.smartindent = true
o.tabstop = 4
o.shiftwidth = 0
o.smartcase = true
o.formatoptions = o.formatoptions
  - "a" -- Auto formatting
  - "t" -- Wrap text
  + "c" -- Wrap comments
  + "q" -- Allow formatting comments w/ gq
  - "o" -- Insert comment leader after o or O
  + "r" -- Insert comment leader after <Enter>
  + "n" -- Format numbered lists using 'formatlistpat'
  + "j" -- Remove comment leader when joining lines
  - "2" -- Use indent of 2nd line of paragraph

-- Window options
o.winblend = 10
o.pumblend = 10
o.cmdwinheight = 10
o.splitright = true
o.splitbelow = true
o.number = true
o.relativenumber = true
o.numberwidth = 2
o.cursorline = false

-- Netrw options
vim.g.netrw_set_opts = 1
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_winsize = -30 -- Absolute
vim.g.netrw_banner = 0
vim.g.netrw_list_hide = vim.o.wildignore
vim.g.netrw_sort_sequence = [[[\/]$,*]] -- Directories on the top, files below

require "config.statusline"
require "config.treesitter"
require("config.lsp").init()
require "config.autocmds"
require "config.maps"
require "config.commands"

pcall(vim.cmd.colorscheme, "gruvbox")
