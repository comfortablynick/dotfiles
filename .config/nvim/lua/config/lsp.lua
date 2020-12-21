-- LSP configurations
local M = {}
local api = vim.api
local util = vim.lsp.util
local npcall = vim.F.npcall
local lsp = npcall(require, "lspconfig")
local lsp_status = npcall(require, "lsp-status")
local lsps_attached = {}

if lsp_status ~= nil then lsp_status.register_progress() end

vim.fn.sign_define("LspDiagnosticsSignError", {text = "✖"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "‼"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "i"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "»"})

local ns = api.nvim_create_namespace("hl-lsp")

-- TODO: fix statusline functions to use new nvim api
api.nvim_set_hl(ns, "LspDiagnosticsDefaultError", {fg = "#ff5f87"})
api.nvim_set_hl(ns, "LspDiagnosticsDefaultWarning", {fg = "#d78f00"})
api.nvim_set_hl(ns, "LspDiagnosticsDefaultInformation", {fg = "#d78f00"})
api.nvim_set_hl(ns, "LspDiagnosticsDefaultHint", {fg = "#ff5f87", bold = true})
api.nvim_set_hl(ns, "LspDiagnosticsUnderlineError",
                {fg = "#ff5f87", sp = "#ff5f87"})
api.nvim_set_hl(ns, "LspDiagnosticsUnderlineWarning",
                {fg = "#d78f00", sp = "#d78f00"})
api.nvim_set_hl(ns, "LspReferenceText", {link = "CursorColumn"})
api.nvim_set_hl(ns, "LspReferenceRead", {link = "LspReferenceText"})
api.nvim_set_hl(ns, "LspReferenceWrite", {link = "LspReferenceText"})
api.nvim_set_hl_ns(ns)

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
  function(err, method, params, client_id, bufnr, config)
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      underline = true,
      virtual_text = {spacing = 2},
      signs = true,
      update_in_insert = false,
    })(err, method, params, client_id, bufnr, config)
    bufnr = bufnr or vim.uri_to_bufnr(params.uri)

    if bufnr == api.nvim_get_current_buf() then
      vim.lsp.diagnostic.set_loclist{open_loclist = false}
    end
  end

