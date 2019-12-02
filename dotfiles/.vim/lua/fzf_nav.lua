local nvim = require "nvim"

-- From: https://gabrielpoca.com/2019-11-13-a-bit-more-lua-in-your-vim/
local function NavigationFloatingWin()
    -- get the editor's max width and height
    local width = nvim.win_get_width(0)
    local height = nvim.win_get_height(0)

    -- create a new, scratch buffer, for fzf
    local buf = nvim.create_buf(false, true)
    nvim.buf_set_option(buf, "buftype", "nofile")

    -- if the editor is big enough
    if (width > 150 or height > 35) then
        -- fzf's window height is 3/4 of the max height, but not more than 30
        local win_height = math.min(math.ceil(height * 3 / 4), 30)
        local win_width = math.ceil((width < 150 and width - 12) or width * 0.9)

        -- settings for the fzf window
        local opts = {
            relative = "editor",
            style = "minimal",
            width = win_width,
            height = win_height,
            row = math.ceil((height - win_height) / 2),
            col = math.ceil((width - win_width) / 2),
        }

        -- create a new floating window, centered in the editor
        nvim.open_win(buf, true, opts)
    end
end

return {NavigationFloatingWin = NavigationFloatingWin}
