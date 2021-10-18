local util = require "lspconfig/util"
return function(on_attach)
  return {
    cmd = { "pyright-langserver", "--stdio" },
    on_attach = on_attach,
    filetypes = { "python" },
    root_dir = function(fname)
      return util.root_pattern(".git", "__pycache__", "setup.cfg")(fname)
        or util.find_git_ancestor(fname)
        or util.path.dirname(fname)
    end,
  }
end
