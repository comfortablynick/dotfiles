-- LSP configurations
local vim = vim
local api = vim.api
local lsp = require"nvim_lsp"
local protocol = vim.lsp.protocol
local reference_ns = api.nvim_create_namespace("vim_lsp_references")

local function qf_diagnostics()
    local method = "textDocument/publishDiagnostics"
    local default_callback = vim.lsp.callbacks[method]
    vim.lsp.callbacks[method] = function(err, method, result, client_id)
        default_callback(err, method, result, client_id)
        if result and result.diagnostics then
            for _, v in ipairs(result.diagnostics) do
                v.uri = v.uri or result.uri
            end
            vim.lsp.util.set_qflist(result.diagnostics)
        end
    end
end

-- returns true if LSP server is ready. global so can be called from statusline
function server_ready()
    local bufnr = api.nvim_get_current_buf()
    local _, client_id = pcall(api.get_buf_var, bufnr, "lsp_client_id")
    if type(client_id) == "number" then
        local client = vim.lsp.get_client_by_id(client_id)
        if client ~= nil then
            if client.notify("window/progress", {}) then return true end
        end
    end
    return false
end

-- copied from https://github.com/neovim/neovim/blob/6e8c5779cf960893850501e4871dc9be671db298/runtime/lua/vim/lsp/util.lua#L425
function highlight_range(bufnr, ns, hiname, start, finish)
    if start[1] == finish[1] then
        vim.api.nvim_buf_add_highlight(bufnr, ns, hiname, start[1], start[2],
                                       finish[2])
    else
        vim.api
            .nvim_buf_add_highlight(bufnr, ns, hiname, start[1], start[2], -1)
        for line = start[1] + 1, finish[1] - 1 do
            vim.api.nvim_buf_add_highlight(bufnr, ns, hiname, line, 0, -1)
        end
        vim.api.nvim_buf_add_highlight(bufnr, ns, hiname, finish[1], 0,
                                       finish[2])
    end
end

-- clear reference highlighting
function clear_references() api.nvim_buf_clear_namespace(0, reference_ns, 0, -1) end

-- highlight references for symbol under cursor
function highlight_references()
    local bufnr = api.nvim_get_current_buf()
    local params = vim.lsp.util.make_position_params()
    local callback = vim.schedule_wrap(function(_, _, result)
        if not result then return end
        for _, reference in ipairs(result) do
            local start_pos = {
                reference["range"]["start"]["line"],
                reference["range"]["start"]["character"],
            }
            local end_pos = {
                reference["range"]["end"]["line"],
                reference["range"]["end"]["character"],
            }
            local document_highlight_kind =
                {
                    [protocol.DocumentHighlightKind.Text] = "LspReferenceText",
                    [protocol.DocumentHighlightKind.Read] = "LspReferenceRead",
                    [protocol.DocumentHighlightKind.Write] = "LspReferenceWrite",
                }
            highlight_range(bufnr, reference_ns,
                            document_highlight_kind[reference["kind"]],
                            start_pos, end_pos)
        end
    end)
    vim.lsp.buf_request(0, "textDocument/documentHighlight", params, callback)
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
    buf_clear_diagnostics(bufnr)

    -- underline diagnosticed code
    local ft = api.nvim_buf_get_option(bufnr, "filetype")
    if ft ~= "fortifyrulepack" then
        util.buf_diagnostics_underline(bufnr, result.diagnostics)
    end

    -- add marks to signcolumn
    buf_diagnostics_signs(bufnr, result.diagnostics)

    -- cache diagnostics so they are available for codeactions and statusline counts
    buf_cache_diagnostics(bufnr, result.diagnostics)

    -- custom virtual text uses diagnostics cache so need to go after
    buf_diagnostics_virtual_text(bufnr, result.diagnostics)

    -- notify user we are done processing diagnostics
    api.nvim_command("doautocmd User LspDiagnosticsChanged")
end

local function init()
    local on_attach = function(_, bufnr)
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

    lsp.pyls.setup{}
    -- lsp.pyls_ms.setup{}
    lsp.sumneko_lua.setup{settings = {Lua = {runtime = {version = "LuaJIT"}}}}
    -- lsp.rust_analyzer.setup{}
    -- lsp.vimls.setup{}
    local servers = {"sumneko_lua", "pyls"}
    for _, server in ipairs(servers) do
        lsp[server].setup{on_attach = on_attach}
    end

    qf_diagnostics()
end

return {init = init}
