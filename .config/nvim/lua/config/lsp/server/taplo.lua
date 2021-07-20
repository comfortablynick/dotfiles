local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

return function(on_attach)
  configs.taplo = {
    default_config = {
      cmd = { "taplo-lsp", "run" },
      filetypes = { "toml" },
      root_dir = function(fname)
        return util.root_pattern(".git", "taplo.toml", ".taplo.toml")(fname)
          or util.find_git_ancestor(fname)
          or util.path.dirname(fname)
      end,
    },
  }

  return {
    cmd = configs.taplo.cmd,
    on_attach = on_attach,
    filetypes = configs.taplo.filetypes,
  }
end
