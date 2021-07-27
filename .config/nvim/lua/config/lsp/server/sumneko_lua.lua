local util = require "lspconfig/util"
return function(on_attach)
  return {
    on_attach = on_attach,
    -- Use wrapper script
    cmd = { "luals" },
    root_dir = function(fname)
      return util.root_pattern(".git", "init.vim")(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
    settings = {
      Lua = {
        runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
        completion = { keywordSnippet = "Disable" },
        diagnostics = {
          enable = false,
          globals = { "vim", "nvim", "p", "after_each", "before_each", "it" },
          disable = { "redefined-local" },
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
