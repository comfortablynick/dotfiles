return function(on_attach)
  return {
    cmd = {"vim-language-server", "--stdio"},
    on_attach = on_attach,
    initializationOptions = {diagnostic = {enable = true}},
  }
end
