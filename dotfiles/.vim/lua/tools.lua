local vim = vim
local a = vim.api
local uv = vim.loop
local M = {}

function M.async_grep(term)
    if not term then
        a.nvim_err_writeln("async grep: Search term missing")
        return
    end
    local stdout = uv.new_pipe(false)
    local stderr = uv.new_pipe(false)
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
    handle = uv.spawn(
                 table.remove(grepprg, 1),
                 {args = {term, unpack(grepprg)}, stdio = {stdout, stderr}},
                 vim.schedule_wrap(onexit)
             )
    uv.read_start(stdout, onread)
    uv.read_start(stderr, onread)
end

-- GIT

-- TODO: figure out how to return stdout,stderr from these
-- in simplest way possible
function M.git_pull()
    nvim.spawn(
        "git", {args = {"pull"}}, function() print("Git pull complete") end
    )
end

function M.git_push()
    nvim.spawn(
        "git", {args = {"push"}}, function() print("Git push complete") end
    )
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

function M.set_executable(file)
    file = file or a.nvim_buf_get_name(0)
    local get_perm_str = function(dec_mode)
        local mode = string.format("%o", dec_mode)
        local perms = {
            [0] = "---", -- No access.
            [1] = "--x", -- Execute access.
            [2] = "-w-", -- Write access.
            [3] = "-wx", -- Write and execute access.
            [4] = "r--", -- Read access.
            [5] = "r-x", -- Read and execute access.
            [6] = "rw-", -- Read and write access.
            [7] = "rwx", -- Read, write and execute access.
        }
        local chars = {}
        for i = 4, #mode do
            table.insert(chars, perms[tonumber(mode:sub(i, i))])
        end
        return table.concat(chars)
    end
    local stat = uv.fs_stat(file)
    if stat == nil then
        a.nvim_err_writeln(string.format("File '%s' does not exist!", file))
        return
    end
    local orig_mode = stat.mode
    local orig_mode_oct = string.sub(string.format("%o", orig_mode), 4)
    nvim.spawn(
        "chmod", {args = {"u+x", file}}, function()
            local new_mode = uv.fs_stat(file).mode
            local new_mode_oct = string.sub(string.format("%o", new_mode), 4)
            local new_mode_str = get_perm_str(new_mode)
            if orig_mode ~= new_mode then
                printf(
                    "Permissions changed: %s (%s) -> %s (%s)",
                    get_perm_str(orig_mode), orig_mode_oct, new_mode_str,
                    new_mode_oct
                )
            else
                printf(
                    "Permissions not changed: %s (%s)", new_mode_str,
                    new_mode_oct
                )
            end
        end
    )
end

return M
