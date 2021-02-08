return function(on_attach)
  return {
    cmd = {"pyright", "--stdio"},
    on_attach = on_attach,
    filetypes = {"python"},
  }
end
