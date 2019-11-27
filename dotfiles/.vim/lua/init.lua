local nvim = require("nvim")

local HOMEDIR = nvim.env.HOME

-- Commands {{{1
local commands = {
    filetype = "indent plugin on",
    colorscheme = "default"
}

-- Global options {{{1
local general = {
    -- Shared data file location
    shadafile = nvim.env.XDG_DATA_HOME .. "/nvim/shada/main.shada",
    -- Live substitution
    inccommand = "split",
    -- Shell to use instead of sh
    shell = "bash",
    -- Don't unload hidden buffers
    hidden = true,
    -- Read changes in files from outside vim
    autoread = true,
    -- Use true color
    termguicolors = true,
    -- Undo file dir
    undodir = HOMEDIR .. "/.vim/undo//",
    -- Save file backups here
    backupdir = HOMEDIR .. "/.vim/backup//",
    -- Avoid redrawing the screen
    lazyredraw = false,
    -- Allow cursor to extend past line
    virtualedit = "onemore",
    -- Allow loading of local .vimrc
    exrc = true,
    -- Don't execute code in local .vimrc
    secure = true,
    -- Ignore case while searching
    ignorecase = true,
    -- Case sensitive if uppercase in pattern
    smartcase = true,
    -- Move cursor to matched string
    incsearch = true,
    -- Magic escaping for regex
    magic = true,
    -- Global replacement by default
    gdefault = true,
    -- Split right instead of left
    splitright = true,
    -- Split below instead of above
    splitbelow = true,
    -- Program used for grep
    grepprg = (function()
        if nvim.fn.executable("rg") then
            return [[rg --vimgrep --hidden --no-ignore-vcs]]
        else
            return nvim.o.grepprg
        end
    end)(),
    grepformat = "%f:%l:%c:%m,%f:%l:%m"
}

local editor = {
    -- Backspace behaves as expected
    backspace = "2",
    -- Always show statusline
    laststatus = 2,
    -- Always show tabline
    showtabline = 2,
    -- Visual bell instead of audible
    visualbell = true,
    -- Text wrapping mode
    wrap = false,
    -- Hide default mode text (e.g. -- INSERT -- below statusline)
    showmode = false,
    -- Add extra line for function definition
    cmdheight = 1,
    -- Suppress echoing of 'Match x of x' during completion
    shortmess = nvim.o.shortmess .. "c",
    -- Dictionary file for dict completion
    dictionary = nvim.o.dictionary .. "/usr/share/dict/words-insane",
    -- Use system clipboard
    clipboard = "unnamed",
    -- Show line under cursor's line (check autocmds)
    cursorline = false,
    -- Line position (not needed if using a statusline plugin
    ruler = false,
    -- Show matching pair of brackets (), [], {}
    showmatch = true,
    -- Update more often (helps GitGutter)
    updatetime = 300,
    -- Lines before/after cursor during scroll
    scrolloff = 10,
    -- Don't move to start of line with j/k
    startofline = false,
    -- How long in ms to wait for key combinations (if used)
    ttimeoutlen = 10,
    -- How long in ms to wait for key combinations (if used)
    timeoutlen = 200,
    -- Use mouse in all modes (allows mouse scrolling in tmux)
    mouse = "a"
}

-- Buffer-local options {{{1
local buffer = {
    -- Default line endings
    fileformat = "unix",
    -- Enable persistent undo
    undofile = true,
    -- Use swapfile for edits
    swapfile = false,
    -- Max columns to syntax highlight (for performance)
    synmaxcol = 200,
    -- Expand tab to spaces
    expandtab = true,
    -- Attempt smart indenting
    smartindent = true,
    -- Attempt auto indenting
    autoindent = true,
    -- Width of shift (0=tabstop)
    shiftwidth = 0,
    -- How many spaces a tab is worth
    tabstop = 4,
    -- Don't insert comment leader after hitting 'o' or 'O'
    -- If still present, overwrite in after/ftplugin/filetype.vim
    formatoptions = (nvim.bo.formatoptions:gsub("o", ""))
}

-- Window-local options {{{1
local window = {
    -- Always show sign column
    signcolumn = "yes",
    -- Enable folds by default
    foldenable = true,
    -- Fold using markers by default
    foldmethod = "marker",
    -- Max nested levels (default=20)
    foldnestmax = 5,
    -- Show linenumbers
    number = true,
    -- Show relative numbers (hybrid with `number` enabled)
    relativenumber = true,
    -- Enable concealing, if defined
    conceallevel = 1,
    -- Don't conceal when cursor goes to line
    concealcursor = ""
}

-- Global variables {{{1
local global_vars = {
    -- Leader key
    mapleader = ",",
    -- Python 2 dir
    python_host_prog = nvim.env.NVIM_PY2_DIR,
    -- Python 3 dir
    python3_host_prog = nvim.env.NVIM_PY3_DIR,
    -- Initial window size (use to determine if on iPad)
    window_width = nvim.o.columns,
    -- Use powerline fonts with lightline
    LL_pl = 1,
    -- Use nerd fonts with lightline
    LL_nf = 1
}

-- Autocommands {{{1
local autocmds = {
    terminal = {
        {"TermOpen", "*", "startinsert"},
        {"TermOpen", "*", [[tnoremap <buffer> <Esc> <C-\><C-n>]]}
    }
}

-- Maps {{{1
local map_default_options = {silent = true, unique = true}
local mappings = {
    -- toggle folds
    ["n<Space>"] = {"za"},
    ["nza"] = {"zA"},
    -- indent/dedent
    ["v<Tab>"] = {[[>><ESC>gv]]},
    ["v<S-Tab>"] = {[[<<<ESC>gv]]}
    --
}

-- set_options() :: Loop through options and set them in vim {{{1
local function set_options()
    local global_settings = vim.tbl_extend("error", general, editor)
    for name, value in pairs(global_settings) do
        nvim.o[name] = value
    end

    for name, value in pairs(buffer) do
        nvim.bo[name] = value
    end

    for name, value in pairs(window) do
        nvim.wo[name] = value
    end

    for name, value in pairs(commands) do
        nvim.command(name .. " " .. value)
    end

    for name, value in pairs(global_vars) do
        nvim.g[name] = value
    end

    nvim.create_augroups(autocmds)
    nvim.apply_mappings(mappings, map_default_options)
end

return {
    Set_Options = set_options
}

-- vim:fdl=1:
