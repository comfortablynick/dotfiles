-- LSP configurations
local M = {}
local api = vim.api
local util = vim.lsp.util
local npcall = vim.F.npcall
local lsp = npcall(require, "lspconfig")
local lsp_status = npcall(require, "lsp-status")
local lsps_attached = {}

if lsp_status ~= nil then
  lsp_status.register_progress()
  -- lsp_status.config{
  --   select_symbol = function(cursor_pos, symbol)
  --     if symbol.valueRange then
  --       local value_range = {
  --         ["start"] = {
  --           character = 0,
  --           line = vim.fn.byte2line(symbol.valueRange[1]),
  --         },
  --         ["end"] = {
  --           character = 0,
  --           line = vim.fn.byte2line(symbol.valueRange[2]),
  --         },
  --       }
  --       return require("lsp-status.util").in_range(cursor_pos, value_range)
  --     end
  --   end,
  -- }
end

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
-- vim.lsp.handlers["textDocument/publishDiagnostics"] =
--   function(err, method, params, client_id, bufnr, config)
--     vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
--       underline = true,
--       virtual_text = {spacing = 2},
--       signs = true,
--       update_in_insert = false,
--     })(err, method, params, client_id, bufnr, config)
--     bufnr = bufnr or vim.uri_to_bufnr(params.uri)
--
--     if bufnr == api.nvim_get_current_buf() then
--       vim.lsp.diagnostic.set_loclist{open_loclist = false}
--     end
--   end
vim.lsp.handlers["textDocument/formatting"] =
  function(err, _, result, _, bufnr)
    if err ~= nil or result == nil then return end
    if not vim.bo[bufnr].modified then
      local view = vim.fn.winsaveview()
      vim.lsp.util.apply_text_edits(result, bufnr)
      vim.fn.winrestview(view)
      if bufnr == api.nvim_get_current_buf() then
        vim.cmd[[noautocmd :update]]
      end
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
  local hl_autocmds = {
    lsp_highlight = {
      {"CursorHold", "<buffer>", "lua pcall(vim.lsp.buf.document_highlight)"},
      {"CursorMoved", "<buffer>", "lua vim.lsp.buf.clear_references()"},
      {"InsertEnter", "<buffer>", "lua vim.lsp.buf.clear_references()"},
    },
  }
  nvim.create_augroups(hl_autocmds)
end

local set_rust_inlay_hints = function()
  local inlay_hint_cmd =
    [[nvim.packrequire('lsp_extensions.nvim', 'lsp_extensions').inlay_hints]] ..
      [[{ prefix = " » ", aligned = false, highlight = "NonText", enabled = {"ChainingHint", "TypeHint"}}]]
  local augroup = {
    lsp_rust_inlay_hints = {
      {
        "InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost",
        "<buffer>",
        "lua",
        inlay_hint_cmd,
      },
    },
  }
  nvim.create_augroups(augroup)
end

local nmap = function(key, result)
  api.nvim_buf_set_keymap(0, "n", key, "<Cmd>lua " .. result .. "<CR>",
                          {noremap = true})
end

local on_attach_cb = function(client)
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
  nmap_capability("<F3>", "formatting", "document_formatting")

  nmap("gd", "vim.lsp.diagnostic.set_loclist{open = true}")
  nmap("[d", "vim.lsp.diagnostic.goto_prev()")
  nmap("]d", "vim.lsp.diagnostic.goto_next()")

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
  if false and client.resolved_capabilities.document_highlight then
    set_hl_autocmds()
  end

  -- Rust inlay hints
  if ft == "rust" then set_rust_inlay_hints() end
end

function M.init()
  -- Safely return without error if nvim_lsp isn't installed
  if not lsp then return end
  -- Server configs {{{1
  local configs = {
    -- diagnosticls {{{2
    -- diagnosticls = {
    --   filetypes = {
    --     -- "lua",
    --     "vim",
    --     "sh",
    --     "python",
    --   },
    --   init_options = {
    --     filetypes = {
    --       -- lua = "luacheck",
    --       vim = "vint",
    --       sh = "shellcheck",
    --       python = "pydocstyle",
    --     },
    --     linters = {
    --       -- TODO: why doesn't luacheck work?
    --       -- luacheck = {
    --       --   command = "luacheck",
    --       --   debounce = 100,
    --       --   args = {"--formatter", "plain", "-"},
    --       --   offsetLine = 0,
    --       --   offsetColumn = 0,
    --       --   formatLines = 1,
    --       --   formatPattern = {
    --       --     "[^:]+:(\\d+):(\\d+):\\s*(.*)(\\r|\\n)*$",
    --       --     {line = 1, column = 2, message = 3},
    --       --   },
    --       -- },
    --       -- shellcheck {{{3
    --       shellcheck = {
    --         command = "shellcheck",
    --         rootPatterns = {},
    --         isStdout = true,
    --         isStderr = false,
    --         debounce = 100,
    --         args = {"--format=gcc", "-"},
    --         offsetLine = 0,
    --         offsetColumn = 0,
    --         sourceName = "shellcheck",
    --         formatLines = 1,
    --         formatPattern = {
    --           "^([^:]+):(\\d+):(\\d+):\\s+([^:]+):\\s+(.*)$",
    --           {
    --             line = 2,
    --             column = 3,
    --             endline = 2,
    --             endColumn = 3,
    --             message = {5},
    --             security = 4,
    --           },
    --         },
    --         securities = {error = "error", warning = "warning", note = "info"},
    --       },
    --       -- vint {{{3
    --       vint = {
    --         command = "vint",
    --         debounce = 100,
    --         args = {"--enable-neovim", "-"},
    --         offsetLine = 0,
    --         offsetColumn = 0,
    --         sourceName = "vint",
    --         formatLines = 1,
    --         formatPattern = {
    --           "[^:]+:(\\d+):(\\d+):\\s*(.*)(\\r|\\n)*$",
    --           {line = 1, column = 2, message = 3},
    --         },
    --       },
    --     },
    --     -- shfmt {{{3
    --     formatFiletypes = {sh = "shfmt"},
    --     formatters = {
    --       shfmt = {command = "shfmt", args = {"-i", vim.fn.shiftwidth(), "-"}},
    --     },
    --   },
    -- },
    -- efm-languageserver {{{2
    efm = {
      filetypes = {
        "lua",
        "vim",
        "sh",
        "python",
        "javascript",
        "markdown",
        "yaml",
        "toml",
      },
      init_options = {documentFormatting = true},
    },
    -- sumneko_lua {{{2
    sumneko_lua = {
      cmd = {"lua-language-server"},
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
      cmd = {"yaml-language-server"},
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
    -- jsonls {{{2
    jsonls = {filetypes = {"json", "jsonc"}},
    -- other servers {{{2
    bashls = {},
    cmake = {},
    ccls = {},
    gopls = {},
    pyls_ms = {},
    rust_analyzer = {},
    tsserver = {},
  }

  -- Set configs {{{1
  for server, cfg in pairs(configs) do
    cfg.on_attach = on_attach_cb
    if lsp_status ~= nil then
      cfg.capabilities = vim.tbl_extend("keep", cfg.capabilities or {},
                                        lsp_status.capabilities)
    end
    lsp[server].setup(cfg)
  end
end

return M
-- vim:fdl=1:
