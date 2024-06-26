local util = require "lspconfig/util"

return function(on_attach)
  return {
    cmd = { "taplo-lsp", "run" },
    on_attach = function(client, bufnr)
      -- Turn off formatting for now; doesn't respect taplo.toml
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      on_attach(client, bufnr)
    end,
    filetypes = { "toml" },
    root_dir = function(fname)
      return util.root_pattern(".git", "taplo.toml", ".taplo.toml")(fname)
        or util.find_git_ancestor(fname)
        or util.path.dirname(fname)
    end,
  }
end
