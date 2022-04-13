local util = require "lspconfig/util"

return function(on_attach)
  return {
    cmd = { "taplo", "lsp", "stdio" },
    on_attach = function(client, bufnr)
      -- Turn off formatting for now; doesn't respect taplo.toml
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
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