-- Standard rename functionality so I can wrap it if desired
function M.rename(new_name)
  local params = util.make_position_params()
  new_name = new_name or
               npcall(vim.fn.input, "New Name: ", vim.fn.expand("<cword>"))
  if not (new_name and #new_name > 0) then return end
  params.newName = new_name
  vim.lsp.buf_request(0, "textDocument/rename", params)
end

function M.status()
  if lsp_status ~= nil then
    return lsp_status.status{current_function = false}
  else
    return ""
  end
end

function M.attached_lsps()
  local bufnr = api.nvim_get_current_buf()
  if not lsps_attached[bufnr] then return "" end
  return "LSP[" .. table.concat(vim.tbl_values(lsps_attached[bufnr]), ",") ..
           "]"
end

function M.messages()
  if lsp_status ~= nil then
    return lsp_status.messages()
  else
    return {}
  end
end

local set_hl_autocmds = function()
  -- TODO: how to undo this if server detaches?
  local hl_autocmds = {
    lsp_highlight = {
      {"CursorHold", "<buffer>", "lua pcall(vim.lsp.buf.document_highlight)"},
      {"CursorMoved", "<buffer>", "lua vim.lsp.buf.clear_references()"},
      {"InsertEnter", "<buffer>", "lua vim.lsp.buf.clear_references()"},
    },
  }
  nvim.create_augroups(hl_autocmds)
end

local mapper = function(mode, key, result)
  api.nvim_buf_set_keymap(0, mode, key, "<Cmd>lua " .. result .. "<CR>",
                          {noremap = true, silent = true})
end

local on_attach_cb = function(client)
  -- vim.cmd(string.format("echom 'buffer %d: %s started'",
  --                       api.nvim_get_current_buf(), client.name))
  local bufnr = api.nvim_get_current_buf()
  vim.cmd[[let g:vista_{&ft}_executive = 'nvim_lsp']]

  local cap = client.resolved_capabilities

  if cap.goto_definition then mapper("n", "gD", "vim.lsp.buf.definition()") end
  if cap.hover then mapper("n", "gh", "vim.lsp.buf.hover()") end
  if cap.implementation then mapper("n", "gi", "vim.lsp.buf.implementation()") end
  if cap.signature_help then mapper("n", "gS", "vim.lsp.buf.signature_help()") end
  if cap.code_action then mapper("n", "ga", "vim.lsp.buf.code_action()") end
  if cap.type_definition then
    mapper("n", "gt", "vim.lsp.buf.type_definition()")
  end
  if cap.find_references then mapper("n", "gr", "vim.lsp.buf.references()") end
  if cap.rename then mapper("n", "<F2>", "vim.lsp.buf.rename()") end
  mapper("n", "gd", "vim.lsp.diagnostic.set_loclist{open = true}")
  mapper("n", "[d", "vim.lsp.diagnostic.goto_prev()")
  mapper("n", "]d", "vim.lsp.diagnostic.goto_next()")

  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

  -- Add client name to variable
  local name_replacements = {diagnosticls = "diag", sumneko_lua = "sumneko"}
  if not lsps_attached[bufnr] then lsps_attached[bufnr] = {} end
  table.insert(lsps_attached[bufnr],
               name_replacements[client.name] or client.name)

  -- Set autocmds for highlighting if server supports it
  if false and cap.document_highlight then set_hl_autocmds() end
end

function M.init()
  -- Safely return without error if nvim_lsp isn't installed
  if not lsp then return end
  -- Server configs {{{1
  local configs = {
    -- diagnosticls {{{2
    diagnosticls = {
      filetypes = {"lua", "vim", "sh", "python"},
      init_options = {
        filetypes = {
          lua = "luacheck",
          vim = "vint",
          sh = "shellcheck",
          python = "pydocstyle",
        },
        linters = {
          -- TODO: why doesn't luacheck work?
          luacheck = {
            command = "luacheck",
            debounce = 100,
            args = {"--formatter", "plain", "-"},
            offsetLine = 0,
            offsetColumn = 0,
            formatLines = 1,
            formatPattern = {
              "[^:]+:(\\d+):(\\d+):\\s*(.*)(\\r|\\n)*$",
              {line = 1, column = 2, message = 3},
            },
          },
          shellcheck = {
            command = "shellcheck",
            rootPatterns = {},
            isStdout = true,
            isStderr = false,
            debounce = 100,
            args = {"--format=gcc", "-"},
            offsetLine = 0,
            offsetColumn = 0,
            sourceName = "shellcheck",
            formatLines = 1,
            formatPattern = {
              "^([^:]+):(\\d+):(\\d+):\\s+([^:]+):\\s+(.*)$",
              {
                line = 2,
                column = 3,
                endline = 2,
                endColumn = 3,
                message = {5},
                security = 4,
              },
            },
            securities = {error = "error", warning = "warning", note = "info"},
          },
          -- vint {{{3
          vint = {
            command = "vint",
            debounce = 100,
            args = {"--enable-neovim", "-"},
            offsetLine = 0,
            offsetColumn = 0,
            sourceName = "vint",
            formatLines = 1,
            formatPattern = {
              "[^:]+:(\\d+):(\\d+):\\s*(.*)(\\r|\\n)*$",
              {line = 1, column = 2, message = 3},
            },
          },
        },
        -- shfmt {{{3
        formatFiletypes = {sh = "shfmt"},
        formatters = {
          shfmt = {command = "shfmt", args = {"-i", vim.fn.shiftwidth(), "-"}},
        },
      },
    },
    -- sumneko_lua {{{2
    sumneko_lua = {
      settings = {
        Lua = {
          runtime = {version = "LuaJIT", path = vim.split(package.path, ";")},
          completion = {keywordSnippet = "Disable"},
          diagnostics = {
            enable = true,
            globals = {"vim", "nvim", "p"},
            disable = {"redefined-local"},
          },
          workspace = {
            library = (function()
              -- Load the `lua` files from nvim into the runtime
              -- From https://github.com/tjdevries/nlua.nvim/blob/master/lua/nlua/lsp/nvim.lua
              local result = {};
              for _, path in pairs(api.nvim_list_runtime_paths()) do
                local lua_path = path .. "/lua/";
                if vim.fn.isdirectory(lua_path) then
                  result[lua_path] = true
                end
              end
              result[vim.fn.expand("$VIMRUNTIME/lua")] = true
              -- Extra files in the source code only?
              result[vim.fn.expand("$HOME/src/neovim/src/nvim/lua")] = true
              return result;
            end)(),
            maxPreload = 1000,
            preloadFileSize = 1000,
          },
        },
      },
    },
    -- vimlls {{{2
    vimls = {initializationOptions = {diagnostic = {enable = true}}},
    -- yamlls {{{2
    yamlls = {
      filetypes = {"yaml", "yaml.ansible"},
      settings = {
        yaml = {
          schemas = {
            ["https://json.schemastore.org/ansible-role-2.9"] = ".ansible/roles/*/*.yml",
            ["https://gist.githubusercontent.com/KROSF/c5435acf590acd632f71bb720f685895/raw/6f11aa982ad09a341e20fa7f4beed1a1b2a8f40e/taskfile.schema.json"] = "Taskfile.yml",
          },
        },
      },
    },
    -- other servers {{{2
    bashls = {},
    cmake = {},
    ccls = {},
    gopls = {},
    jsonls = {},
    pyls_ms = {},
    rust_analyzer = {},
    tsserver = {},
  }

  -- Set configs {{{1
  for server, cfg in pairs(configs) do
    cfg.on_attach = on_attach_cb
    -- if lsp_status ~= nil then cfg.capabilities = lsp_status.capabilities end
    lsp[server].setup(cfg)
  end
end

return M
