-- LSP configurations
local M = {}
local api = vim.api
local util = vim.lsp.util
local lsp = require "lspconfig"
local lsp_status = require "lsp-status"
local set_hl_ns = api.nvim__set_hl_ns or api.nvim_set_hl_ns
local lsps_attached = {}

local status = require "config.lsp.status"
local cmp = require "config.cmp"
require "config.fidget"

M.configs = {}

api.nvim_create_augroup("LspAttach_inlayhints", {})
api.nvim_create_autocmd("LspAttach", {
  group = "LspAttach_inlayhints",
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end

    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    require("lsp-inlayhints").on_attach(client, bufnr)
  end,
})

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
  -- local ns = api.nvim_create_namespace "nick"
  local ns = 0

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
  set_hl_ns(ns)
end

-- Rename with syntax highlighting
function M.rename()
  local rename = "textDocument/rename"
  local currName = vim.fn.expand "<cword>"
  local tshl = require("nvim-treesitter-playground.hl-info").get_treesitter_hl()
  if tshl and #tshl > 0 then
    local ind = tshl[#tshl]:match "^.*()%*%*.*%*%*"
    tshl = tshl[#tshl]:sub(ind + 2, -3)
  end

  local win = require("plenary.popup").create(currName, {
    title = "New Name",
    style = "minimal",
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    relative = "cursor",
    borderhighlight = "FloatBorder",
    titlehighlight = "Title",
    highlight = tshl,
    focusable = true,
    width = 25,
    height = 1,
    line = "cursor+2",
    col = "cursor-1",
  })

  local map_opts = { noremap = true, silent = true }
  api.nvim_buf_set_keymap(0, "i", "<Esc>", "<cmd>stopinsert | q!<CR>", map_opts)
  api.nvim_buf_set_keymap(0, "n", "<Esc>", "<cmd>stopinsert | q!<CR>", map_opts)
  api.nvim_buf_set_keymap(0, "i", "<CR>", "<cmd>stopinsert | lua _rename('" .. currName .. "')<CR>", map_opts)
  api.nvim_buf_set_keymap(0, "n", "<CR>", "<cmd>stopinsert | lua _rename('" .. currName .. "')<CR>", map_opts)

  local function handler(err, result, ctx, config)
    if err then
      vim.notify(("Error running lsp query '%s': %s"):format(rename, err), vim.log.levels.ERROR)
    end
    local new
    if result and result.changes then
      local msg = ""
      for f, c in pairs(result.changes) do
        new = c[1].newText
        msg = msg .. ("%d changes -> %s"):format(#c, f:gsub("file://", ""):gsub(vim.fn.getcwd(), ".")) .. "\n"
        msg = msg:sub(1, #msg - 1)
        vim.notify(msg, vim.log.levels.INFO, { title = ("Rename: %s -> %s"):format(currName, new) })
      end
    end
    vim.lsp.handlers[rename](err, result, ctx, config)
  end

  function _G._rename(curr)
    local newName = vim.trim(vim.fn.getline ".")
    api.nvim_win_close(win, true)
    if #newName > 0 and newName ~= curr then
      local params = vim.lsp.util.make_position_params()
      params.newName = newName
      vim.lsp.buf_request(0, rename, params, handler)
    end
  end
end

function M.simple_rename(newName)
  local rename = "textDocument/rename"
  local currName = vim.fn.expand "<cword>"

  local function handler(err, result, ctx, config)
    if err then
      vim.notify(("Error running lsp query '%s': %s"):format(rename, err), vim.log.levels.ERROR)
    end
    local new
    if result and result.changes then
      local msg = ""
      for f, c in pairs(result.changes) do
        new = c[1].newText
        msg = msg .. ("%d changes -> %s"):format(#c, f:gsub("file://", ""):gsub(vim.fn.getcwd(), ".")) .. "\n"
        msg = msg:sub(1, #msg - 1)
        vim.notify(msg, vim.log.levels.INFO, { title = ("Rename: %s -> %s"):format(currName, new) })
      end
    end
    vim.lsp.handlers[rename](err, result, ctx, config)
  end

  if #newName > 0 and newName ~= currName then
    local params = vim.lsp.util.make_position_params()
    params.newName = newName
    vim.lsp.buf_request(0, rename, params, handler)
  end
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
      capabilities = client.server_capabilities,
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

local nmap = function(lhs, rhs, description)
  vim.keymap.set("n", lhs, "<Cmd>" .. rhs .. "<CR>", { desc = description, buffer = true })
end

local on_attach_cb = function(client, bufnr)
  bufnr = bufnr or 0
  if lsp_status ~= nil then
    lsp_status.on_attach(client)
  end
  local nmap_capability = function(lhs, method, description, capability_name)
    if client.server_capabilities[capability_name or method] then
      nmap(lhs, "lua vim.lsp.buf." .. method .. "()", description)
      -- TODO: use this when which-key supports new vim.keymap.set callbacks
      -- vim.keymap.set("n", lhs, vim.lsp.buf[method], { desc = description, buffer = bufnr })
    end
  end

  local ft = vim.bo[bufnr].ft
  vim.g["vista_" .. ft .. "_executive"] = "nvim_lsp"

  nmap_capability("gtd", "definition", "Lsp goto definition", "definitionProvider")
  nmap_capability("gh", "hover", "Lsp hover", "hoverProvider")
  nmap_capability("gi", "implementation", "Lsp implementation", "implementationProvider")
  nmap_capability("gS", "signature_help", "Lsp signature help", "signatureHelpProvider")
  nmap_capability("ga", "code_action", "Lsp code actions", "codeActionProvider")
  nmap_capability("gt", "type_definition", "Lsp type definition", "typeDefinitionProvider")

  nmap("<F2>", "lua require'config.lsp'.rename()", "Lsp rename")
  nmap("gd", "lua vim.diagnostic.setloclist{open = true}", "Lsp diagnostics")

  if client.server_capabilities.documentFormattingProvider then
    vim.cmd [[command! Format lua vim.lsp.buf.format{async = true}]]
    nmap("<F3>", "Format", "Lsp format")
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
  if false and client.server_capabilities.documentHighlightProvider then
    set_hl_autocmds()
  end
end

-- vim.lsp.set_log_level "debug"

-- suppress error messages from lang servers
-- from: github.com/siduck76/NvChad/blob/main/lua/plugins/lspconfig.lua
vim.notify = function(msg, log_level, _)
  if msg:match "exit code" then
    return
  end
  if log_level == vim.log.levels.ERROR then
    api.nvim_err_writeln(msg)
  else
    api.nvim_echo({ { msg } }, true, {})
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
    eslint = true,
    gopls = true,
    jsonls = true,
    pyright = true,
    rust_analyzer = true,
    lua_ls = true,
    taplo = true,
    tsserver = true,
    vimls = true,
    yamlls = true,
  }

  for server, active in pairs(local_configs) do
    if not active then
      goto continue
    end
    local cfg = { on_attach = on_attach_cb }
    do
      local ok, cfg_fn = pcall(require, "config.lsp.server." .. server)
      if ok then
        -- Load config from disk
        cfg = cfg_fn(on_attach_cb)
      end
    end
    -- Check if defined cmd is executable
    if cfg.cmd ~= nil then
      if not nvim.executable(cfg.cmd[1]) then
        goto continue
      end
    end
    if lsp_status ~= nil then
      cfg.capabilities = vim.tbl_extend("keep", cfg.capabilities or {}, lsp_status.capabilities)
    end
    if cmp ~= nil then
      cfg.capabilities = cmp
    end
    pcall(lsp[server].setup, cfg)
    M.configs[server] = cfg
    ::continue::
  end
end

M.status = status.status
M.errors = status.errors
M.warnings = status.warnings
M.info = status.info
M.hints = status.hints
return M
