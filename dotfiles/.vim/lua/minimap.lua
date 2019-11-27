local nvim = require('nvim')
local M = {}
local MINIMAP = "vim-minimap"
local WIDTH = 20

function M.show_minimap()
    local src = nvim.win_get_number(0)
    local buf_opts = {
        buftype = "nofile",
        bufhidden = "wipe",
        swapfile = false,
        buflisted = false,
    }
    local autocmds = {
        minimap = {
            {"WinEnter", "<buffer>", "if winnr($) == 1|q|endif"},
            -- {"CursorMoved,CursorMovedI,TextChanged,TextChangedI,BufWinEnter", "*", "MinimapUpdate"}
        }
    }
    -- TODO: replace with nvim_create_buf(false, true)?
    nvim.command(("botright vnew %s"):format(MINIMAP))
    nvim.command("setlocal nonumber norelativenumber nolist nospell")
    for name, value in pairs(buf_opts) do
        nvim.bo[name] = value
    end
    nvim_create_augroups(autocmds)
    local minimap = nvim.get_window(0)
    nvim.win_set_width(minimap, WIDTH)
    nvim.win_set_option(minimap, "winfixwidth", true)
end

return M
