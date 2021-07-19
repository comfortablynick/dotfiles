return function(on_attach)
  return {
    cmd = { "vscode-json-languageserver", "--stdio" },
    on_attach = on_attach,
    filetypes = { "json", "jsonc" },
    init_options = { provideFormatter = true },
  }
end
