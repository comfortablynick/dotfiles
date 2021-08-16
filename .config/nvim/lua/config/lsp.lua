-- LSP configurations
local M = {}
local api = vim.api
local util = vim.lsp.util
local npcall = vim.F.npcall
local lsp = nvim.packrequire("nvim-lspconfig", "lspconfig")
local lsp_status = nvim.packrequire("lsp-status.nvim", "lsp-status")
local lsp_saga = nvim.packrequire("lspsaga.nvim", "lspsaga")
local lsps_attached = {}

local configs = npcall(require, "lspconfig/configs")
local lsp_util = npcall(require, "lspconfig/util")
local status = require "config.lsp.status"

if configs ~= nil then
  configs.taplo = {
    default_config = {
      cmd = { "taplo-lsp", "run" },
      filetypes = { "toml" },
      root_dir = function(fname)
        return lsp_util.root_pattern(".git", "taplo.toml", ".taplo.toml")(fname)
          or lsp_util.find_git_ancestor(fname)
          or lsp_util.path.dirname(fname)
      end,
      settings = {},
    },
  }
end

M.configs = {}

if lsp_status ~= nil then
  lsp_status.register_progress()
  lsp_status.config {
    select_symbol = function(cursor_pos, symbol)
      if symbol.valueRange then
        local value_range = {
          ["start"] = {
            character = 0,
            line = vim.fn.byte2line(symbol.valueRange[1]),
          },
          ["end"] = {
            character = 0,
            line = vim.fn.byte2line(symbol.valueRange[2]),
          },
        }
        return require("lsp-status.util").in_range(cursor_pos, value_range)
      end
    end,
  }
end

vim.fn.sign_define("LspDiagnosticsSignError", { text = "", numhl = "LspDiagnosticsDefaultError" })
vim.fn.sign_define("LspDiagnosticsSignWarning", { text = "", numhl = "LspDiagnosticsDefaultWarning" })
vim.fn.sign_define("LspDiagnosticsSignInformation", { text = "", numhl = "LspDiagnosticsDefaultInformation" })
vim.fn.sign_define("LspDiagnosticsSignHint", { text = "", numhl = "LspDiagnosticsDefaultHint" })

local custom_symbol_handler = function(_, _, result, _, bufnr)
  if vim.tbl_isempty(result or {}) then
    return
  end

  local items = util.symbols_to_items(result, bufnr)
  local items_by_name = {}
  for _, item in ipairs(items) do
    items_by_name[item.text] = item
  end

  local opts = vim.fn["fzf#wrap"] {
    source = vim.tbl_keys(items_by_name),
    sink = function() end,
    options = { "--prompt", "Symbol > " },
  }
  opts.sink = function(item)
    local selected = items_by_name[item]
    vim.fn.cursor(selected.lnum, selected.col)
  end
  vim.fn["fzf#run"](opts)
end

vim.lsp.handlers["textDocument/documentSymbol"] = custom_symbol_handler
vim.lsp.handlers["workspace/symbol"] = custom_symbol_handler
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  virtual_text = { spacing = 2 },
  signs = true,
  update_in_insert = false,
})

function M.set_hl()
  local ns = api.nvim_create_namespace "hl-lsp"

  -- TODO: fix statusline functions to use new nvim api
  api.nvim_set_hl(ns, "LspDiagnosticsDefaultError", { fg = "#ff5f87" })
  api.nvim_set_hl(ns, "LspDiagnosticsDefaultWarning", { fg = "#d78f00" })
  api.nvim_set_hl(ns, "LspDiagnosticsDefaultInformation", { fg = "#d78f00" })
  api.nvim_set_hl(ns, "LspDiagnosticsDefaultHint", { fg = "#ff5f87", bold = true })
  api.nvim_set_hl(ns, "LspDiagnosticsUnderlineError", { fg = "#ff5f87", sp = "#ff5f87", undercurl = true })
  api.nvim_set_hl(ns, "LspDiagnosticsUnderlineWarning", { fg = "#d78f00", sp = "#d78f00", undercurl = true })
  api.nvim_set_hl(ns, "LspReferenceText", { link = "CursorColumn" })
  api.nvim_set_hl(ns, "LspReferenceRead", { link = "LspReferenceText" })
  api.nvim_set_hl(ns, "LspReferenceWrite", { link = "LspReferenceText" })
  api.nvim__set_hl_ns(ns) -- This changed to unstable API
end

