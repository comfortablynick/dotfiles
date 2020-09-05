-- LSP configurations
local api = vim.api
local lsp = require"nvim_lsp"
local util = require"util"
local M = {}
local def_diagnostics_cb = vim.lsp.callbacks["textDocument/publishDiagnostics"]

-- Customized rename function; defaults to name under cursor
function M.rename(new_name)
  local params = vim.lsp.util.make_position_params()
  local cursor_word = vim.fn.expand("<cexpr>")
  new_name = new_name or util.npcall(vim.fn.input, "New Name: ", cursor_word)
  if not (new_name and #new_name > 0) then return end
  params.newName = new_name
  vim.lsp.buf_request(0, "textDocument/rename", params)
end

local diagnostics_qf_cb = function(err, method, result, client_id)
  -- Use default callback too
  def_diagnostics_cb(err, method, result, client_id)
  -- Add to quickfix
  if result and result.diagnostics then
    for _, v in ipairs(result.diagnostics) do
      v.bufnr = client_id
      v.lnum = v.range.start.line + 1
      v.col = v.range.start.character + 1
      v.text = v.message
    end
    vim.lsp.util.set_qflist(result.diagnostics)
  end
end

local on_attach_cb = function(client, bufnr)
  local complete_chain = {
    default = {
      {complete_items = {"lsp", "snippet"}},
      {complete_items = {"path"}, triggered_only = {"/"}},
      {complete_items = {"buffers"}},
    },
    string = {{complete_items = {"path"}, triggered_only = {"/"}}},
    comment = {{complete_items = {"path"}, triggered_only = {"/"}}},
  }
  require"completion".on_attach{chain_complete_list = complete_chain}
  api.nvim_buf_set_var(bufnr, "lsp_client_id", client.id)
  local map_opts = {noremap = true, silent = true}
  local nmaps = {
    [";d"] = "<Cmd>lua vim.lsp.buf.declaration()<CR>",
    ["gd"] = "<Cmd>lua vim.lsp.buf.definition()<CR>",
    ["gh"] = "<Cmd>lua vim.lsp.buf.hover()<CR>",
    ["gi"] = "<Cmd>lua vim.lsp.buf.implementation()<CR>",
    [";s"] = "<Cmd>lua vim.lsp.buf.signature_help()<CR>",
    ["gt"] = "<Cmd>lua vim.lsp.buf.type_definition()<CR>",
    ["<F2>"] = "<Cmd>lua require'lsp'.rename()<CR>",
    ["gr"] = "<Cmd>lua vim.lsp.buf.references()<CR>",
    ["gld"] = "<Cmd>lua vim.lsp.util.show_line_diagnostics()<CR>",
  }

  for lhs, rhs in pairs(nmaps) do
    api.nvim_buf_set_keymap(bufnr, "n", lhs, rhs, map_opts)
  end

  vim.cmd[[augroup lsp_lua_on_attach]]
  vim.cmd[[autocmd CompleteDone * if pumvisible() == 0 | pclose | endif]]
  vim.cmd[[augroup END]]

  -- Not sure what these are supposed to do
  -- vim.cmd[[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
  -- vim.cmd[[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
  -- vim.cmd[[autocmd CursorMoved <buffer> lua vim.lsp.util.buf_clear_references()]]
end

function M.init()
  local configs = {
    sumneko_lua = {
      settings = {
        Lua = {
          runtime = {version = "LuaJIT"},
          diagnostics = {enable = true, globals = {"vim", "nvim", "sl", "p"}},
        },
      },
    },
    vimls = {},
    -- yamlls = {
    --   filetypes = {"yaml", "yaml.ansible"},
    --   settings = {
    --     yaml = {
    --       schemas = {["http://json.schemastore.org/ansible-stable-2.9"] = "*"},
    --     },
    --   },
    -- },
    -- pyls_ms = {},
  }

  -- Set global callbacks
  -- Can also be set locally for each server
  vim.lsp.callbacks["textDocument/publishDiagnostics"] = diagnostics_qf_cb

  -- Set local configs
  for server, cfg in pairs(configs) do
    cfg.on_attach = on_attach_cb
    lsp[server].setup(cfg)
  end
end

return M
