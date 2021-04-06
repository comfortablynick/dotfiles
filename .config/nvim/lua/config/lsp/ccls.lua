local util = require"lspconfig/util"

return function(on_attach)
  return {
    cmd = {"ccls"},
    on_attach = on_attach,
    filetypes = {"c", "cpp"},
    root_dir = util.root_pattern("compile_commands.json", "compile_flags.txt",
                                 ".ccls", "xmake.lua", ".git"),
    init_options = {
      cache = {
        directory = (vim.loop.os_getenv("XDG_CACHE_HOME") or "~/.cache") ..
          "/ccls",
      },
      compilationDatabaseDirectory = "build",
    },
  }
end
