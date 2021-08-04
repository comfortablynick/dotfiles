local util = require "lspconfig/util"

return function(on_attach)
  return {
    cmd = { "ansible-language-server", "--stdio" },
    on_attach = on_attach,
    filetypes = { "yaml.ansible" },
    root_dir = function(fname)
      return util.root_pattern { "*.yml", "*.yaml" }(fname)
    end,
    settings = {
      ansible = {
        ansible = {
          path = "ansible",
        },
        ansibleLint = {
          enabled = true,
          path = "ansible-lint",
        },
        python = {
          interpreterPath = "python",
        },
      },
    },
  }
end
