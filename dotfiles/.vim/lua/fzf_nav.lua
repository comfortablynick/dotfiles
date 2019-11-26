local nvim = vim.api --luacheck: ignore

-- From: https://gabrielpoca.com/2019-11-13-a-bit-more-lua-in-your-vim/
local function NavigationFloatingWin()
    -- get the editor's max width and height
    local width = nvim.nvim_win_get_width(0)
    local height = nvim.nvim_win_get_height(0)

    -- create a new, scratch buffer, for fzf
    local buf = nvim.nvim_create_buf(false, true)
    nvim.nvim_buf_set_option(buf, "buftype", "nofile")

    -- if the editor is big enough
    if (width > 150 or height > 35) then
        -- fzf's window height is 3/4 of the max height, but not more than 30
        local win_height = math.min(math.ceil(height * 3 / 4), 30)
        local win_width

        -- if the width is small
        if (width < 150) then
            -- just subtract 8 from the editor's width
            win_width = math.ceil(width - 8)
        else
            -- use 90% of the editor's width
            win_width = math.ceil(width * 0.9)
        end

        -- settings for the fzf window
        local opts = {
            relative = "editor",
            style = "minimal",
            width = win_width,
            height = win_height,
            row = math.ceil((height - win_height) / 2),
            col = math.ceil((width - win_width) / 2)
        }

        -- create a new floating window, centered in the editor
        nvim.nvim_open_win(buf, true, opts)
    end
end

return {
    NavigationFloatingWin = NavigationFloatingWin,
}
