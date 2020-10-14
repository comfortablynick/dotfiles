-- LSP configurations
local M = {}
local api = vim.api
local lsp = npcall(require, "nvim_lsp")

-- TODO: create lua `packadd` command that will combine the below steps
vim.cmd[[silent! packadd diagnostic-nvim]]
local diag = npcall(require, "diagnostic")

-- local diagnostics_qf_cb = function(err, method, result, client_id)
--   -- Use default callback too
--   local def_diagnostics_cb = vim.lsp.callbacks["textDocument/publishDiagnostics"]
--   def_diagnostics_cb(err, method, result, client_id)
--   -- Add to quickfix
--   if result and result.diagnostics then
--     for _, v in ipairs(result.diagnostics) do
--       v.bufnr = client_id
--       v.lnum = v.range.start.line + 1
--       v.col = v.range.start.character + 1
--       v.text = v.message
--     end
--     vim.lsp.util.set_qflist(result.diagnostics)
--   end
-- end

local on_attach_cb = function(client, bufnr)
  -- TODO: create lua `packadd` command that will combine the below steps
  if diag then diag.on_attach() end

  api.nvim_buf_set_var(bufnr, "lsp_client_id", client.id)
  local map_opts = {noremap = true, silent = true}
  local nmaps = {
    [";d"] = "<Cmd>lua vim.lsp.buf.declaration()<CR>",
    ["gd"] = "<Cmd>lua vim.lsp.buf.definition()<CR>",
    ["gh"] = "<Cmd>lua vim.lsp.buf.hover()<CR>",
    ["gi"] = "<Cmd>lua vim.lsp.buf.implementation()<CR>",
    [";s"] = "<Cmd>lua vim.lsp.buf.signature_help()<CR>",
    [";a"] = "<Cmd>lua vim.lsp.buf.code_action()<CR>",
    ["gt"] = "<Cmd>lua vim.lsp.buf.type_definition()<CR>",
    ["gr"] = "<Cmd>lua vim.lsp.buf.references()<CR>",
    ["gld"] = "<Cmd>lua vim.lsp.util.show_line_diagnostics()<CR>",
    ["<F2>"] = "<Cmd>lua vim.lsp.buf.rename()<CR>",
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
    -- TODO: wait until PR is merged to only send requests to supported features
    -- diagnosticls = {
    --   filetypes = {"lua", "vim", "sh", "python"},
    --   init_options = {
    --     filetypes = {vim = "vint", sh = "shellcheck", python = "pydocstyle"},
    --     linters = {
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

  -- Set global callbacks
  -- Can also be set locally for each server
  -- vim.lsp.callbacks["textDocument/publishDiagnostics"] = diagnostics_qf_cb

  -- Set local configs
  for server, cfg in pairs(configs) do
    cfg.on_attach = on_attach_cb
    lsp[server].setup(cfg)
  end
end

return M
