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
          checkThirdParty = false,
        },
      },
    },
  }
end
