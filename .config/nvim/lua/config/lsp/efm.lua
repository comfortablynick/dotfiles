local util = require "lspconfig/util"

return function(on_attach)
  return {
    cmd = { "efm-langserver" },
    on_attach = on_attach,
    filetypes = {
      "fish",
      "lua",
      "vim",
      "sh",
      "python",
      "javascript",
      "markdown",
      "yaml",
      "yaml.ansible",
      "toml",
    },
    init_options = { documentFormatting = true },
    root_dir = function(fname)
      return util.root_pattern(".git", "init.vim")(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
  }
end
