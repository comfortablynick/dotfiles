local util = require "lspconfig/util"

return function(on_attach)
  return {
    cmd = { "efm-langserver" },
    on_attach = function(client, bufnr)
      -- This may help with making sure requests don't get sent to efm-langserver
      client.resolved_capabilities.rename = false
      client.resolved_capabilities.hover = false
      on_attach(client, bufnr)
    end,
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
    },
    init_options = { documentFormatting = true },
    root_dir = function(fname)
      return util.root_pattern(".git", "init.vim")(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
  }
end