-- Standard rename functionality wrapper
--
-- @param new_name string New name for variable under cursor
-- @return string
function M.rename(new_name)
  local params = util.make_position_params()
  new_name = new_name or npcall(vim.fn.input, "New Name: ", vim.fn.expand "<cword>")
  if not (new_name and #new_name > 0) then
    return
  end
  params.newName = new_name
  vim.lsp.buf_request(0, "textDocument/rename", params)
end

function M.attached_lsps()
  local bufnr = api.nvim_get_current_buf()
  if not lsps_attached[bufnr] then
    return ""
  end
  return "LSP[" .. table.concat(vim.tbl_values(lsps_attached[bufnr]), ",") .. "]"
end

-- Return table of useful client info
function M.clients()
  local servers = {}
  for _, client in ipairs(vim.lsp.get_active_clients()) do
    table.insert(servers, {
      name = client.name,
      id = client.id,
      capabilities = client.resolved_capabilities,
    })
  end
  return servers
end

local set_hl_autocmds = function()
  -- TODO: how to undo this if server detaches?
  vim.cmd [[
      au CursorHold <buffer> lua pcall(vim.lsp.buf.document_highlight)
      au CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      au InsertEnter <buffer> lua vim.lsp.buf.clear_references()
      ]]
end

local nmap = function(key, result)
  api.nvim_buf_set_keymap(0, "n", key, "<Cmd>" .. result .. "<CR>", { noremap = true })
end

local on_attach_cb = function(client, bufnr)
  if lsp_status ~= nil then
    lsp_status.on_attach(client)
  end
  local nmap_capability = function(lhs, method, capability_name)
    if client.resolved_capabilities[capability_name or method] then
      nmap(lhs, "lua vim.lsp.buf." .. method .. "()")
    end
  end

  local ft = vim.bo[bufnr].ft
  vim.g["vista_" .. ft .. "_executive"] = "nvim_lsp"

  nmap_capability("gtd", "definition", "goto_definition")
  nmap_capability("gh", "hover")
  nmap_capability("gi", "implementation")
  nmap_capability("gS", "signature_help")
  nmap_capability("ga", "code_action")
  nmap_capability("gt", "type_definition")
  nmap_capability("gr", "references")
  nmap_capability("<F2>", "rename")

  nmap("gd", "lua vim.lsp.diagnostic.set_loclist{open = true}")
  nmap("[d", "lua vim.lsp.diagnostic.goto_prev{popup_opts = {show_header = false}}")
  nmap("]d", "lua vim.lsp.diagnostic.goto_next{popup_opts = {show_header = false}}")
  nmap("[D", "lua vim.lsp.diagnostic.goto_prev{cursor_position = {-1, -1}, popup_opts = {show_header = false}}")
  nmap("]D", "lua vim.lsp.diagnostic.goto_next{cursor_position = {0, 0}, popup_opts = {show_header = false}}")

  if lsp_saga ~= nil then
    nmap("gh", "Lspsaga hover_doc")
    nmap("gD", "Lspsaga preview_definition")
    nmap("[d", "Lspsaga diagnostic_jump_prev")
    nmap("]d", "Lspsaga diagnostic_jump_next")
    nmap("ga", "Lspsaga code_action")
    nmap("gS", "Lspsaga signature_help")
    nmap("<F2>", "Lspsaga rename")
    nmap("<C-f>", "lua require'lspsaga.action'.smart_scroll_with_saga(1)")
    nmap("<C-b>", "lua require'lspsaga.action'.smart_scroll_with_saga(-1)")
  end

  if client.resolved_capabilities["document_formatting"] then
    vim.cmd [[command! Format lua vim.lsp.buf.formatting()]]
    api.nvim_buf_set_keymap(bufnr, "", "<F3>", "<Cmd>Format<CR>", { noremap = true })
  end
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

  -- Add client name to variable
  local name_replacements = { diagnosticls = "diag", sumneko_lua = "sumneko" }
  if not lsps_attached[bufnr] then
    lsps_attached[bufnr] = {}
  end
  local client_display_name = name_replacements[client.name] or client.name
  -- Don't duplicate name if we're reloading, etc.
  if not vim.tbl_contains(lsps_attached[bufnr], client_display_name) then
    table.insert(lsps_attached[bufnr], client_display_name)
  end

  -- Set autocmds for highlighting if server supports it
  if true and client.resolved_capabilities.document_highlight then
    set_hl_autocmds()
  end
end

-- vim.lsp.set_log_level("debug")

-- suppress error messages from lang servers
-- from: github.com/siduck76/NvChad/blob/main/lua/plugins/lspconfig.lua
vim.notify = function(msg, log_level, _)
  if msg:match "exit code" then
    return
  end
  if log_level == vim.log.levels.ERROR then
    vim.api.nvim_err_writeln(msg)
  else
    vim.api.nvim_echo({ { msg } }, true, {})
  end
end

function M.init()
  if not lsp then
    return
  end
  -- Server configs {{{1
  local local_configs = {
    ansiblels = true,
    bashls = true,
    cmake = false,
    ccls = true,
    diagnosticls = false,
    efm = true,
    gopls = true,
    jsonls = true,
    pyright = true,
    rust_analyzer = true,
    sumneko_lua = true,
    taplo = false,
    tsserver = false,
    vimls = true,
    yamlls = true,
  }

  -- configs.taplo.setup{on_attach = on_attach_cb}
  for server, active in pairs(local_configs) do
    if not active then
      goto continue
    end
    -- Load config from disk
    local cfg
    do
      local def_cfg = { on_attach = on_attach_cb }
      local cfg_fn = npcall(require, "config.lsp.server." .. server)
      cfg = cfg_fn ~= nil and cfg_fn(on_attach_cb) or def_cfg
    end
    -- Check if defined cmd is executable
    if cfg.cmd ~= nil then
      if vim.fn.executable(cfg.cmd[1]) ~= 1 then
        goto continue
      end
    end
    if lsp_status ~= nil then
      cfg.capabilities = vim.tbl_extend("keep", cfg.capabilities or {}, lsp_status.capabilities)
    end
    lsp[server].setup(cfg)
    M.configs[server] = cfg
    ::continue::
  end
end
if configs ~= nil then
  configs.taplo.setup { on_attach = on_attach_cb }
end

M.status = status.status
M.errors = status.errors
M.warnings = status.warnings
M.info = status.info
M.hints = status.hints
return M
