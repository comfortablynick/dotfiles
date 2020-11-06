-- LSP configurations
local M = {}
local api = vim.api
local lsp = npcall(require, "nvim_lsp")
local diag = nvim.packrequire("diagnostic-nvim", "diagnostic")

local on_attach_cb = function(client, bufnr)
  api.nvim_buf_set_var(bufnr, "lsp_client_id", client.id)
  local map_opts = {noremap = true, silent = true}
  local nmaps = {
    ["gD"] = "<Cmd>lua vim.lsp.buf.declaration()<CR>",
    ["gd"] = "<Cmd>lua vim.lsp.buf.definition()<CR>",
    ["gh"] = "<Cmd>lua vim.lsp.buf.hover()<CR>",
    ["gi"] = "<Cmd>lua vim.lsp.buf.implementation()<CR>",
    ["gS"] = "<Cmd>lua vim.lsp.buf.signature_help()<CR>",
    ["ga"] = "<Cmd>lua vim.lsp.buf.code_action()<CR>",
    ["gt"] = "<Cmd>lua vim.lsp.buf.type_definition()<CR>",
    ["gr"] = "<Cmd>lua vim.lsp.buf.references()<CR>",
    ["gld"] = "<Cmd>lua vim.lsp.util.show_line_diagnostics()<CR>",
    ["<F2>"] = "<Cmd>lua vim.lsp.buf.rename()<CR>",
  }

  if diag then
    diag.on_attach()
    nmaps["]q"] = "<Cmd>NextDiagnosticCycle<CR>"
    nmaps["[q"] = "<Cmd>PrevDiagnosticCycle<CR>"
  end

  for lhs, rhs in pairs(nmaps) do
    api.nvim_buf_set_keymap(bufnr, "n", lhs, rhs, map_opts)
  end
  vim.cmd[[hi link LspReferenceText CursorColumn]]
  vim.cmd[[hi link LspReferenceRead LspReferenceText]]
  vim.cmd[[hi link LspReferenceWrite LspReferenceText]]

  vim.cmd[[augroup lsp_on_attach]]
  vim.cmd[[autocmd!]]
  vim.cmd[[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
  vim.cmd[[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
  vim.cmd[[autocmd InsertEnter <buffer> lua vim.lsp.buf.clear_references()]]
  vim.cmd[[augroup END]]
end

function M.init()
  -- Safely return without error if nvim_lsp isn't installed
  if not lsp then return end
  local configs = {
    bashls = {},
    cmake = {},
    ccls = {},
    -- TODO: wait until PR is merged to only send requests to supported features
    diagnosticls = {
      filetypes = {"lua", "vim", "sh", "python"},
      init_options = {
        filetypes = {vim = "vint", sh = "shellcheck", python = "pydocstyle"},
        linters = {
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
      },
    },
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
            globals = {"vim", "nvim", "sl", "p", "printf", "npcall"},
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
    tsserver = {},
    vimls = {initializationOptions = {diagnostic = {enable = true}}},
    yamlls = {
      filetypes = {"yaml", "yaml.ansible"},
      settings = {
        yaml = {
          schemas = {["http://json.schemastore.org/ansible-stable-2.9"] = "*"},
        },
      },
    },
  }

  -- Set local configs
  for server, cfg in pairs(configs) do
    cfg.on_attach = on_attach_cb
    lsp[server].setup(cfg)
  end
end

return M
