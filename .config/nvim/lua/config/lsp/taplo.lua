local configs = require"lspconfig/configs"
local util = require"lspconfig/util"

local root_pattern = util.root_pattern(".git", "config.yml")

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

return {cmd = configs.taplo.cmd, filetypes = configs.taplo.filetypes}
