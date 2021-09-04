local o = vim.opt
local g = vim.g
local fn = vim.fn
local uv = vim.loop

pcall(require, "impatient") -- TODO: remove this once PR is merged
require "nvim"
require "globals"

-- Global variables
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

o.shell = "/bin/sh"
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
o.listchars = { tab = "▸ ", nbsp = "␣", trail = "·" }
o.title = true

o.wildmode = { "longest", "full" }
o.wildoptions = { "pum" }
o.wildignore:append { "__pycache__", ".mypy_cache", ".git" }

-- Grep
if fn.executable "ugrep" then
  o.grepprg = "ugrep -RInkju. --tabs=1"
  o.grepformat = { "%f:%l:%c:%m", "%f+%l+%c+%m", [[%-G%f\|%l\|%c\|%m]] }
elseif fn.executable "rg" then
  o.grepprg = "rg --vimgrep --hidden --no-ignore-vcs"
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

-- Netrw options
vim.g.netrw_set_opts = 1
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_winsize = -30 -- Absolute
vim.g.netrw_banner = 0
vim.g.netrw_list_hide = vim.o.wildignore
vim.g.netrw_sort_sequence = [[[\/]$,*]] -- Directories on the top, files below

local packs = {
  "vim-toml",
  "vim-projectionist",
  "plenary.nvim",
  "nvim-lspconfig",
  "lsp-status.nvim",
  "lspsaga.nvim",
  "nvim-compe",
  "LuaSnip",
  "friendly-snippets",
  "nvim-web-devicons",
  "vim-dirvish",
  "vim-clap",
  "vim-obsession",
}

for _, pack in ipairs(packs) do
  vim.cmd("silent! packadd! " .. pack)
end

vim.defer_fn(function()
  vim.cmd [[doautocmd User PackLoad]]
end, 200)

require "nvim"
require "globals"
require "map"
require "config.statusline"
require "config.treesitter"
require "config.devicons"
require("config.lsp").init()

do
  local plugin_file = "lua/plugins.lua"
  nvim.create_augroups {
    init_lua = {
      { "BufEnter", "*", "lua require 'config.compe'.init()" },
      { "ColorScheme", "*", "lua require'config.lsp'.set_hl()" },
      { "ColorScheme", "*", "lua statusline.set_hl()" },
      { "BufWritePost", plugin_file, "lua nvim.reload()" },
      { "BufWritePost", plugin_file, "PackerClean" },
      { "BufWritePost", plugin_file, "PackerInstall" },
      { "BufWritePost", plugin_file, "PackerCompile" },
    },
  }
end

local packer_cmds = {
  PackerInstall = { "install()" },
  PackerUpdate = { "update()" },
  PackerSync = { "sync()" },
  PackerClean = { "clean()" },
  PackerCompile = { "compile()" },
  PackerStatus = { "status()" },
  PackerLoad = { "loader(<q-args>)", "-complete=packadd -nargs=+" },
}

local template = [[command! %s %s packadd packer.nvim | lua require("plugins").%s]]

for k, v in pairs(packer_cmds) do
  vim.cmd(template:format(v[2] or "", k, v[1]))
end

-- Profiling
if uv.os_getenv "AK_PROFILER" == 1 then
  vim.cmd "packadd! profiler.nvim"
  require "profiler"
end

vim.cmd [[silent! colorscheme gruvbox8]]
