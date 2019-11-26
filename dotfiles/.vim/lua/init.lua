local nvim = vim.api --luacheck: ignore
local vim = vim -- luacheck: ignore

-- Vim Settings
local general = {
    -- Shell to use instead of sh
    shell = "bash",
    -- Default line endings
    fileformat = "unix",
    -- Don't unload hidden buffers
    hidden = true,
    -- Use swapfile for edits
    swapfile = false,
    -- Read changes in files from outside vim
    autoread = true,
    -- Use true color
    termguicolors = false,
    -- Save file backups here
    backupdir = "~/.vim/backup//",
    -- Avoid redrawing the screen
    lazyredraw = false,
    -- Enable concealing, if defined
    conceallevel = 1,
    -- Don't conceal when cursor goes to line
    concealcursor = "",
    -- Allow cursor to extend past line
    virtualedit = "onemore",
    -- Allow loading of local .vimrc
    exrc = true,
    -- Don't execute code in local .vimrc
    secure = true
}

local editor = {
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
    shortmess = string.format("%s%s", nvim.nvim_get_option("shortmess"), "c"),
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

-- Buffer-local options
local buffer = {
    -- Max columns to syntax highlight (for performance)
    synmaxcol = 200
}

-- Window-local options
local window = {
    -- Always show; keep appearance consistent
    signcolumn = "yes"
}

local commands = {
    filetype = "indent plugin on",
    colorscheme = "default"
}

local function set_options()
    local global_settings = vim.tbl_extend("error", general, editor)
    for name, value in pairs(global_settings) do
        nvim.nvim_set_option(name, value)
    end

    for name, value in pairs(buffer) do
        nvim.nvim_buf_set_option(0, name, value)
    end

    for name, value in pairs(window) do
        nvim.nvim_win_set_option(0, name, value)
    end

    for name, value in pairs(commands) do
        nvim.nvim_command(string.format("%s %s", name, value))
    end
end

return {
    Set_Options = set_options
}
