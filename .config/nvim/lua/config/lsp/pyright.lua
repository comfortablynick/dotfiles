return function(on_attach)
  return {
    cmd = {"pyright-langserver", "--stdio"},
    on_attach = on_attach,
    filetypes = {"python"},
  }
end
