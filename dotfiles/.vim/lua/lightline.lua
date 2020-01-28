local api = vim.api
local exists = vim.fn.exists
local util = require"util"
local npcall = util.npcall
ll = {}

-- Local vars --{{{1
-- Vim global settings --{{{2
-- vim.g.lightline_use_lua = 1
vim.g.LL_pl = vim.g.LL_pl or 0
vim.g.LL_nf = vim.g.LL_nf or 0

-- Script globals {{{2
local WINWIDTH = api.nvim_win_get_width(0)
local FILENAME = api.nvim_buf_get_name(0)
local vars = { -- {{{2
    min_width = 90,
    med_width = 140,
    max_width = 200,
    use_simple_sep = vim.env.SUB ~= "|" and 0 or 1,
    use_pl_fonts = vim.g.LL_pl,
    use_nerd_fonts = vim.g.LL_nf,
    glyphs = {
        line_no = "",
        vcs = vim.g.LL_nf ~= 1 and "" or " ",
        branch = "",
        line = "☰",
        read_only = " ",
        modified = " ●",
        func = "ƒ ",
        linter_checking = vim.g.LL_nf ~= 1 and "..." or "\u{f110}",
        linter_warnings = vim.g.LL_nf ~= 1 and "•" or "\u{f071}",
        linter_errors = vim.g.LL_nf ~= 1 and "✘" or "\u{f05e}",
        linter_ok = "",
        lvimrc = [[ Ⓛ ]],
    },
}

-- List of plugins/non-files for special handling
-- Key: filetype
-- Value: special mode (set to `false` to skip setting mode)
local special_filetypes = { -- {{{2
    nerdtree = "NERD",
    netrw = "NETRW",
    defx = "DEFX",
    vista = "VISTA",
    tagbar = "TAGS",
    undotree = "UNDO",
    qf = "",
    ["coc-explorer"] = "EXPLORER",
    ["output=///info"] = "COC-INFO",
    vimfiler = "FILER",
    minpac = "PACK",
    packager = "PACK",
    fugitive = "FUGITIVE",
}

local lightline = { -- {{{2
    tabline = {
        left = {{"buffers"}},
        right = {{"filesize"}},
        -- preserve fold
    },
    active = {
        left = {
            {"mode", "paste"},
            {"filename"},
            {
                "git_status",
                "linter_checking",
                "linter_errors",
                "linter_warnings",
            },
        },
        right = {
            {"line_info"},
            {"filetype", "fileencoding", "fileformat"},
            {"coc_status"},
            -- {"current_tag"},
        },
    },
    inactive = {
        left = {{"filename"}},
        right = {{"line_info"}, {"filetype", "fileencoding", "fileformat"}},
    },
    component = {
        mode = "%{v:lua.ll.vim_mode()}",
        filename = "%<%{v:lua.ll.file_name()}",
        git_status = "%{v:lua.ll.git_status()}",
        filetype = "%{v:lua.ll.file_type()}",
        fileencoding = "%{v:lua.ll.file_encoding()}",
        fileformat = "%{v:lua.ll.file_format()}",
        line_info = "%{v:lua.ll.line_info()}",
        filesize = "%{v:lua.ll.file_size()}",
        coc_status = "%{v:lua.ll.coc_status()}",
        current_tag = "%{v:lua.ll.current_tag()}",
    },
    component_visible_condition = {
        filetype = "v:lua.ll.file_type()",
        fileencoding = "v:lua.ll.file_encoding()",
        fileformat = "v:lua.ll.file_format()",
        coc_status = "v:lua.ll.coc_status()",
    },
    component_expand = {
        linter_checking = "lightline#ale#checking",
        linter_warnings = "LL_LinterWarnings",
        linter_errors = "LL_LinterErrors",
        linter_ok = "lightline#ale#ok",
        buffers = "lightline#bufferline#buffers",
    },
    component_type = {
        readonly = "error",
        linter_checking = "left",
        linter_warnings = "warning",
        linter_errors = "error",
        linter_ok = "left",
        buffers = "tabsel",
        cocerror = "error",
        cocwarn = "warn",
    },
    separator = {left = "", right = ""},
    subseparator = {left = "|", right = "|"},
}

-- Functions --{{{1
function ll.is_not_file() -- {{{2
    return special_filetypes[vim.bo.filetype] ~= nil or vim.bo.filetype == ""
end

function ll.line_info() -- {{{2
    if ll.is_not_file() then return "" end
    local line_ct = api.nvim_buf_line_count(0)
    local pos = api.nvim_win_get_cursor(0)
    local row = pos[1]
    local col = pos[2] + 1
    local row_pos = function()
        local max_digits = string.len(tostring(line_ct))
        return string.format("%" .. max_digits .. "d/%" .. max_digits .. "d",
                             row, line_ct)
    end
    return string.format("%3d%% %s %s %s :%3d", row * 100 / line_ct,
                         vars.glyphs.line, row_pos(), vars.glyphs.line_no, col)
end

function ll.vim_mode() -- {{{2
    local mode_map = {
        n = {"NORMAL", "NRM", "N"},
        niI = {"NORMAL·CMD", "NRM", "N"},
        i = {"INSERT", "INS", "I"},
        ic = {"INSERT", "INS", "I"},
        ix = {"INSERT COMPL", "I·COMPL", "IC"},
        R = {"REPLACE", "REP", "R"},
        v = {"VISUAL", "VIS", "V"},
        V = {"V·LINE", "V·LN", "V·L"},
        ["\x16"] = {"V·BLOCK", "V·BL", "V·B"},
        c = {"COMMAND", "CMD", "C"},
        s = {"SELECT", "SEL", "S"},
        S = {"S·LINE", "S·LN", "S·L"},
        ["<C-s>"] = {"S·BLOCK", "S·BL", "S·B"},
        t = {"TERMINAL", "TERM", "T"},
    }

    local mode_key = api.nvim_get_mode().mode
    local curr_mode = mode_map[mode_key] or mode_key
    local mode_out = function()
        if WINWIDTH > vars.med_width then return curr_mode[1] end
        if WINWIDTH > vars.min_width then return curr_mode[2] end
        return curr_mode[3]
    end
    -- TODO: is filename ever going to match special_filetypes?
    -- viml: return get(l:special_modes, &filetype, get(l:special_modes, @%, l:mode_out))
    -- return type(special_filetypes[vim.bo.filetype]) == "string" or mode_out()
    return special_filetypes[vim.bo.filetype] or mode_out()
end

function ll.file_type() -- {{{2
    if ll.is_not_file() or WINWIDTH <= vars.med_width then return "" end
    local ft_glyph = WINWIDTH > vars.med_width and
                         npcall(function()
            return " " .. vim.fn.WebDevIconsGetFileTypeSymbol()
        end) or ""
    local python_venv = function()
        local venv = not vim.g.did_coc_loaded and
                         (vim.bo.ft == "python" and
                             string.basename(vim.env.VIRTUAL_ENV)) or ""
        return venv ~= "" and string.format(" (%s)", venv) or ""
    end

    local venv = WINWIDTH > vars.med_width and python_venv() or ""
    return vim.bo.filetype .. ft_glyph .. venv
end

function ll.file_format() -- {{{2
    local ff = vim.bo.fileformat
    if ll.is_not_file() or ff == "unix" then return "" end
    local ff_glyph = WINWIDTH > vars.med_width and
                         npcall(function()
            return " " .. vim.fn.WebDevIconsGetFileFormatSymbol()
        end) or ""
    return ff .. ff_glyph
end

function ll.file_size() -- {{{2
    local stat = vim.loop.fs_stat(FILENAME)
    local size = stat ~= nil and stat.size or 0
    return size > 0 and util.humanize_bytes(size) or ""
end

function ll.file_name() -- {{{2
    if ll.is_not_file() then return "" end
    local path = string.gsub(vim.fn.expand("%"), vim.env.HOME, "~")
    if ll.coc_status() ~= "" or vim.bo.filetype == "help" then
        return path:basename()
    end
    local num_chars = (function()
        if WINWIDTH <= vars.med_width then
            return 2
        elseif WINWIDTH <= vars.max_width then
            return 3
        else
            return nil
        end
    end)()
    if num_chars ~= nil then
        local shorten = function(part) return part:sub(1, num_chars) end
        local parts = vim.split(path, "/")
        local basename = parts[#parts]
        if #parts > 1 then
            local shortened = {}
            for i = 1, #parts - 1 do
                table.insert(shortened, shorten(parts[i]))
            end
            table.insert(shortened, basename)
            path = table.concat(shortened, "/")
        end
    end
    local read_only = function()
        return not ll.is_not_file() and vim.bo.readonly and
                   vars.glyphs.read_only or ""
    end
    local modified = function()
        return
            not ll.is_not_file() and vim.bo.modified and vars.glyphs.modified or
                ""
    end
    local lvimrc = function()
        local lrc = npcall(api.nvim_buf_get_var, 0, "localrc_loaded")
        return lrc and lrc > 0 and vars.glyphs.lvimrc or ""
    end
    return read_only() .. path .. modified() .. lvimrc()
end

function ll.file_encoding() -- {{{2
    return vim.bo.fileencoding ~= "utf-8" and vim.bo.fileencoding or ""
end

function ll.tab_name() -- {{{2
    return ll.is_not_file() and "" or ll.file_name()
end

function ll.git_summary() -- {{{2
    -- Look for git hunk summary in this order:
    -- 1. coc-git
    -- 2. gitgutter
    -- 3. signify
    local hunks = (function()
        if exists("b:coc_git_status") == 1 then
            return vim.trim(api.nvim_buf_get_var(0, "coc_git_status"))
        end
        return npcall(vim.fn.GitGutterGetHunkSummary) or
                   npcall(vim.fn["sy#repo#get_stats"]) or {0, 0, 0}
    end)()
    local added = not not hunks[1] and hunks[1] ~= 0 and string.format("+%d ", hunks[1]) or ""
    local changed = not not hunks[2] and hunks[2] ~= 0 and string.format("~%d ", hunks[2]) or ""
    local deleted = not not hunks[3] and hunks[3] ~= 0 and string.format("-%d ", hunks[3]) or ""
    return " " .. added .. changed .. deleted
end

function ll.git_branch() -- {{{2
    if vim.fn.exists("g:coc_git_status") == 1 then
        return vim.g.coc_git_status
    end
    local head = npcall(vim.fn["fugitive#head"])
    return head ~= (nil or "") and vars.glyphs.branch .. " " .. head or ""
end

function ll.git_status() -- {{{2
    if not ll.is_not_file() and WINWIDTH > vars.min_width then
        local branch = ll.git_branch()
        local hunks = ll.git_summary()
        return branch ~= "" and
                   string.format("%s%s%s", vars.glyphs.vcs, branch, hunks) or ""
    end
    return ""
end

function ll.coc_status() -- {{{2
    if WINWIDTH > vars.min_width and vim.fn.exists("g:coc_status") == 1 then
        local st = vim.g.coc_status
        return st and st
    end
    return ""
end

function ll.current_tag() -- {{{2
    if WINWIDTH < vars.max_width then return "" end
    local coc_tag = (function()
        return vim.fn.exists("b:coc_current_function") == 1 and
                   api.nvim_buf_get_var(0, "coc_current_function") or ""
    end)()
    local tagbar_tag = function()
        if vim.fn.exists("g:loaded_tagbar") ~= 1 then
            vim.cmd("packadd tagbar")
        end
        return vim.fn["tagbar#currenttag"]("%s", "", "f")
    end
    -- return coc_tag or tagbar_tag() or ""
    return coc_tag ~= "" and coc_tag or tagbar_tag() or ""
end

function ll.linter_errors() -- {{{2
    local coc_error_ct = function()
        if vim.fn.exists("b:coc_diagnostic_info") ~= 1 then return 0 end
        local info = api.nvim_buf_get_var(0, "coc_diagnostic_info")
        return info.error
    end
    local ale_error_ct = function()
        local counts = npcall(vim.fn["ale#statusline#Count"], 0)
        return not not counts and counts.error + counts.style_error or 0
    end
    local coc_errors = coc_error_ct()
    local error_ct = coc_errors > 0 and coc_errors or ale_error_ct()
    return error_ct > 0 and
               string.format("%s %d", vars.glyphs.linter_errors, error_ct) or ""
end

function ll.linter_warnings() -- {{{2
    local coc_warning_ct = function()
        if vim.fn.exists("b:coc_diagnostic_info") ~= 1 then return 0 end
        local info = api.nvim_buf_get_var(0, "coc_diagnostic_info")
        return info.warning
    end
    local ale_warning_ct = function()
        local counts = npcall(vim.fn["ale#statusline#Count"], 0)
        return not not counts and counts.warning + counts.style_warning or 0
    end
    local coc_warnings = coc_warning_ct()
    local warning_ct = coc_warnings > 0 and coc_warnings or ale_warning_ct()
    return warning_ct > 0 and
               string.format("%s %d", vars.glyphs.linter_warnings, warning_ct) or
               ""
end

-- Post config {{{1
-- Set g:lightline {{{2
vim.g.lightline = lightline

-- Tests {{{2
-- local runs = 1000
-- require'util'.bench(runs, ll.git_status)
-- require'util'.bench(runs, vim.fn.LL_GitStatus)
-- vim:fdm=marker fdl=1:
