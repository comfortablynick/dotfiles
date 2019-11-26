local nvim = vim.api --luacheck: ignore

-- Vim Settings
local general = {
    shell = "bash",
    fileformat = "unix",
    hidden = true,
    swapfile = false,
    autoread = true,
    termguicolors = false,
    backupdir = "~/.vim/backup//",
    exrc = true,
    synmaxcol = 200,
    -- Always show statusline
    laststatus = 2,
    -- Always show tabline
    showtabline = 2,
    -- Visual bell instead of audible
    visualbell = true,
    wrap = false, -- Text wrapping mode
    showmode = false, -- Hide default mode text (e.g. -- INSERT -- below statusline)
    cmdheight = 1, -- Add extra line for function definition
    clipboard = "unnamed", -- Use system clipboard
    cursorline = false, -- Show line under cursor's line (check autocmds)
    ruler = false, -- Line position (not needed if using a statusline plugin
    showmatch = true, -- Show matching pair of brackets (), [], {}
    updatetime = 300, -- Update more often (helps GitGutter)
    signcolumn = "yes", -- Always show; keep appearance consistent
    scrolloff = 10, -- Lines before/after cursor during scroll
    ttimeoutlen = 10, -- How long in ms to wait for key combinations (if used)
    timeoutlen = 200, -- How long in ms to wait for key combinations (if used)
    mouse = "a", -- Use mouse in all modes (allows mouse scrolling in tmux)
    startofline = false, -- Don't move to start of line with j/k
    conceallevel = 1, -- Enable concealing, if defined
    concealcursor = "", -- Don't conceal when cursor goes to line
    virtualedit = "onemore", -- Allow cursor to extend past line
    secure = true
}

local all_settings = {
    general
}

for name, value in pairs(unpack(all_settings)) do
    nvim.nvim_set_option(name, value)
end
