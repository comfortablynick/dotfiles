local nvim = require "helpers"
local vim = vim

local M = {}
local MINIMAP = "vim-minimap"
local WIDTH = 30

function M.show_minimap()
    local buflines = vim.api.nvim_buf_get_lines(0, 0, -1, 0)
    local src = vim.api.nvim_win_get_number(0)
    local buf_opts = {
        buftype = "nofile",
        bufhidden = "wipe",
        swapfile = false,
        buflisted = false,
    }
    local autocmds = {
        minimap = {
            {"WinEnter", "<buffer>", "if winnr('$') == 1|q|endif"},
            -- {"CursorMoved,CursorMovedI,TextChanged,TextChangedI,BufWinEnter", "*", "MinimapUpdate"}
        },
    }
    -- TODO: replace with nvim_create_buf(false, true)?
    vim.cmd(("botright vnew %s"):format(MINIMAP))
    -- vim.cmd("setlocal nonumber norelativenumber nolist nospell")
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.list = false
    vim.wo.spell = false
    for name, value in pairs(buf_opts) do
        vim.bo[name] = value
    end
    nvim.create_augroups(autocmds)
    local minimap = 0
    vim.api.nvim_win_set_width(minimap, WIDTH)
    vim.api.nvim_win_set_option(minimap, "winfixwidth", true)
    buflines = table.concat(buflines, "\n")
    local maptext = vim.fn.system(("echo '%s' | text-minimap -x 2 -y 2"):format(
                                      buflines))
    vim.api.nvim_buf_set_lines(minimap, 0, -1, 0, vim.split(maptext, "\n"))
end

return M
