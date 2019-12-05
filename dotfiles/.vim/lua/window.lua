local vim = vim
assert(vim)

-- Calculate actual usable width of window
local function get_usable_width(winnr)
    local function split(s, delim)
        local result = {}
        for match in (s .. delim):gmatch("(.-)" .. delim) do
            table.insert(result, match)
        end
        return result
    end
    local width = vim.api.nvim_win_get_width(winnr or 0)
    local numberwidth = math.max(vim.wo.numberwidth,
                                 string.len(vim.api.nvim_buf_line_count(0)) + 1)
    local numwidth = (vim.wo.number or vim.wo.relativenumber) and numberwidth or
                         0
    local foldwidth = vim.wo.foldcolumn
    local signwidth = 0
    local signs
    if vim.wo.signcolumn == "yes" then
        signwidth = 2
    elseif vim.wo.signcolumn == "auto" then
        signs = split(vim.fn.execute(("sign place buffer=%d"):format(
                                         vim.fn.bufnr(""))), "\n")
        signwidth = #signs > 3 and 2 or 0
    end
    -- return {
    --     width = width,
    --     numwidth = numwidth,
    --     foldwidth = foldwidth,
    --     signwidth = signwidth,
    --     signs = signs or {},
    -- }
    return width - numwidth - foldwidth - signwidth
end
-- From: https://gabrielpoca.com/2019-11-13-a-bit-more-lua-in-your-vim/
local function centered_floating_win()
    -- get the editor's max width and height
    local width = get_usable_width(nil)
    local height = vim.api.nvim_win_get_height(0)

    -- create a new, scratch buffer, for fzf
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, "buftype", "nofile")

    -- if the editor is big enough
    if (width > 150 or height > 35) then
        -- fzf's window height is 3/4 of the max height, but not more than 30
        local win_height = math.min(math.ceil(height * 0.75), 30)
        local win_width = math.ceil(width * 0.9)
        local opts = {
            relative = "editor",
            style = "minimal",
            width = win_width,
            height = win_height,
            row = math.ceil((height - win_height) / 2),
            col = math.ceil((width - win_width) / 2),
        }
        -- create a new floating window, centered in the editor
        vim.api.nvim_open_win(buf, true, opts)
    end
end

return {
    centered_floating_win = centered_floating_win,
    get_usable_width = get_usable_width,
}