local vim = vim
require"helpers"
init = {}

-- Options {{{1
-- Global options {{{2
local global = {
    -- General {{{3
    background = "dark",
    -- Shared data file location
    shadafile = vim.env.XDG_DATA_HOME .. "/nvim/shada/main.shada",
    -- Shared data settings (use 20 instead of default 100 to speed up)
    -- shada = [[!,'20,<50,s10,h]],
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
    termguicolors = vim.env.MOSH_CONNECTION ~= "1",
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
    grepprg = (function()
        if vim.fn.executable("rg") then
            return [[rg --vimgrep --hidden --no-ignore-vcs --smart-case]]
        end
        if vim.fn.executable("ag") then
            return [[ag --vimgrep --hidden --skip-vcs-ignores --smart-case]]
        end
        return vim.o.grepprg
    end)(),
    grepformat = "%f:%l:%c:%m,%f:%l:%m",
    -- Editor {{{3
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
    -- Show default mode text (e.g. -- INSERT -- below statusline)
    showmode = true,
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
    timeoutlen = vim.env.MOSH_CONNECTION ~= "1" and 200 or 400,
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
    winblend = vim.env.MOSH_CONNECTION ~= "1" and 10 or 0,
}

-- Variables {{{1
-- Global variables {{{2
local global_vars = {
    -- Use powerline fonts with lightline
    LL_pl = (vim.env.POWERLINE_FONTS == "1" or vim.env.NERD_FONTS == "1") and 1 or
        0,
    -- Use nerd fonts with lightline
    LL_nf = (vim.env.NERD_FONTS == "1" and vim.env.MOSH_CONNECTION ~= "1") and 1 or
        0,
    -- Leader key
    mapleader = ",",
    -- Check existence of vim executable
    vim_exists = vim.fn.executable("vim"),
    -- Initial window size
    window_width = vim.o.columns,
    -- Debug {{{
    -- Disable package loading at start for troubleshooting
    -- no_load_packages = 1,
    -- }}}
    -- Disable default plugins {{{
    loaded_gzip = 1,
    loaded_tarPlugin = 1,
    loaded_2html_plugin = 1,
    loaded_zipPlugin = 1,
    loaded_matchit = 1,
    -- }}}
    -- Paths {{{
    -- Python 2 dir
    python_host_prog = vim.env.NVIM_PY2_DIR,
    -- Python 3 dir
    python3_host_prog = vim.env.NVIM_PY3_DIR,
    -- Default packages path
    package_path = vim.env.XDG_DATA_HOME .. "/nvim/site/pack",
    -- Path to find minpac plugin manager
    minpac_path = vim.env.XDG_DATA_HOME .. "/nvim/site/pack/minpac/opt/minpac",
    -- }}}
    -- Plugin settings {{{
    -- vim-lion extra spaces
    lion_squeeze_spaces = 1,
    -- vim-sneak
    ["sneak#label"] = 1,
    -- }}}
    -- Completion filetypes {{{
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
            "lua",
            "python",
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
            -- "python",
        },
    },
    nocompletion_filetypes = {"nerdtree"}, -- }}}
}

-- Lsp {{{2
vim.g.coc_fts = table.concat(global_vars.completion_filetypes.coc or {}, ",")
vim.g.lsp_fts = table.concat(global_vars.completion_filetypes["nvim-lsp"] or {},
                             ",")
-- if vim.g.coc_fts ~= "" then
--     table.insert(autocmds.init_lua,
--                  {"FileType", vim.g.coc_fts, "silent! packadd coc.nvim"})
-- end
-- if vim.g.lsp_fts ~= "" then
--     table.insert(autocmds.init_lua,
--                  {"FileType", vim.g.lsp_fts, "silent! packadd nvim-lsp"})
-- end

-- Maps {{{1
-- Map default options {{{2
local map_default_options = {silent = true, unique = true, noremap = true}

-- General editor maps {{{2
local general_maps = {
    -- indent/dedent
    -- ["v<Tab>"] = {"<Cmd>normal! >gv<CR>"},
    -- ["v<S-Tab>"] = {"<Cmd>normal! <gv<CR>"},
    -- -- Redo
    -- ["nU"] = {":redo<CR>"},
    -- -- Close/save from insert mode
    -- ["ikj"] = {"<Esc>`^"},
    -- ["ilkj"] = {"<Esc>`^:w<CR>"},
    -- ["i;lkj"] = {"<Esc>`^:wq<CR>"},
    -- ["n<CR>"] = {":noh<CR><CR>", silent = false},
    -- Pop-up menu
    ["i<Tab>"] = {[[pumvisible() ? "\<C-n>" : "\<Tab>"]], expr = true},
    ["i<S-Tab>"] = {[[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], expr = true},
    -- Shortcuts to open files
    ["n<Leader>il"] = {
        (":vsplit %s<CR>"):format(vim.env.XDG_DATA_HOME ..
                                      "/nvim/site/lua/init.lua"),
    },
    ["n<Leader>iv"] = {
        (":vsplit %s<CR>"):format(vim.env.XDG_CONFIG_HOME .. "/nvim/init.vim"),
    },
    ["n+"] = {":"},
    -- Make Y behave as D (yank to end of line)
    ["nY"] = {"y$"},
}

-- Navigation maps {{{2
local navigation_maps = {
--     -- Navigation
--     -- Line navigation in insert mode
--     ["i<C-k>"] = {"<Up>"},
--     ["i<C-j>"] = {"<Down>"},
--     ["i<C-h>"] = {"<Left>"},
--     ["i<C-l>"] = {"<Right>"},
--     -- CTRL+{h,j,k,l} to navigate in normal mode
--     -- Likely overridden by vim-tmux-navigator
--     ["n<C-k>"] = {"<C-w><C-k>"},
--     ["n<C-j>"] = {"<C-w><C-j>"},
--     ["n<C-h>"] = {"<C-w><C-h>"},
--     ["n<C-l>"] = {"<C-w><C-l>"},
--     -- ALT+{h,j,k,l} to navigate from any mode
--     -- Terminal
--     ["t<A-k>"] = {[[<C-\><C-N><C-w>k]]},
--     ["t<A-j>"] = {[[<C-\><C-N><C-w>j]]},
--     ["t<A-h>"] = {[[<C-\><C-N><C-w>h]]},
--     ["t<A-l>"] = {[[<C-\><C-N><C-w>l]]},
--     -- Insert
--     ["i<A-k>"] = {[[<C-\><C-N><C-w>k]]},
--     ["i<A-j>"] = {[[<C-\><C-N><C-w>j]]},
--     ["i<A-h>"] = {[[<C-\><C-N><C-w>h]]},
--     ["i<A-l>"] = {[[<C-\><C-N><C-w>l]]},
--     -- Normal
--     ["n<A-k>"] = {"<C-w>k"},
--     ["n<A-j>"] = {"<C-w>j"},
--     ["n<A-h>"] = {"<C-w>h"},
--     ["n<A-l>"] = {"<C-w>l"},
--     -- Delete window with d<C-h,j,k,l>
--     ["ndk"] = {"<C-w>k<C-w>c", silent = false},
--     ["ndj"] = {"<C-w>j<C-w>c"},
--     ["ndh"] = {"<C-w>h<C-w>c"},
--     ["ndl"] = {"<C-w>l<C-w>c", silent = false},
--     -- t + {h,l,n} to navigate tabs
--     ["nth"] = {":tabprev<CR>"},
--     ["ntl"] = {":tabnext<CR>"},
--     ["ntn"] = {":tabnew<CR>"},
--     -- b + {h,l,n} to navigate buffers
--     ["nbh"] = {":bprevious<CR>"},
--     ["nbl"] = {":bnext<CR>"},
--     -- gb: goto buffer
--     ["ngb"] = {":ls<CR>:b<Space>"},
--     -- Navigate wrapped lines normally with k/j
--     ["nk"] = {"v:count == 0 ? 'gk' : 'k'", expr = true},
--     ["nj"] = {"v:count == 0 ? 'gj' : 'j'", expr = true},
}

-- Functions {{{1
function init.text_object_comment_and_duplicate(is_visual_mode) -- {{{2
    local visual_mode = "line"
    local commentstring = vim.bo.commentstring
    local function comment_dupe(lines)
        local commented = {}
        for _, line in ipairs(lines) do
            table.insert(commented, commentstring:format(line))
        end
        return vim.tbl_flatten{lines, commented}
    end
    if is_visual_mode then
        nvim.buf_transform_region_lines(nil, "<", ">", visual_mode, comment_dupe)
    else
        nvim.text_operator_transform_selection(comment_dupe, visual_mode)
    end
end

nvim.define_text_object("gd", "init.text_object_comment_and_duplicate")

local function load_packages() -- {{{2
    if global_vars.no_load_packages == 1 then return end
    local packages = {
        -- "lightline.vim",
        -- "lightline-bufferline",
        "fzf.vim",
        "neoformat",
        "vim-surround",
        "vim-repeat",
        "vim-fugitive",
        "vim-scriptease",
        -- "vim-commentary",
        "vim-clap",
        "vim-snippets",
        "vim-tmux-navigator",
        "vim-lion",
        "vim-startify",
        "vista.vim",
        "vim-textobj-user",
        "vim-textobj-lua",
        "nvim-luadev",
        "clever-f.vim",
    }

    -- Delay these plugins until after vim window opens
    -- Helps with startuptime if plugins aren't needed right away
    vim.g.pack_deferred = {
        "targets.vim",
        "ale",
        "tcomment_vim",
    }

    if global_vars.LL_nf == 1 then
        table.insert(vim.g.pack_deferred, "vim-devicons")
    end
    for _, package in ipairs(packages) do
        vim.cmd("silent! packadd! " .. package)
    end
end

local function set_options() -- {{{2
    for name, value in pairs(global) do vim.o[name] = value end

    for name, value in pairs(buffer) do vim.bo[name] = value end

    for name, value in pairs(window) do vim.wo[name] = value end
end

local function set_globals() -- {{{2
    for name, value in pairs(global_vars) do vim.g[name] = value end
end

local function set_color() -- {{{2
    vim.g.vim_color = vim.env.NVIM_COLOR or "papercolor-dark"
    vim.g.vim_base_color = (function()
        local color = vim.env.NVIM_COLOR or "papercolor-dark"
        local sub, n = color:gsub("-dark$", "")
        if n == 0 then
            global.background = "light"
            sub = (color:gsub("-light$", ""))
        end
        return sub
    end)()
end


local function apply_maps() -- {{{2
    local maps = vim.tbl_extend("error", general_maps, navigation_maps)
    nvim.apply_mappings(maps, map_default_options)
end

-- Execute settings {{{2
set_options()
set_globals()
set_color()
apply_maps()
load_packages()

-- Load lua modules {{{2
require"lightline"

return init
-- vim:fdm=marker fdl=1 noml:
