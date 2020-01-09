local vim = vim
local a = vim.api
local M = {}

-- Calculate usable width of window
-- Takes into account sign column, numberwidth, and foldwidth
function M.get_usable_width(winnr)
    local width = a.nvim_win_get_width(winnr or 0)
    local numberwidth = math.max(
                            vim.wo.numberwidth,
                            string.len(a.nvim_buf_line_count(0)) + 1
                        )
    local numwidth = (vim.wo.number or vim.wo.relativenumber) and numberwidth or
                         0
    local foldwidth = vim.wo.foldcolumn
    local signwidth = 0
    local signs
    if vim.wo.signcolumn == "yes" then
        signwidth = 2
    elseif vim.wo.signcolumn == "auto" then
        signs = vim.split(
                    vim.fn.execute(
                        ("sign place buffer=%d"):format(vim.fn.bufnr(""))
                    ), "\n"
                )
        signwidth = #signs > 3 and 2 or 0
    end
    return width - numwidth - foldwidth - signwidth
end

-- Adapted From: https://gabrielpoca.com/2019-11-13-a-bit-more-lua-in-your-vim/
function M.new_centered_floating()
    -- get the editor's max width and height
    local width = M.get_usable_width()
    local height = a.nvim_win_get_height(0)

    -- create a new, scratch buffer, for fzf
    local buf = a.nvim_create_buf(false, true)
    a.nvim_buf_set_option(buf, "buftype", "nofile")

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
        a.nvim_open_win(buf, true, opts)
    end
end

return M
