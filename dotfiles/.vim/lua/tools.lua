local vim = vim
local a = vim.api
local uv = vim.loop
local h = require "helpers"
local M = {}

function M.async_grep(term)
    if not term then
        a.nvim_err_writeln("async grep: Search term missing")
        return
    end
    local stdout = vim.loop.new_pipe(false)
    local stderr = vim.loop.new_pipe(false)
    local results = {}
    local onread = function(err, data)
        assert(not err, err)
        if not data then return end
        for _, item in ipairs(vim.split(data, "\n")) do
            if item ~= "" then table.insert(results, item) end
        end
    end
    local onexit = function()
        stdout:close()
        stderr:close()
        handle:close()
        vim.fn.setqflist({}, "r", {title = "Search Results", lines = results})
        local result_ct = #results
        if result_ct > 0 then
            vim.cmd("copen " .. math.min(result_ct, 10))
        else
            print "grep: no results found"
        end
    end
    local grepprg = vim.split(vim.o.grepprg, " ")
    -- local grepprg = vim.split("rg --vimgrep --smart-case", " ")
    handle = vim.loop.spawn(
                 table.remove(grepprg, 1),
                 {args = {term, unpack(grepprg)}, stdio = {stdout, stderr}},
                 vim.schedule_wrap(onexit)
             )
    vim.loop.read_start(stdout, onread)
    vim.loop.read_start(stderr, onread)
end

-- GIT

-- TODO: figure out how to return stdout,stderr from these
-- in simplest way possible
function M.git_pull()
    h.spawn("git", {args = {"pull"}}, function() print("Git pull complete") end)
end

function M.git_push()
    h.spawn("git", {args = {"push"}}, function() print("Git push complete") end)
end

-- Test lower level vim apis
function M.scandir(path)
    local d = uv.fs_scandir(vim.fn.expand(path))
    local out = {}
    while true do
        local name, type = uv.fs_scandir_next(d)
        if not name then break end
        table.insert(out, {name, type})
    end
    print(vim.inspect(out))
end

function M.readdir(path)
    local handle = uv.fs_opendir(vim.fn.expand(path), nil, 10)
    local out = {}
    while true do
        local entry = uv.fs_readdir(handle)
        if not entry then break end
        -- use list_extend because readdir
        -- outputs table with each iteration
        vim.list_extend(out, entry)
    end
    print(vim.inspect(out))
    uv.fs_closedir(handle)
end
return M
