-- init.lua
local env = vim.env
local o = vim.opt
local g = vim.g
local fn = vim.fn

require "nvim"
require "globals"

-- Global variables
g.python3_host_prog = env.NVIM_PY3_DIR
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

-- Directories
-- TODO: create if they don't exist
o.undodir = env.XDG_CACHE_HOME .. "/nvim/undo//"
o.shadafile = fn.stdpath "data" .. "/shada/main.shada"
o.backupdir = env.HOME .. "/.vim/backup//"
g.package_path = fn.stdpath "data" .. "/site"

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
o.shortmess:append { c = true }
o.clipboard = "unnamed"
o.ruler = false
o.showmatch = true
o.updatetime = 700
o.signcolumn = "yes"
o.scrolloff = 10
o.timeoutlen = 800
o.mouse = "a"
o.conceallevel = 1
o.virtualedit = { onemore = true }
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
  -- "vim-doge",
  "vim-toml",
  "vim-projectionist",
  "plenary.nvim",
  "nvim-lspconfig",
  "lsp-status.nvim",
  "nvim-compe",
  "lspsaga.nvim",
  "LuaSnip",
  "friendly-snippets",
  "nvim-bufferline.lua",
  "vim-dirvish",
}

for _, pack in ipairs(packs) do
  vim.cmd("silent! packadd! " .. pack)
end

vim.defer_fn(function()
  vim.cmd [[doautocmd User PackLoad]]
end, 200)

require "nvim"
require "globals"
require "config.treesitter"
require "config.devicons"
require("config.lsp").init()

vim.cmd [[
augroup init_lua
    autocmd!
    autocmd ColorScheme * lua require'config.lsp'.set_hl()
    autocmd BufEnter * lua require'config.compe'.init()
    autocmd BufWritePost lua/plugins.lua lua nvim.reload()
    autocmd BufWritePost lua/plugins.lua PackerInstall
    autocmd BufWritePost lua/plugins.lua PackerCompile
augroup END
]]

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
if env.AK_PROFILER == 1 then
  vim.cmd "packadd! profiler.nvim"
  require "profiler"
end

vim.cmd [[silent! colorscheme gruvbox8]]
