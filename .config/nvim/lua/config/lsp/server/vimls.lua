local util = require "lspconfig/util"

return function(on_attach)
  return {
    cmd = { "vim-language-server", "--stdio" },
    on_attach = on_attach,
    initializationOptions = { diagnostic = { enable = true } },
    root_dir = function(fname)
      return util.root_pattern(".git", "init.vim")(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
  }
end
