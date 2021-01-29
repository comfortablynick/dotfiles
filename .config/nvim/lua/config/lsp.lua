-- LSP configurations
local M = {}
local api = vim.api
local util = vim.lsp.util
local npcall = vim.F.npcall
local lsp = npcall(require, "lspconfig")
local lsp_status = npcall(require, "lsp-status")
local lsps_attached = {}

local configs = require"lspconfig/configs"
local lsp_util = require"lspconfig/util"

local root_pattern = lsp_util.root_pattern(".git", "config.yml")

configs.taplo = {
  default_config = {
    cmd = {"taplo-lsp", "run"},
    filetypes = {"toml"},
    root_dir = function(fname)
      return root_pattern(fname) or vim.loop.os_homedir()
    end,
    settings = {},
  },
}

M.configs = {}

if lsp_status ~= nil then
  lsp_status.register_progress()
  lsp_status.config{
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

vim.fn.sign_define("LspDiagnosticsSignError",
                   {text = "", numhl = "LspDiagnosticsDefaultError"})
vim.fn.sign_define("LspDiagnosticsSignWarning",
                   {text = "", numhl = "LspDiagnosticsDefaultWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation",
                   {text = "", numhl = "LspDiagnosticsDefaultInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint",
                   {text = "", numhl = "LspDiagnosticsDefaultHint"})

local custom_symbol_handler = function(_, _, result, _, bufnr)
  if vim.tbl_isempty(result or {}) then return end

  local items = util.symbols_to_items(result, bufnr)
  local items_by_name = {}
  for _, item in ipairs(items) do items_by_name[item.text] = item end

  local opts = vim.fn["fzf#wrap"]({
    source = vim.tbl_keys(items_by_name),
    sink = function() end,
    options = {"--prompt", "Symbol > "},
  })
  opts.sink = function(item)
    local selected = items_by_name[item]
    vim.fn.cursor(selected.lnum, selected.col)
  end
  vim.fn["fzf#run"](opts)
end

vim.lsp.handlers["textDocument/documentSymbol"] = custom_symbol_handler
vim.lsp.handlers["workspace/symbol"] = custom_symbol_handler
vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = {spacing = 2},
    signs = true,
    update_in_insert = true,
  })

function M.set_hl()
  local ns = api.nvim_create_namespace("hl-lsp")

  -- TODO: fix statusline functions to use new nvim api
  api.nvim_set_hl(ns, "LspDiagnosticsDefaultError", {fg = "#ff5f87"})
  api.nvim_set_hl(ns, "LspDiagnosticsDefaultWarning", {fg = "#d78f00"})
  api.nvim_set_hl(ns, "LspDiagnosticsDefaultInformation", {fg = "#d78f00"})
  api.nvim_set_hl(ns, "LspDiagnosticsDefaultHint", {fg = "#ff5f87", bold = true})
  api.nvim_set_hl(ns, "LspDiagnosticsUnderlineError",
                  {fg = "#ff5f87", sp = "#ff5f87", undercurl = true})
  api.nvim_set_hl(ns, "LspDiagnosticsUnderlineWarning",
                  {fg = "#d78f00", sp = "#d78f00", undercurl = true})
  api.nvim_set_hl(ns, "LspReferenceText", {link = "CursorColumn"})
  api.nvim_set_hl(ns, "LspReferenceRead", {link = "LspReferenceText"})
  api.nvim_set_hl(ns, "LspReferenceWrite", {link = "LspReferenceText"})
  api.nvim_set_hl_ns(ns)
end

-- Standard rename functionality wrapper
--
-- @param new_name string New name for variable under cursor
-- @return string
function M.rename(new_name)
  local params = util.make_position_params()
  new_name = new_name or
               npcall(vim.fn.input, "New Name: ", vim.fn.expand("<cword>"))
  if not (new_name and #new_name > 0) then return end
  params.newName = new_name
  vim.lsp.buf_request(0, "textDocument/rename", params)
end

function M.attached_lsps()
  local bufnr = api.nvim_get_current_buf()
  if not lsps_attached[bufnr] then return "" end
  return "LSP[" .. table.concat(vim.tbl_values(lsps_attached[bufnr]), ",") ..
           "]"
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
  nvim.mcmd[[
      au CursorHold <buffer> lua pcall(vim.lsp.buf.document_highlight)
      au CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      au InsertEnter <buffer> lua vim.lsp.buf.clear_references()
      ]]
end

local set_rust_inlay_hints = function()
  vim.cmd(
    [[au InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost <buffer> lua ]] ..
      [[nvim.packrequire('lsp_extensions.nvim', 'lsp_extensions').inlay_hints]] ..
      [[{ prefix = " » ", aligned = false, highlight = "NonText", enabled = {"ChainingHint", "TypeHint"}}]])
end

local nmap = function(key, result)
  api.nvim_buf_set_keymap(0, "n", key, "<Cmd>lua " .. result .. "<CR>",
                          {noremap = true})
end

local on_attach_cb = function(client)
  if lsp_status ~= nil then lsp_status.on_attach(client) end
  local nmap_capability = function(lhs, method, capability_name)
    if client.resolved_capabilities[capability_name or method] then
      nmap(lhs, "vim.lsp.buf." .. method .. "()")
    end
  end

  local bufnr = api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].ft
  vim.g["vista_" .. ft .. "_executive"] = "nvim_lsp"

  nmap_capability("gD", "definition", "goto_definition")
  nmap_capability("gh", "hover")
  nmap_capability("gi", "implementation")
  nmap_capability("gS", "signature_help")
  nmap_capability("ga", "code_action")
  nmap_capability("gt", "type_definition")
  nmap_capability("gr", "references")
  nmap_capability("<F2>", "rename")

  nmap("gd", "vim.lsp.diagnostic.set_loclist{open = true}")
  nmap("[d", "vim.lsp.diagnostic.goto_prev{popup_opts = {show_header = false}}")
  nmap("]d", "vim.lsp.diagnostic.goto_next{popup_opts = {show_header = false}}")
  nmap("[D",
       "vim.lsp.diagnostic.goto_prev{cursor_position = {-1, -1}, popup_opts = {show_header = false}}")
  nmap("]D",
       "vim.lsp.diagnostic.goto_next{cursor_position = {0, 0}, popup_opts = {show_header = false}}")

  if client.resolved_capabilities["document_formatting"] then
    vim.cmd[[command! Format lua vim.lsp.buf.formatting()]]
    -- TODO: why does this not work as well as Neoformat?
    api.nvim_buf_set_keymap(bufnr, "", "<F3>", "<Cmd>Format<CR>",
                            {noremap = true})
  end

  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

  -- Add client name to variable
  local name_replacements = {diagnosticls = "diag", sumneko_lua = "sumneko"}
  if not lsps_attached[bufnr] then lsps_attached[bufnr] = {} end
  local client_display_name = name_replacements[client.name] or client.name
  -- Don't duplicate name if we're reloading, etc.
  if not vim.tbl_contains(lsps_attached[bufnr], client_display_name) then
    table.insert(lsps_attached[bufnr], client_display_name)
  end

  -- Set autocmds for highlighting if server supports it
  if true and client.resolved_capabilities.document_highlight then
    set_hl_autocmds()
  end

  -- Rust inlay hints
  if ft == "rust" then set_rust_inlay_hints() end
end

-- vim.lsp.set_log_level("debug")

function M.init()
  if not lsp then return end
  -- Server configs {{{1
  -- If true, load config from config.lsp.{server}
  local local_configs = {
    sumneko_lua = true,
    efm = true,
    -- diagnosticls = true,
    vimls = true,
    yamlls = true,
    jsonls = true,
    gopls = true,
    rust_analyzer = true,
    bashls = true,
    -- taplo = false,
    cmake = false,
    ccls = false,
    pyright = false,
    tsserver = false,
  }

  for server, load_cfg in pairs(local_configs) do
    local cfg = {}
    if load_cfg then
      cfg = npcall(require, "config.lsp." .. server)
      -- Check if defined cmd is executable
      if cfg.cmd ~= nil then
        if vim.fn.executable(cfg.cmd[1]) ~= 1 then goto continue end
      end
    end
    cfg.on_attach = on_attach_cb
    if lsp_status ~= nil then
      cfg.capabilities = vim.tbl_extend("keep", cfg.capabilities or {},
                                        lsp_status.capabilities)
    end
    lsp[server].setup(cfg)
    M.configs[server] = cfg
    ::continue::
  end
end

-- Util :: utility functions --{{{1
M.util = {
  lsp_info = function()
    local print_clients = function(clients)
      local clients_fmt = {}
      for _, client in ipairs(clients) do
        vim.list_extend(clients_fmt, {
          "",
          ("### Client %d: %s"):format(client.id, client.name),
          "- Cmd: `" .. table.concat(client.config.cmd, ", ") .. "`",
          "- Root: " .. client.workspaceFolders[1].name,
          "- Filetypes: " .. table.concat(client.config.filetypes, ", "),
        })
      end
      return clients_fmt
    end

    local lsp_configs = npcall(require, "lspconfig/configs")
    -- These options need to be cached before switching to the floating
    -- buffer.
    local buf_clients = vim.lsp.buf_get_clients()
    local clients = vim.lsp.get_active_clients()
    local buffer_filetype = vim.bo.filetype
    local buffer_dir = vim.fn.expand"%:p:h"
    local buf_lines = {}
    local header = {
      "# Lsp Info",
      "",
      "## Available servers",
      table.concat(vim.tbl_keys(lsp_configs), ", "),
      "",
      "## Attached clients",
      "Attached to this buffer: " .. tostring(#buf_clients),
    }
    vim.list_extend(buf_lines, header)
    vim.list_extend(buf_lines, print_clients(buf_clients))

    local active_section_header = {
      "",
      "## Active clients",
      "",
      "Total active clients: " .. tostring(#clients),
    }
    vim.list_extend(buf_lines, active_section_header)
    vim.list_extend(buf_lines, print_clients(clients))
    local matching_config_header = {
      "",
      "## Clients that match the current buffer filetype:",
    }
    vim.list_extend(buf_lines, matching_config_header)
    for _, config in pairs(lsp_configs) do
      local config_table = config.make_config(buffer_dir)

      local cmd_is_executable, cmd
      if config_table.cmd then
        cmd = table.concat(config_table.cmd, " ")
        if vim.fn.executable(config_table.cmd[1]) == 1 then
          cmd_is_executable = "True"
        else
          cmd_is_executable =
            "False. Please check your path and ensure the server is installed"
        end
      else
        cmd = "cmd not defined"
        cmd_is_executable = cmd
      end

      for _, filetype_match in ipairs(config_table.filetypes) do
        if buffer_filetype == filetype_match then
          local matching_config_info = {
            "",
            "### Config: " .. config.name,
            "- Cmd: `" .. cmd .. "`",
            "- Executable: " .. cmd_is_executable,
            "- Identified root: " .. (config_table.root_dir or "None"),
            "- Custom handlers: " ..
              table.concat(vim.tbl_keys(config_table.handlers), ", "),
          }
          vim.list_extend(buf_lines, matching_config_info)
        end
      end
    end
    local bufnr = require"window".create_centered_floating{
      height = 0.8,
      width = 0.7,
    }
    vim.bo[bufnr].filetype = "markdown"
    api.nvim_buf_set_lines(bufnr, 0, -1, true, buf_lines)
    api.nvim_buf_set_keymap(bufnr, "n", "<Esc>", "<Cmd>bd<CR>", {noremap = true})
    api.nvim_buf_set_keymap(bufnr, "n", "<C-c>", "<Cmd>bd<CR>", {noremap = true})
    vim.bo[bufnr].modifiable = false
    local winnr = vim.fn.bufwinnr(bufnr)
    local winid = vim.fn.win_getid(winnr)
    vim.lsp.util.close_preview_autocmd({"BufHidden", "BufLeave"}, winnr)
    vim.wo[winid].spell = false
    vim.wo[winid].wrap = true
  end,
}

-- Utility commands {{{2
vim.cmd[[command! LspClients lua require'config.lsp'.util.lsp_info()]]

-- Set and return module
M.status = require"config.lsp.status".status
return M
