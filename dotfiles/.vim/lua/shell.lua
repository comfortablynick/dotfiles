-- From: https://gist.github.com/norcalli/2a0bc2ab13c12d7c64efc7cdacbb9a4d
local vim = vim
local a = vim.api
local win = require "window"
local M = {}

-- Designed to run a buffer with vim commands on each line.
-- Not that useful to me, but keep the code for future reuse.
local function run_script(lines, start, starting_winnr)
    starting_winnr = starting_winnr or a.nvim_get_current_win()
    for i = (start or 1), #lines do
        local line = lines[i]
        if line:match("^:!") then
            local command = line:sub(3)
            local bufnr, _ = win.float_term(command)
            vim.cmd("startinsert!")
            a.nvim_buf_attach(
                bufnr, false, {
                    on_detach = vim.schedule_wrap(
                        function()
                            run_script(lines, i + 1, starting_winnr)
                        end
                    ),
                }
            )
            break
        else
            a.nvim_set_current_win(starting_winnr)
            a.nvim_win_set_cursor(starting_winnr, {i, 0})
            vim.cmd(line)
        end
    end
end

function M.run_file() run_script(a.nvim_buf_get_lines(0, 0, -1, false)) end
return M
