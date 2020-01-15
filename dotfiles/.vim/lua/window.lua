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
function M.new_centered_floating(width, height)
    -- get the editor's max width and height
    -- local ed_width = M.get_usable_width()
    local ed_width = a.nvim_win_get_width(0)
    local ed_height = a.nvim_win_get_height(0)
    if not height and not width then
        -- if (ed_width > 150 or ed_height > 35) then
        -- window height is 3/4 of the max height, but not more than 30
        height = math.min(math.ceil(ed_height * 0.75), 30)
        width = math.ceil(ed_width * 0.75)
    end

    -- create a new, scratch buffer, for fzf
    local buf = a.nvim_create_buf(false, true)
    a.nvim_buf_set_option(buf, "buftype", "nofile")

    -- if the editor is big enough
    local opts = {
        relative = "editor",
        style = "minimal",
        width = width,
        height = height,
        anchor = "NW",
        focusable = false,
        -- row = math.ceil((height - ed_height) / 2),
        -- col = math.ceil((width - ed_width) / 2),
        row = ed_height - height,
        col = ed_width - width,
    }
    -- create a new floating window, centered in the editor
    a.nvim_open_win(buf, true, opts)
end

-- From: https://gist.github.com/norcalli/2a0bc2ab13c12d7c64efc7cdacbb9a4d
function M.float_term(command, scale_pct)
    -- local ed_width = M.get_usable_width(0)
    local ed_width = a.nvim_win_get_width(0)
    local ed_height = a.nvim_win_get_height(0)
    local pct = scale_pct or 50
    local width = math.floor(ed_width * pct / 100)
    local height = math.floor(ed_height * pct / 100)
    -- local opts = {
    --     relative = "editor",
    --     width = math.floor(width * pct / 100),
    --     height = math.floor(height * pct / 100),
    --     anchor = "NW",
    --     style = "minimal",
    --     focusable = false,
    -- }
    -- opts.col = math.floor((width - opts.width) / 2)
    -- opts.row = math.floor((height - opts.height) / 2)
    -- local bufnr = a.nvim_create_buf(false, true)
    -- local winnr = a.nvim_open_win(bufnr, true, opts)

    M.new_centered_floating(width, height)
    a.nvim_call_function("termopen", {command})
    -- return bufnr, winnr
end

return M
