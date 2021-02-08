local configs = require"lspconfig/configs"
local util = require"lspconfig/util"

local root_pattern = util.root_pattern(".git", "config.yml")

return function(on_attach)
  configs.taplo = {
    default_config = {
      cmd = {"taplo-lsp", "run"},
      filetypes = {"toml"},
      root_dir = function(fname)
        return root_pattern(fname) or vim.loop.os_homedir()
      end,
      settings = {},
    },
  }

  return {
    cmd = configs.taplo.cmd,
    on_attach = on_attach,
    filetypes = configs.taplo.filetypes,
  }
end
