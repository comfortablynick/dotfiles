return function(on_attach)
  return {
    cmd = {"efm-langserver"},
    on_attach = on_attach,
    filetypes = {
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
    init_options = {documentFormatting = true},
  }
end
