-- LSP configurations
local vim = vim
local api = vim.api
local lsp = require"nvim_lsp"
local protocol = vim.lsp.protocol
local util = vim.lsp.util
local reference_ns = api.nvim_create_namespace("vim_lsp_references")
local diagnostic_ns = api.nvim_create_namespace("vim_lsp_diagnostics")
local def_diagnostics_cb = vim.lsp.callbacks["textDocument/publishDiagnostics"]
local window = require"window"

local all_buffer_diagnostics = {}
local severity_highlights = {}
severity_highlights[1] = 'LspDiagnosticsError'
severity_highlights[2] = 'LspDiagnosticsWarning'

function buf_cache_diagnostics(bufnr, diagnostics)
    vim.validate {
        bufnr = {bufnr, 'n', true};
        diagnostics = {diagnostics, 't', true};
    }
    if not diagnostics then return end

    local buffer_diagnostics = {}

    for _, diagnostic in ipairs(diagnostics) do
        local start = diagnostic.range.start
        -- local mark_id = api.nvim_buf_set_extmark(bufnr, diagnostic_ns, 0, start.line, 0, {})
        -- buffer_diagnostics[mark_id] = diagnostic
        local line_diagnostics = buffer_diagnostics[start.line]
        if not line_diagnostics then line_diagnostics = {} end
        table.insert(line_diagnostics, diagnostic)
        buffer_diagnostics[start.line] = line_diagnostics
    end
    all_buffer_diagnostics[bufnr] = buffer_diagnostics

end

-- show diagnostics as virtual text
-- modified from https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/util.lua#L606
function buf_diagnostics_virtual_text(bufnr, diagnostics)
    -- return if we are called from a window that is not showing bufnr
    if api.nvim_win_get_buf(0) ~= bufnr then return end

    bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr

    local line_no = api.nvim_buf_line_count(bufnr)
    for _, line_diags in pairs(all_buffer_diagnostics[bufnr]) do

        line = line_diags[1].range.start.line
        if line+1 > line_no then goto continue end

        local virt_texts = {}

        -- window total width
        local win_width = api.nvim_win_get_width(0)

        -- line length
        local lines = api.nvim_buf_get_lines(bufnr, line, line+1, 0)
        local line_width = 0
        if table.getn(lines) > 0 then
            local line_content = lines[1]
            if line_content == nil then goto continue end
            line_width = vim.fn.strdisplaywidth(line_content)
        end

        -- window decoration with (sign + fold + number)
        local decoration_width = window.get_decoration_width()

        -- available space for virtual text
        local right_padding = 1
        local available_space = win_width - decoration_width - line_width - right_padding

        -- virtual text 
        local last = line_diags[#line_diags]
        local message = "■ "..last.message:gsub("\r", ""):gsub("\n", "  ") 

        -- more than one diagnostic in line
        if #line_diags > 1 then
            local leading_space = available_space - vim.fn.strdisplaywidth(message) - #line_diags
            local prefix = string.rep(" ", leading_space)
            table.insert(virt_texts, {prefix..'■', severity_highlights[line_diags[1].severity]})
            for i = 2, #line_diags - 1 do
                table.insert(virt_texts, {'■', severity_highlights[line_diags[i].severity]})
            end
            table.insert(virt_texts, {message, severity_highlights[last.severity]})
        -- 1 diagnostic in line
        else 
            local leading_space = available_space - vim.fn.strdisplaywidth(message) - #line_diags
            local prefix = string.rep(" ", leading_space)
            table.insert(virt_texts, {prefix..message, severity_highlights[last.severity]})
        end
        api.nvim_buf_set_virtual_text(bufnr, diagnostic_ns, line, virt_texts, {})
        ::continue::
    end
end

-- custom replacement for publishDiagnostics callback
-- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/callbacks.lua
local function diagnostics_callback(_, _, result)
    if not result then return end
    local uri = result.uri
    local bufnr = vim.fn.bufadd((vim.uri_to_fname(uri)))
    if not bufnr then
        api.nvim_err_writeln(string.format(
                                 "LSP.publishDiagnostics: Couldn't find buffer for %s",
                                 uri))
        return
    end

    -- clear hl and signcolumn namespaces
    util.buf_clear_diagnostics(bufnr)

    -- underline diagnosticed code
    util.buf_diagnostics_underline(bufnr, result.diagnostics)

    -- add marks to signcolumn
    util.buf_diagnostics_signs(bufnr, result.diagnostics)

    -- cache diagnostics so they are available for codeactions and statusline counts
    buf_cache_diagnostics(bufnr, result.diagnostics)

    -- custom virtual text uses diagnostics cache so need to go after
    buf_diagnostics_virtual_text(bufnr, result.diagnostics)

    -- notify user we are done processing diagnostics
    api.nvim_command("doautocmd User LspDiagnosticsChanged")

    -- add to quickfix
    if result and result.diagnostics then
        for _, v in ipairs(result.diagnostics) do
            v.uri = v.uri or result.uri
        end
        vim.lsp.util.set_qflist(result.diagnostics)
    end
end

local diagnostics_qf_cb = function(err, method, result, client_id)
    -- Use default callback too
    def_diagnostics_cb(err, method, result, client_id)
    -- Add to quickfix
    if result and result.diagnostics then
        for _, v in ipairs(result.diagnostics) do
            v.uri = v.uri or result.uri
        end
        vim.lsp.util.set_qflist(result.diagnostics)
    end
end

local on_attach_cb = function(client, bufnr)
    api.nvim_buf_set_var(bufnr, "lsp_client_id", client.id)
    api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    local map_opts = {noremap = true, silent = true}
    local nmaps = {
        [";d"] = "<Cmd>lua vim.lsp.buf.declaration()<CR>",
        ["gd"] = "<Cmd>lua vim.lsp.buf.definition()<CR>",
        ["gh"] = "<cmd>lua vim.lsp.buf.hover()<CR>",
        ["gi"] = "<cmd>lua vim.lsp.buf.implementation()<CR>",
        [";s"] = "<cmd>lua vim.lsp.buf.signature_help()<CR>",
        ["gt"] = "<cmd>lua vim.lsp.buf.type_definition()<CR>",
        ["<F2>"] = "<cmd>lua vim.lsp.buf.rename()<CR>",
        ["gr"] = "<cmd>lua vim.lsp.buf.references()<CR>",
        ["gld"] = "<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>",
    }

    for lhs, rhs in pairs(nmaps) do
        api.nvim_buf_set_keymap(bufnr, "n", lhs, rhs, map_opts)
    end

    -- Doesn't work for some reason
    -- api.nvim_command[[autocmd CursorHold <buffer> lua highlight_references()]]
    -- api.nvim_command[[autocmd CursorHoldI <buffer> lua highlight_references()]]
    -- api.nvim_command[[autocmd CursorMoved <buffer> lua clear_references()]]
end

local function init()
    local root_config = {
        callbacks = {["textDocument/publishDiagnostics"] = diagnostics_qf_cb},
        on_attach = on_attach_cb,
    }

    lsp.pyls.setup(root_config)
    lsp.vimls.setup(root_config)
    -- lsp.pyls_ms.setup{}
    -- lsp.rust_analyzer.setup{}

    lsp.sumneko_lua.setup(vim.tbl_extend("force", root_config, {
        settings = {
            Lua = {
                runtime = {version = "LuaJIT"},
                diagnostics = {enable = true},
            },
        },
    }))
end

return {init = init}
