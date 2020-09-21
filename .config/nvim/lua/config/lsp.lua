-- LSP configurations
local M = {}
local api = vim.api
local def_diagnostics_cb = vim.lsp.callbacks["textDocument/publishDiagnostics"]
local util = require"util"
local lsp = util.npcall(require, "nvim_lsp")

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
  api.nvim_buf_set_var(bufnr, "lsp_client_id", client.id)
  local map_opts = {noremap = true, silent = true}
  local nmaps = {
    [";d"] = "<Cmd>lua vim.lsp.buf.declaration()<CR>",
    ["gd"] = "<Cmd>lua vim.lsp.buf.definition()<CR>",
    ["gh"] = "<Cmd>lua vim.lsp.buf.hover()<CR>",
    ["gi"] = "<Cmd>lua vim.lsp.buf.implementation()<CR>",
    [";s"] = "<Cmd>lua vim.lsp.buf.signature_help()<CR>",
    ["gt"] = "<Cmd>lua vim.lsp.buf.type_definition()<CR>",
    ["<F2>"] = "<Cmd>lua require'config.lsp'.rename()<CR>",
    ["gr"] = "<Cmd>lua vim.lsp.buf.references()<CR>",
    ["gld"] = "<Cmd>lua vim.lsp.util.show_line_diagnostics()<CR>",
  }

  for lhs, rhs in pairs(nmaps) do
    api.nvim_buf_set_keymap(bufnr, "n", lhs, rhs, map_opts)
  end
end

function M.init()
  -- Safely return without error if nvim_lsp isn't installed
  if not lsp then return end
  local configs = {
    bashls = {},
    cmake = {},
    ccls = {},
    -- diagnosticls = {
    --   filetypes = {"vim", "sh", "python"},
    --   initializationOptions = {
    --     filetypes = {vim = "vint", sh = "shellcheck", python = "pydocstyle"},
    --   },
    -- },
    gopls = {},
    pyls_ms = {},
    rust_analyzer = {},
    sumneko_lua = {
      settings = {
        Lua = {
          runtime = {version = "LuaJIT"},
          completion = {keywordSnippet = "Disable"},
          diagnostics = {
            enable = true,
            globals = {"vim", "nvim", "sl", "p", "printf"},
          },
        },
      },
    },
    tsserver = {},
    vimls = {},
    yamlls = {
      filetypes = {"yaml", "yaml.ansible"},
      settings = {
        yaml = {
          schemas = {["http://json.schemastore.org/ansible-stable-2.9"] = "*"},
        },
      },
    },
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
