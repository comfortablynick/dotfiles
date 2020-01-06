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

local function lightline_config()
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
