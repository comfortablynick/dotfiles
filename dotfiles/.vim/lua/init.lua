local vim = vim
local helpers = require "helpers"

-- Options {{{1
-- Global options {{{2
local general = {
    background = "dark",
    -- Shared data file location
    shadafile = vim.env.XDG_DATA_HOME .. "/nvim/shada/main.shada",
    -- Shared data settings (use 20 instead of default 100 to speed up)
    shada = [[!,'20,<50,s10,h]],
    -- Live substitution
    inccommand = "split",
    -- Shell to use instead of sh
    -- shell = vim.o.shell:match("fish") and "bash" or vim.o.shell,
    shell = "sh",
    -- Don't unload hidden buffers
    hidden = true,
    -- Read changes in files from outside vim
    autoread = true,
    -- Use true color
    termguicolors = vim.env.VIM_SSH_COMPAT ~= "1",
    -- Undo file dir
    undodir = (function()
        local dir = vim.env.HOME .. "/.vim/undo"
        os.execute("mkdir -p " .. dir)
        return dir .. "//"
    end)(),
    -- Backups
    backup = true,
    backupdir = (function()
        local dir = "/tmp/neovim_backup"
        os.execute("mkdir -p " .. dir)
        return dir .. "//"
    end)(),
    writebackup = true,
    backupcopy = "auto",
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
    grepprg = vim.fn.executable("rg") and
        [[rg --vimgrep --hidden --no-ignore-vcs]] or vim.o.grepprg,
    grepformat = "%f:%l:%c:%m,%f:%l:%m",
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
    shortmess = vim.o.shortmess .. "c",
    -- Dictionary file for dict completion
    dictionary = vim.o.dictionary .. "/usr/share/dict/words-insane",
    -- Use system clipboard
    clipboard = "unnamed",
    -- Line position (not needed if using a statusline plugin
    ruler = false,
    -- Show matching pair of brackets (), [], {}
    showmatch = true,
    -- Update more often (helps tools which use sign column)
    updatetime = 300,
    -- Lines before/after cursor during scroll
    scrolloff = 10,
    -- Don't move to start of line with j/k
    startofline = false,
    -- How long in ms to wait for key combinations
    ttimeoutlen = 10,
    -- How long in ms to wait for map combinations
    -- (Allow more time on MOSH connections)
    timeoutlen = vim.env.VIM_SSH_COMPAT ~= "1" and 200 or 400,
    -- Use mouse in all modes (allows mouse scrolling in tmux)
    mouse = "a",
}

-- Buffer-local options {{{2
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
    formatoptions = (vim.bo.formatoptions:gsub("o", "")),
}

-- Window-local options {{{2
local window = {
    -- Show line under cursor's line (check autocmds)
    cursorline = true,
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
    concealcursor = "",
    -- Degree of transparency of floating windows
    -- 0 = opaque; 100 = transparent
    -- Only seems to take effect when termguicolors
    winblend = vim.env.VIM_SSH_COMPAT ~= "1" and 10 or 0,
}

-- Variables {{{1
-- Global variables {{{2
local global_vars = {
    -- Disable package loading at start for troubleshooting
    -- no_load_packages = 1,
    -- Disable default plugins
    loaded_gzip = 1,
    loaded_tarPlugin = 1,
    loaded_2html_plugin = 1,
    loaded_zipPlugin = 1,
    -- Leader key
    mapleader = ",",
    -- Python 2 dir
    python_host_prog = vim.env.NVIM_PY2_DIR,
    -- Python 3 dir
    python3_host_prog = vim.env.NVIM_PY3_DIR,
    -- Initial window size (use to determine if on iPad)
    window_width = vim.o.columns,
    -- Use powerline fonts with lightline
    LL_pl = (vim.env.POWERLINE_FONTS == "1" or vim.env.NERD_FONTS == "1") and 1 or
        0,
    -- Use nerd fonts with lightline
    LL_nf = (vim.env.NERD_FONTS == "1" and vim.env.VIM_SSH_COMPAT ~= "1") and 1 or
        0,
    -- Default packages path
    package_path = vim.env.XDG_DATA_HOME .. "/nvim/site/pack",
    -- Path to find minpac plugin manager
    minpac_path = vim.env.XDG_DATA_HOME .. "/nvim/site/pack/minpac/opt/minpac",
    -- vim-lion extra spaces
    lion_squeeze_spaces = 1,
    -- vim-sneak
    ["sneak#label"] = 1,
    -- Check existence of vim executable
    vim_exists = vim.fn.executable("vim"),
    -- Filetypes that will use a completion plugin
    completion_filetypes = {
        coc = {
            "c",
            "cpp",
            "fish",
            "go",
            "rust",
            "typescript",
            "javascript",
            "json",
            -- "lua",
            -- "python",
            "bash",
            "sh",
            "vim",
            "yaml",
            "snippets",
            "markdown",
            "toml",
            "txt",
            "mail",
            "pro",
            "ini",
            "muttrc",
            "cmake",
            "zig",
        },
        ["nvim-lsp"] = {
            -- "rust",
            "python",
        },
    },
    nocompletion_filetypes = {"nerdtree"},
    -- TODO: move color stuff to own func
    vim_color = vim.env.NVIM_COLOR or "papercolor-dark",
    vim_base_color = (function()
        local color = vim.env.NVIM_COLOR or "papercolor-dark"
        local sub, n = color:gsub("-dark$", "")
        if n == 0 then
            general.background = "light"
            sub = (color:gsub("-light$", ""))
        end
        return sub
    end)(),
}

-- Autocommands {{{1
-- General init {{{2
local autocmds = {
    init_lua = {
        -- Terminal starts in insert mode
        {"TermOpen", "*", "startinsert"},
        {"TermOpen", "*", [[tnoremap <buffer> <Esc> <C-\><C-n>]]},
        -- Close read-only filetypes with only 'q'
        {"FileType", "netrw,help", "nnoremap <silent> q :bd<CR>"},
        -- Create backup files with useful names
        {"BufWritePre", "*", [[let &bex = '@' . strftime("%F.%H:%M")]]},
    },
}

-- Maps {{{1
-- Map default options {{{2
local map_default_options = {silent = true, unique = true, noremap = true}

-- General editor maps {{{2
local general_maps = {
    -- toggle folds
    ["n<Space>"] = {"za"},
    ["nza"] = {"zA"},
    -- indent/dedent
    ["v<Tab>"] = {"<Cmd>normal! >gv<CR>"},
    ["v<S-Tab>"] = {"<Cmd>normal! <gv<CR>"},
    -- Redo
    ["nU"] = {":redo<CR>"},
    -- Close/save from insert mode
    ["ikj"] = {"<Esc>`^"},
    ["ilkj"] = {"<Esc>`^:w<CR>"},
    ["i;lkj"] = {"<Esc>`^:wq<CR>"},
    ["n<CR>"] = {":noh<CR><CR>", silent = false},
    -- Pop-up menu
    ["i<Tab>"] = {[[pumvisible() ? "\<C-n>" : <Tab>]], expr = true},
    ["i<S-Tab>"] = {[[pumvisible() ? "\<C-p>" : <S-Tab>]], expr = true},
    -- Shortcuts to open files
    ["n<Leader>il"] = {
        (":vsplit %s<CR>"):format(
            vim.env.XDG_DATA_HOME .. "/nvim/site/lua/init.lua"
        ),
    },
    ["n<Leader>iv"] = {
        (":vsplit %s<CR>"):format(vim.env.XDG_CONFIG_HOME .. "/nvim/init.vim"),
    },
    ["n+"] = {":"},
}

-- Navigation maps {{{2
local navigation_maps = {
    -- Navigation
    -- Line navigation in insert mode
    ["i<C-k>"] = {"<Up>"},
    ["i<C-j>"] = {"<Down>"},
    ["i<C-h>"] = {"<Left>"},
    ["i<C-l>"] = {"<Right>"},
    -- CTRL+{h,j,k,l} to navigate in normal mode
    -- Likely overridden by vim-tmux-navigator
    ["n<C-k>"] = {"<C-w><C-k>"},
    ["n<C-j>"] = {"<C-w><C-j>"},
    ["n<C-h>"] = {"<C-w><C-h>"},
    ["n<C-l>"] = {"<C-w><C-l>"},
    -- ALT+{h,j,k,l} to navigate from any mode
    -- Terminal
    ["t<A-k>"] = {[[<C-\><C-N><C-w>k]]},
    ["t<A-j>"] = {[[<C-\><C-N><C-w>j]]},
    ["t<A-h>"] = {[[<C-\><C-N><C-w>h]]},
    ["t<A-l>"] = {[[<C-\><C-N><C-w>l]]},
    -- Insert
    ["i<A-k>"] = {[[<C-\><C-N><C-w>k]]},
    ["i<A-j>"] = {[[<C-\><C-N><C-w>j]]},
    ["i<A-h>"] = {[[<C-\><C-N><C-w>h]]},
    ["i<A-l>"] = {[[<C-\><C-N><C-w>l]]},
    -- Normal
    ["n<A-k>"] = {"<C-w>k"},
    ["n<A-j>"] = {"<C-w>j"},
    ["n<A-h>"] = {"<C-w>h"},
    ["n<A-l>"] = {"<C-w>l"},
    -- Delete window with d<C-h,j,k,l>
    ["ndk"] = {"<C-w>k<C-w>c", silent = false},
    ["ndj"] = {"<C-w>j<C-w>c"},
    ["ndh"] = {"<C-w>h<C-w>c"},
    ["ndl"] = {"<C-w>l<C-w>c", silent = false},
    -- t + {h,l,n} to navigate tabs
    ["nth"] = {":tabprev<CR>"},
    ["ntl"] = {":tabnext<CR>"},
    ["ntn"] = {":tabnew<CR>"},
    -- b + {h,l,n} to navigate buffers
    ["nbh"] = {":bprevious<CR>"},
    ["nbl"] = {":bnext<CR>"},
    -- Navigate wrapped lines normally with k/j
    ["nk"] = {"v:count == 0 ? 'gk' : 'k'", expr = true},
    ["nj"] = {"v:count == 0 ? 'gj' : 'j'", expr = true},
}

-- Functions {{{1
local function load_packages() -- {{{2
    if global_vars.no_load_packages == 1 then
        return
    end
    local packages = {
        "lightline.vim",
        "lightline-bufferline",
        "fzf.vim",
        "ale",
        "vim-sneak",
        "vim-surround",
        "vim-repeat",
        "vim-localvimrc",
        "vim-clap",
        "vim-snippets",
        "vim-tmux-navigator",
        "vim-lion",
        "vim-markdown",
        "vim-symlink",
        "vim-startify",
    }
    if global_vars.LL_nf == 1 then
        table.insert(packages, "vim-devicons")
    end

    for _, package in ipairs(packages) do
        vim.cmd("silent! packadd! " .. package)
    end
end

local function set_options() -- {{{2
    local global_settings = vim.tbl_extend("error", general, editor)
    for name, value in pairs(global_settings) do
        vim.o[name] = value
    end

    for name, value in pairs(buffer) do
        vim.bo[name] = value
    end

    for name, value in pairs(window) do
        vim.wo[name] = value
    end
end

local function set_globals() -- {{{2
    for name, value in pairs(global_vars) do
        vim.g[name] = value
    end
end

local function create_cmds() -- {{{2
    for name, value in pairs(commands) do
        vim.cmd(name .. " " .. value)
    end
end

local function create_autocmds() -- {{{2
    helpers.create_augroups(autocmds)
end

local function apply_maps() -- {{{2
    local maps = vim.tbl_extend("error", general_maps, navigation_maps)
    helpers.apply_mappings(maps, map_default_options)
end

-- Execute settings {{{2
set_options()
set_globals()
apply_maps()
create_autocmds()
load_packages()
require "lightline"

-- vim:fdl=1:
