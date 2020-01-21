local vim = vim
local a = vim.api
local M = {}

function M.get_usable_width(winnr) -- {{{1
    -- Calculate usable width of window
    -- Takes into account sign column, numberwidth, and foldwidth
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
function M.new_centered_floating(width, height) -- deprecated - use create_centered_floating() {{{1
    -- get the editor's max width and height
    local ed_width = a.nvim_win_get_width(0)
    local ed_height = a.nvim_win_get_height(0)
    if not height and not width then
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
        row = ed_height - height,
        col = ed_width - width,
    }
    -- create a new floating window, centered in the editor
    a.nvim_open_win(buf, true, opts)
end

-- From: https://gist.github.com/norcalli/2a0bc2ab13c12d7c64efc7cdacbb9a4d
function M.float_term(command, scale_pct) -- {{{1
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

function M.create_centered_floating() -- {{{1
    local cols, lines = (function()
        local ui = a.nvim_list_uis()[1]
        return ui.width, ui.height
    end)()
    local width = math.min(cols - 4, math.min(100, cols - 20))
    local height = math.min(lines - 4, math.max(20, lines - 10))
    local top = ((lines - height) / 2) - 1
    local left = (cols - width) / 2
    local opts = {
        relative = "editor",
        row = top,
        col = left,
        width = width,
        height = height,
        style = "minimal",
    }
    -- Build border
    local border_top = "╭" .. string.rep("─", width - 2) .. "╮"
    local border_mid = "│" .. string.rep(" ", width - 2) .. "│"
    local border_bot = "╰" .. string.rep("─", width - 2) .. "╯"
    local border_lines = {}
    table.insert(border_lines, border_top)
    vim.list_extend(
        border_lines, vim.split(string.rep(border_mid, height - 2, "\n"), "\n")
    )
    table.insert(border_lines, border_bot)
    -- Create border buffer, window
    local border_buf = a.nvim_create_buf(false, true)
    a.nvim_buf_set_lines(border_buf, 0, -1, true, border_lines)
    local border_win = a.nvim_open_win(border_buf, true, opts)
    -- Create text buffer, window
    opts.row = opts.row + 1
    opts.height = opts.height - 2
    opts.col = opts.col + 2
    opts.width = opts.width - 4
    local text_buf = a.nvim_create_buf(false, true)
    local text_win = a.nvim_open_win(text_buf, true, opts)
    -- Set style
    a.nvim_win_set_option(border_win, "winhl", "Normal:Floating")
    a.nvim_win_set_option(text_win, "winhl", "Normal:Floating")
    -- Set autocmds
    vim.cmd(
        string.format(
            "autocmd WinClosed * ++once :bd! | call nvim_win_close(%d, v:true)",
            border_win
        )
    )
    return text_buf
end

function M.floating_help(query) -- {{{1
    local buf = M.create_centered_floating()
    a.nvim_set_current_buf(buf)
    vim.cmd "setl ft=help bt=help"
    vim.cmd("help " .. query)
end

-- Return module --{{{1
return M
