local o = vim.opt
local g = vim.g
local fn = vim.fn
local uv = vim.loop
local api = vim.api
local map = vim.keymap
local shell = "/bin/sh"

-- Profiling
if uv.os_getenv "AK_PROFILER" == "1" then
  vim.cmd "packadd! profiler.nvim"
  require "profiler"
end

pcall(require, "impatient") -- TODO: remove this once PR is merged
require "nvim"
require "globals"

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

o.path = {
  ".", -- Directory of current file
  "", -- Current directory
  "**", -- Recursive search
}

o.wildmode = { "longest", "full" }
o.wildoptions = { "pum" }
o.wildignore:append { "__pycache__", ".mypy_cache", ".git" }

-- Grep
if fn.executable "ugrep" == 1 then
  o.grepprg = "ugrep -RInkju --ignore-files --tabs=1"
  o.grepformat = { "%f:%l:%c:%m", "%f+%l+%c+%m", [[%-G%f\|%l\|%c\|%m]] }
elseif fn.executable "rg" == 1 then
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
  "nvim-lsp-ts-utils",
  "nvim-notify",
  "lsp-status.nvim",
  "fidget.nvim",
  "nvim-cmp",
  "cmp-nvim-lsp",
  "cmp-buffer",
  "cmp-path",
  "cmp-nvim-ultisnips",
  "nvim-web-devicons",
  "vim-dirvish",
  "vim-clap",
  "vim-obsession",
  "vimtex",
}

for _, pack in ipairs(packs) do
  vim.cmd.packadd { pack, bang = true, mods = { emsg_silent = true } }
end

vim.defer_fn(function()
  api.nvim_exec_autocmds("User", { pattern = "PackLoad" })
end, 200)

require "nvim"
require "globals"
require "map"
require "config.statusline"
require "config.treesitter"
require "config.devicons"
require("config.lsp").init()

-- General autocmds
local aug = api.nvim_create_augroup("init_lua", { clear = true })

local reloaded_id = nil
api.nvim_create_autocmd("BufWritePost", {
  group = aug,
  pattern = "*nvim/**.lua",
  desc = "Reload config files",
  callback = function(event)
    ---@type string
    local file = event.match
    local mod = file:match "/lua/(.*)%.lua"
    if mod then
      mod = mod:gsub("/", ".")
    end
    if mod then
      package.loaded[mod] = nil
      reloaded_id = vim.notify("Reloaded " .. mod, vim.log.levels.INFO, { title = "nvim", replace = reloaded_id })
    end
    -- nvim.reload()
  end,
})

api.nvim_create_autocmd("BufWritePost", {
  group = aug,
  pattern = "lua/plugins.lua",
  desc = "Run packer commands",
  callback = function()
    local pack = require "plugins"

    -- nvim.reload()
    pack.clean()
    pack.install()
    pack.compile()
  end,
})

api.nvim_create_autocmd("CmdwinEnter", {
  group = aug,
  desc = "Custom cmdwin settings",
  callback = function()
    for _, lhs in ipairs { "<Leader>q", "<Esc>", "cq" } do
      map.set("n", lhs, "<C-c><C-c>", { buffer = true })
    end

    vim.wo.number = true
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
  end,
})

api.nvim_create_autocmd("ColorScheme", {
  group = aug,
  desc = "Set statusline highlights",
  callback = function()
    require("config.lsp").set_hl()
    statusline.set_hl()
  end,
})

api.nvim_create_autocmd("TermOpen", {
  group = aug,
  desc = "Set options for terminal windows",
  callback = function()
    -- vim.cmd "startinsert"
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
    vim.bo.buflisted = false
  end,
})

api.nvim_create_autocmd("TextYankPost", {
  group = aug,
  desc = "Highlight yanked text",
  callback = function()
    -- Looks best with color attribute gui=reverse
    vim.highlight.on_yank { higroup = "TermCursor", timeout = 750 }
  end,
})

api.nvim_create_autocmd(
  "QuitPre",
  { group = aug, desc = "Autoclose unneeded buffers", command = "silent call buffer#autoclose()" }
)

if vim.wo.cursorline then
  api.nvim_create_autocmd({ "WinEnter", "InsertLeave" }, {
    group = aug,
    desc = "Toggle cursorline if window in focus",
    callback = function()
      vim.wo.cursorline = true
    end,
  })
  api.nvim_create_autocmd({ "WinLeave", "InsertEnter" }, {
    group = aug,
    desc = "Toggle cursorline if window not in focus",
    callback = function()
      vim.wo.cursorline = false
    end,
  })
end

if vim.wo.relativenumber then
  api.nvim_create_autocmd({ "FocusGained", "WinEnter", "BufEnter", "InsertLeave" }, {
    group = aug,
    desc = "Toggle relativenumber if window in focus",
    callback = function()
      if vim.wo.number and vim.bo.buftype == "" and not vim.b.no_toggle_line_numbers then
        vim.wo.relativenumber = true
      end
    end,
  })
  api.nvim_create_autocmd({ "FocusLost", "WinLeave", "BufLeave", "InsertEnter" }, {
    group = aug,
    desc = "Toggle relativenumber if window not in focus",
    callback = function()
      if vim.wo.number and vim.bo.buftype == "" and not vim.b.no_toggle_line_numbers then
        vim.wo.relativenumber = false
      end
    end,
  })
end

local packer_cmds = {
  PackerInstall = require("plugins").install,
  PackerUpdate = require("plugins").update,
  PackerSync = require("plugins").sync,
  PackerClean = require("plugins").clean,
  PackerCompile = require("plugins").compile,
  PackerStatus = require("plugins").status,
}

for k, v in pairs(packer_cmds) do
  api.nvim_create_user_command(k, v, {})
end


vim.cmd.colorscheme { "gruvbox", mods = { emsg_silent = true } }
