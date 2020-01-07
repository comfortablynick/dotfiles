a = vim.api
LL = {}

local vars = {
    LL_MinWidth = 90,
    LL_MedWidth = 140,
    LL_MaxWidth = 200,
    LL_pl = vim.g.LL_pl or 0,
    LL_nf = vim.g.LL_nf or 0,
    LL_LineNoSymbol = "",
    LL_GitSymbol = vim.g.LL_nf ~= "1" and "" or " ",
    LL_BranchSymbol = "",
    LL_LineSymbol = "☰",
    LL_ROSymbol = vim.g.LL_pl ~= "1" and "--RO-- " or " ",
    LL_ModSymbol = " [+]",
    LL_SimpleSep = vim.env.SUB ~= "|" and 0 or 1,
    LL_FnSymbol = "ƒ ",
    LL_LinterChecking = vim.g.LL_nf ~= "1" and "..." or "\u{f110}",
    LL_LinterWarnings = vim.g.LL_nf ~= "1" and "•" or "\u{f071}",
    LL_LinterErrors = vim.g.LL_nf ~= "1" and "•" or "\u{f05e}",
    LL_LinterOK = "",
}

local function lightline_config() -- luacheck: ignore
    vim.g.lightline_test = {
        tabline = {left = {{"buffers"}}, right = {{"filesize"}}},
        active = {
            left = {
                {"vim_mode", "paste"},
                {"filename"},
                {
                    "git_status",
                    "linter_checking",
                    "linter_errors",
                    "linter_warnings",
                    "coc_status",
                },
            },
            right = {
                {"line_info"},
                {"filetype_icon", "fileencoding_non_utf", "fileformat_icon"},
                {"current_tag"},
                {"asyncrun_status"},
            },
        },
        inactive = {
            left = {{"filename"}},
            right = {
                {"line_info"},
                {"filetype_icon", "fileencoding_non_utf", "fileformat_icon"},
            },
        },
        component = {filename = "%<%{LL_FileName()}"},
        component_function = {
            git_status = "LL_GitStatus",
            filesize = "LL_FileSize",
            filetype_icon = "LL_FileType",
            fileformat_icon = "LL_FileFormat",
            fileencoding_non_utf = "LL_FileEncoding",
            line_info = "LL_LineInfo",
            vim_mode = "LL_Mode",
            venv = "LL_VirtualEnvName",
            current_tag = "LL_CurrentTag",
            coc_status = "LL_CocStatus",
            asyncrun_status = "LL_AsyncRunStatus",
        },
        tab_component_function = {filename = "LL_TabName"},
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
    for name, value in pairs(vars) do
        vim.g[name] = value
    end
end

-- lightline_config()

function LL.is_not_file(filetype)
    local exclude = {
        "nerdtree",
        "netrw",
        "defx",
        "output",
        "vista",
        "undotree",
        "vimfiler",
        "tagbar",
        "minpac",
        "packager",
        "vista",
        "qf",
        "coc-explorer",
        "output:///info",
    }
    for _, v in ipairs(exclude) do
        if v == filetype or v == vim.fn.expand("%:t") or v == vim.fn.expand("%") then
            return true
        end
    end
    return false
end

function LL.line_info()
    local line_ct = a.nvim_buf_line_count(0)
    local pos = a.nvim_win_get_cursor(0)
    local row = pos[1]
    local col = pos[2] + 1
    local row_pos = function()
        local max_digits = string.len(tostring(line_ct))
        return string.format(
                   "%" .. max_digits .. "d/%" .. max_digits .. "d", row, line_ct
               )
    end
    return string.format(
               "%3d%% %s %s %s :%3d", row * 100 / line_ct, vars.LL_LineSymbol,
               row_pos(), vars.LL_LineNoSymbol, col
           )
end

function LL.mode_map()
    local mode_map = {
        n = {"NORMAL", "NRM", "N"},
        i = {"INSERT", "INS", "I"},
        R = {"REPLACE", "REP", "R"},
        v = {"VISUAL", "VIS", "V"},
        V = {"V-LINE", "V-LN", "V-L"},
        ["<C-V>"] = {"V-BLOCK", "V-BL", "V-B"},
        c = {"COMMAND", "CMD", "C"},
        s = {"SELECT", "SEL", "S"},
        S = {"S-LINE", "S-LN", "S-L"},
        ["<C-s>"] = {"S-BLOCK", "S-BL", "S-B"},
        t = {"TERMINAL", "TERM", "T"},
    }
    local special_modes = {
        nerdtree = "NERD",
        netrw = "NETRW",
        defx = "DEFX",
        tagbar = "TAGS",
        undotree = "UNDO",
        vista = "VISTA",
        qf = "",
        ["coc-explorer"] = "EXPLORER",
        ["output=///info"] = "COC-INFO",
        packager = "PACK",
    }
    -- let l:mode = get(l:mode_map, mode(), mode())
    local mode_key = a.nvim_get_mode().mode
    local mode = mode_map[mode_key]
    local winwidth = a.nvim_win_get_width(0)
    local mode_out = function()
        if winwidth > vars.LL_MedWidth then
            return mode[1]
        end
        if winwidth > vars.LL_MinWidth then
            return mode[2]
        end
        return mode[3]
    end
    -- return get(l:special_modes, &filetype, get(l:special_modes, @%, l:mode_out))
    return
        special_modes[vim.bo.filetype] or special_modes[vim.fn.expand("%")] or
            mode_out()
end
