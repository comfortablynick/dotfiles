local vim = vim
local a = vim.api
local h = require "helpers"
local M = {}

function M.asyncGrep(term)
    if not term then
        a.nvim_err_writeln("asyncGrep: Search term missing")
        return
    end
    local results = {}
    local onread = function(err, data)
        if err then
            a.nvim_err_writeln(err)
        end
        if not data then
            return
        end
        for _, item in ipairs(vim.split(data, "\n")) do
            table.insert(results, item)
        end
    end
    local stdout = vim.loop.new_pipe(false)
    local stderr = vim.loop.new_pipe(false)
    local set_qf = function()
        vim.fn.setqflist({}, "r", {title = "Search Results", lines = results})
        a.nvim_command [[ cwindow ]]
    end
    handle = vim.loop.spawn(
                 "rg", {
            args = {term, "--vimgrep", "--smart-case"},
            stdio = {stdout, stderr},
        }, vim.schedule_wrap(
                     function()
                stdout:read_stop()
                stderr:read_stop()
                stdout:close()
                stderr:close()
                handle:close()
                set_qf(results)
            end
                 )
             )
    vim.loop.read_start(stdout, onread)
    vim.loop.read_start(stderr, onread)
end

function M.git_pull()
    h.spawn(
        "git", {args = {"pull"}}, function()
            print("Git pull complete")
        end
    )
end

return M
