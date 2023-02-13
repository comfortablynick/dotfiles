local util = require "lspconfig.util"
return function(on_attach)
  require("neodev").setup { lspconfig = false }
  return {
    on_attach = function(client, bufnr)
      -- Disable formatting to avoid prompts
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      on_attach(client, bufnr)
    end,
    -- Use wrapper script
    cmd = { "luals" },
    root_dir = function(fname)
      return util.root_pattern(".git", ".stylua.toml", ".projections.json")(fname)
        or util.find_git_ancestor(fname)
        or util.path.dirname(fname)
    end,
    before_init = require("neodev.lsp").before_init,
    settings = {
      Lua = {
        runtime = { version = "LuaJIT", path = vim.split(package.path, ";"), pathStrict = true },
        completion = { keywordSnippet = "Disable" },
        diagnostics = {
          enable = false,
          globals = { "vim", "nvim", "p", "after_each", "before_each", "it" },
          disable = { "redefined-local" },
        },
        hint = {
          enable = true,
        },
        workspace = {
          library = (function()
            -- Load the `lua` files from nvim into the runtime
            -- From https://github.com/tjdevries/nlua.nvim/blob/master/lua/nlua/lsp/nvim.lua
            local result = {}
            for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
              local lua_path = path .. "/lua/"
              if vim.fn.isdirectory(lua_path) ~= 0 then
                result[lua_path] = true
              end
            end
            result[vim.fn.expand "$VIMRUNTIME/lua"] = true
            -- Extra files in the source code only?
            result[vim.fn.expand "$HOME/src/neovim/src/nvim/lua"] = true
            return result
          end)(),
          maxPreload = 1000,
          preloadFileSize = 1000,
          checkThirdParty = false,
        },
      },
    },
  }
end
