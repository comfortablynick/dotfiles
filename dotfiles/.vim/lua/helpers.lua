--- NVIM SPECIFIC SHORTCUTS
--- Customized from:
--- https://github.com/norcalli/nvim_utils/blob/master/lua/nvim_utils.lua
local vim = vim
local a = vim.api

local VISUAL_MODE = {
    line = "line", -- linewise
    block = "block", -- characterwise
    char = "char", -- blockwise-visual
}

-- An enhanced version of nvim_buf_get_mark which also accepts:
-- - A number as input: which is taken as a line number.
-- - A pair, which is validated and passed through otherwise.
local function nvim_mark_or_index(buf, input)
    if type(input) == "number" then
        -- TODO how to handle column? It would really depend on whether this was the opening mark or ending mark
        -- It also doesn't matter as long as the functions are respecting the mode for transformations
        assert(input ~= 0, "Line number must be >= 1 or <= -1 for last line(s)")
        return {input, 0}
    elseif type(input) == "table" then
        -- TODO Further validation?
        assert(#input == 2)
        assert(input[1] >= 1)
        return input
    elseif type(input) == "string" then
        return a.nvim_buf_get_mark(buf, input)
    end
    assert(
        false, ("nvim_mark_or_index: Invalid input buf=%q, input=%q"):format(
            buf, input
        )
    )
end

--- Return the lines of the selection, respecting selection modes.
-- RETURNS: table
local function nvim_buf_get_region_lines(buf, mark_a, mark_b, mode)
    mode = mode or VISUAL_MODE.char
    buf = buf or 0
    mark_a = mark_a or "<"
    mark_b = mark_b or ">"

    local start = nvim_mark_or_index(buf, mark_a)
    local finish = nvim_mark_or_index(buf, mark_b)
    local lines = a.nvim_buf_get_lines(buf, start[1] - 1, finish[1], false)

    if mode == VISUAL_MODE.line then
        return lines
    end

    if mode == VISUAL_MODE.char then
        -- Order is important. Truncate the end first, because these are not commutative
        if finish[2] ~= 2147483647 then
            lines[#lines] = lines[#lines]:sub(1, finish[2] + 1)
        end
        if start[2] ~= 0 then
            lines[1] = lines[1]:sub(start[2] + 1)
        end
        return lines
    end
    -- TODO implement block mode selection @feature
    assert(false, "Invalid mode: " .. vim.inspect(mode))
end

local function nvim_buf_set_region_lines(buf, mark_a, mark_b, mode, lines)
    buf = buf or 0
    mark_a = mark_a or "<"
    mark_b = mark_b or ">"

    assert(mode == VISUAL_MODE.line, "Other modes aren't supported yet")

    local start = nvim_mark_or_index(buf, mark_a)
    local finish = nvim_mark_or_index(buf, mark_b)

    return a.nvim_buf_set_lines(buf, start[1] - 1, finish[1], false, lines)
end

-- This is actually more efficient if what you're doing is modifying a region
-- because it can save api calls.
-- It's also the only way to do transformations that are correct with `char` mode
-- since it has to have access to the initial values of the region lines.
local function nvim_buf_transform_region_lines(buf, mark_a, mark_b, mode, fn)
    buf = buf or 0
    mark_a = mark_a or "<"
    mark_b = mark_b or ">"

    assert(mode ~= VISUAL_MODE.block, mode .. " mode is not supported yet")

    local start = nvim_mark_or_index(buf, mark_a)
    local finish = nvim_mark_or_index(buf, mark_b)

    assert(start and finish)
    local lines = a.nvim_buf_get_lines(buf, start[1] - 1, finish[1], false)
    local result
    if mode == VISUAL_MODE.char then
        local prefix = ""
        local suffix = ""
        if finish[2] ~= 2147483647 then
            suffix = lines[#lines]:sub(finish[2] + 2)
            lines[#lines] = lines[#lines]:sub(1, finish[2] + 1)
        end
        if start[2] ~= 0 then
            prefix = lines[1]:sub(1, start[2])
            lines[1] = lines[1]:sub(start[2] + 1)
        end
        result = fn(lines, mode)

        -- If I take the result being nil as leaving it unmodified, then I can use it
        -- to skip the set part and reuse this just to get fed the input.
        if result == nil then
            return
        end

        -- Sane defaults, assume that they want to erase things if it is nil or empty
        if result == nil or #result == 0 then
            result = {""}
        end

        -- Order is important. Truncate the end first, because these are not commutative
        -- TODO file a bug report about this, it's probably supposed to be -1
        if finish[2] ~= 2147483647 then
            result[#result] = result[#result] .. suffix
        end
        if start[2] ~= 0 then
            result[1] = prefix .. result[1]
        end
    elseif mode == VISUAL_MODE.line then
        result = fn(lines, mode)
        -- If I take the result being nil as leaving it unmodified, then I can use it
        -- to skip the set part and reuse this just to get fed the input.
        if result == nil then
            return
        end
    end

    return a.nvim_buf_set_lines(buf, start[1] - 1, finish[1], false, result)
end

-- Equivalent to `echo vim.inspect(...)`
local function nvim_print(...)
    if select("#", ...) == 1 then
        a.nvim_out_write(vim.inspect((...)))
    else
        a.nvim_out_write(vim.inspect{...})
    end
    a.nvim_out_write("\n")
end

--- Equivalent to `echo` EX command
local function nvim_echo(...)
    for i = 1, select("#", ...) do
        local part = select(i, ...)
        a.nvim_out_write(tostring(part))
        a.nvim_out_write(" ")
    end
    a.nvim_out_write("\n")
end

---
-- Higher level text manipulation utilities
---

local function nvim_set_selection_lines(lines)
    return nvim_buf_set_region_lines(nil, "<", ">", VISUAL_MODE.line, lines)
end

-- Return the selection as a string
-- RETURNS: string
local function nvim_selection(mode)
    return table.concat(


                   nvim_buf_get_region_lines(
                       nil, "<", ">", mode or VISUAL_MODE.char
                   ), "\n"
           )
end

-- Necessary glue for nvim_text_operator
-- Calls the lua function whose name is g:lua_fn_name and forwards its arguments
a.nvim_command [[
function! LuaExprCallback(...) abort
	return luaeval(g:lua_expr, a:000)
endfunction
]]

local function nvim_text_operator(fn)
    LUA_FUNCTION = fn -- luacheck: ignore
    vim.g.lua_expr = "LUA_FUNCTION(_A[1])"
    vim.o.opfunc = "LuaExprCallback"
    a.nvim_feedkeys("g@", "ni", false)
end

local function nvim_text_operator_transform_selection(fn, forced_visual_mode)
    return nvim_text_operator(
               function(visualmode)
            nvim_buf_transform_region_lines(
                nil, "[", "]", forced_visual_mode or visualmode, function(lines)
                    return fn(lines, visualmode)
                end
            )
        end
           )
end

local function nvim_visual_mode()
    local visualmode = vim.fn.visualmode()
    if visualmode == "v" then
        return VISUAL_MODE.char
    elseif visualmode == "V" then
        return VISUAL_MODE.line
    else
        return VISUAL_MODE.block
    end
end

local function nvim_transform_cword(fn)
    nvim_text_operator_transform_selection(
        function(lines)
            return {fn(lines[1])}
        end
    )
    a.nvim_feedkeys("iw", "ni", false)
end

local function nvim_transform_cWORD(fn)
    nvim_text_operator_transform_selection(
        function(lines)
            return {fn(lines[1])}
        end
    )
    a.nvim_feedkeys("iW", "ni", false)
end

-- luacheck: compat
local function nvim_source_current_buffer()
    loadstring(
        table.concat(
            nvim_buf_get_region_lines(nil, 1, -1, VISUAL_MODE.line), "\n"
        )
    )()
end

local LUA_BUFFER_MAPPING = {}

local function escape_keymap(key)
    -- Prepend with a letter so it can be used as a dictionary key
    return "k" .. key:gsub(".", string.byte)
end

local valid_modes = {
    n = "n",
    v = "v",
    x = "x",
    i = "i",
    o = "o",
    t = "t",
    c = "c",
    s = "s",
    -- :map! and :map
    ["!"] = "!",
    [" "] = "",
}

-- TODO(ashkan) @feature Disable noremap if the rhs starts with <Plug>
local function nvim_apply_mappings(mappings, default_options)
    local LUA_MAPPING = {} -- luacheck: ignore
    -- May or may not be used.
    local current_bufnr = 0
    for key, options in pairs(mappings) do
        options = vim.tbl_extend("keep", options, default_options or {})
        local bufnr = current_bufnr
        -- TODO allow passing bufnr through options.buffer?
        -- protect against specifying 0, since it denotes current buffer in api by convention
        if type(options.buffer) == "number" and options.buffer ~= 0 then
            bufnr = options.buffer
        end
        local mode, mapping = key:match("^(.)(.+)$")
        assert(
            mode,
            "nvim_apply_mappings: invalid mode specified for keymapping " .. key
        )
        assert(
            valid_modes[mode],
            "nvim_apply_mappings: invalid mode specified for keymapping. mode=" ..
                mode
        )
        mode = valid_modes[mode]
        local rhs = options[1]
        -- Remove this because we're going to pass it straight to nvim_set_keymap
        options[1] = nil
        if type(rhs) == "function" then
            -- Use a value that won't be misinterpreted below since special keys
            -- like <CR> can be in key, and escaping those isn't easy.
            local escaped = escape_keymap(key)
            local key_mapping
            if options.dot_repeat then
                local key_function = rhs
                rhs = function()
                    key_function()
                    vim.fn["repeat#set"](
                        a.nvim_replace_termcodes(key_mapping, true, true, true),
                        vim.v.count
                    )
                end
                options.dot_repeat = nil
            end
            if options.buffer then
                -- Initialize and establish cleanup
                if not LUA_BUFFER_MAPPING[bufnr] then
                    LUA_BUFFER_MAPPING[bufnr] = {}
                    -- Clean up our resources.
                    a.nvim_buf_attach(
                        bufnr, false, {
                            on_detach = function()
                                LUA_BUFFER_MAPPING[bufnr] = nil
                            end,
                        }
                    )
                end
                LUA_BUFFER_MAPPING[bufnr][escaped] = rhs
                -- TODO HACK figure out why <Cmd> doesn't work in visual mode.
                if mode == "x" or mode == "v" then
                    key_mapping =
                        (":<C-u>lua LUA_BUFFER_MAPPING[%d].%s()<CR>"):format(
                            bufnr, escaped
                        )
                else
                    key_mapping =
                        ("<Cmd>lua LUA_BUFFER_MAPPING[%d].%s()<CR>"):format(
                            bufnr, escaped
                        )
                end
            else
                LUA_MAPPING[escaped] = rhs
                -- TODO HACK figure out why <Cmd> doesn't work in visual mode.
                if mode == "x" or mode == "v" then
                    key_mapping = (":<C-u>lua LUA_MAPPING.%s()<CR>"):format(
                                      escaped
                                  )
                else
                    key_mapping = ("<Cmd>lua LUA_MAPPING.%s()<CR>"):format(
                                      escaped
                                  )
                end
            end
            rhs = key_mapping
            options.noremap = true
            options.silent = true
        end
        if options.buffer then
            options.buffer = nil
            a.nvim_buf_set_keymap(bufnr, mode, mapping, rhs, options)
        else
            a.nvim_set_keymap(mode, mapping, rhs, options)
        end
    end
end

local function nvim_create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        a.nvim_command("augroup " .. group_name)
        a.nvim_command("autocmd!")
        for _, def in ipairs(definition) do
            -- if type(def) == 'table' and type(def[#def]) == 'function' then
            -- 	def[#def] = lua_callback(def[#def])
            -- end
            local command = table.concat(vim.tbl_flatten{"autocmd", def}, " ")
            a.nvim_command(command)
        end
        a.nvim_command("augroup END")
    end
end

---
-- Strings
---

function string.startswith(s, n) -- luacheck: ignore
    return s:sub(1, #n) == n
end

function string.endswith(self, str) -- luacheck: ignore
    return self:sub(-(#str)) == str
end

function basename(str)
	local name = string.gsub(str, "(.*/)(.*)", "%2")
	return name
end

---
-- SPAWN UTILS
---
local HANDLES = {}

local function clean_handles()
    local n = 1
    while n <= #HANDLES do
        if HANDLES[n]:is_closing() then
            table.remove(HANDLES, n)
        else
            n = n + 1
        end
    end
end

local function spawn(cmd, params, onexit)
    local handle, pid
    handle, pid = vim.loop.spawn(
                      cmd, params, function(code, signal)
            if type(onexit) == "function" then
                onexit(code, signal)
            end
            handle:close()
            clean_handles()
        end
                  )
    table.insert(HANDLES, handle)
    return handle, pid
end

--- MISC UTILS

local function epoch_ms()
    local s, ns = vim.loop.gettimeofday()
    return s * 1000 + math.floor(ns / 1000)
end

local function epoch_ns()
    local s, ns = vim.loop.gettimeofday()
    return s * 1000000 + ns
end

-- nvim object
-- `nvim.$method(...)` redirects to `na.nvim_$method(...)`
-- `nvim.fn.$method(...)` redirects to `a.nvim_call_function($method, {...})`
-- TODO `nvim.ex.$command(...)` is approximately `:$command {...}.join(" ")`
-- `nvim.print(...)` is approximately `echo vim.inspect(...)`
-- `nvim.echo(...)` is approximately `echo table.concat({...}, '\n')`
-- Both methods cache the inital lookup in the metatable, but there is a small overhead regardless.
-- nvim =
return setmetatable(
           {
        VISUAL_MODE = VISUAL_MODE,
        tbl_extend = vim.tbl_extend,
        print = nvim_print,
        echo = nvim_echo,
        mark_or_index = nvim_mark_or_index,
        buf_get_region_lines = nvim_buf_get_region_lines,
        buf_set_region_lines = nvim_buf_set_region_lines,
        buf_transform_region_lines = nvim_buf_transform_region_lines,
        set_selection_lines = nvim_set_selection_lines,
        selection = nvim_selection,
        text_operator = nvim_text_operator,
        text_operator_transform_selection = nvim_text_operator_transform_selection,
        visual_mode = nvim_visual_mode,
        transform_cword = nvim_transform_cword,
        transform_cWORD = nvim_transform_cWORD,
        source_current_buffer = nvim_source_current_buffer,
        escape_keymap = escape_keymap,
        apply_mappings = nvim_apply_mappings,
        create_augroups = nvim_create_augroups,
        basename = basename,
        clean_handles = clean_handles,
        spawn = spawn,
        epoch_ms = epoch_ms,
        epoch_ns = epoch_ns,
        fn = setmetatable(
            {}, {
                __index = function(self, k)
                    local mt = getmetatable(self)
                    local x = mt[k]
                    if x ~= nil then
                        return x
                    end
                    local f = function(...)
                        return a.nvim_call_function(k, {...})
                    end
                    mt[k] = f
                    return f
                end,
            }
        ),
        buf = setmetatable(
            {}, {
                __index = function(self, k)
                    local mt = getmetatable(self)
                    local x = mt[k]
                    if x ~= nil then
                        return x
                    end
                    local f = a["nvim_buf_" .. k]
                    mt[k] = f
                    return f
                end,
            }
        ),
        ex = setmetatable(
            {}, {
                __index = function(self, k)
                    local mt = getmetatable(self)
                    local x = mt[k]
                    if x ~= nil then
                        return x
                    end
                    local command = k:gsub("_$", "!")
                    local f = function(...)
                        return a.nvim_command(
                                   table.concat(
                                       vim.tbl_flatten{command, ...}, " "
                                   )
                               )
                    end
                    mt[k] = f
                    return f
                end,
            }
        ),
        g = setmetatable(
            {}, {
                __index = function(_, k)
                    return a.nvim_get_var(k)
                end,
                __newindex = function(_, k, v)
                    if v == nil then
                        return a.nvim_del_var(k)
                    else
                        return a.nvim_set_var(k, v)
                    end
                end,
            }
        ),
        v = setmetatable(
            {}, {
                __index = function(_, k)
                    return a.nvim_get_vvar(k)
                end,
                __newindex = function(_, k, v)
                    return a.nvim_set_vvar(k, v)
                end,
            }
        ),
        b = setmetatable(
            {}, {
                __index = function(_, k)
                    return a.nvim_buf_get_var(0, k)
                end,
                __newindex = function(_, k, v)
                    if v == nil then
                        return a.nvim_buf_del_var(0, k)
                    else
                        return a.nvim_buf_set_var(0, k, v)
                    end
                end,
            }
        ),
        o = setmetatable(
            {}, {
                __index = function(_, k)
                    return a.nvim_get_option(k)
                end,
                __newindex = function(_, k, v)
                    return a.nvim_set_option(k, v)
                end,
            }
        ),
        bo = setmetatable(
            {}, {
                __index = function(_, k)
                    return a.nvim_buf_get_option(0, k)
                end,
                __newindex = function(_, k, v)
                    return a.nvim_buf_set_option(0, k, v)
                end,
            }
        ),
        wo = setmetatable(
            {}, {
                __index = function(_, k)
                    return a.nvim_win_get_option(0, k)
                end,
                __newindex = function(_, k, v)
                    return a.nvim_win_set_option(0, k, v)
                end,
            }
        ),
        env = setmetatable(
            {}, {
                __index = function(_, k)
                    return a.nvim_call_function("getenv", {k})
                end,
                __newindex = function(_, k, v)
                    return a.nvim_call_function("setenv", {k, v})
                end,
            }
        ),
    }, {
        __index = function(self, k)
            local mt = getmetatable(self)
            local x = mt[k]
            if x ~= nil then
                return x
            end
            local f = a["nvim_" .. k]
            mt[k] = f
            return f
        end,
    }
       )
