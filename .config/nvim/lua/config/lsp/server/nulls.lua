return function(on_attach)
  return require("lspconfig")["null-ls"].setup {
    on_attach = on_attach,
  }
end
