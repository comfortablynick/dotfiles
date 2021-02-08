return function(on_attach)
  return {
    cmd = {"gopls", "serve"},
    on_attach = on_attach,
    settings = {gopls = {analyses = {unusedparams = true}, staticcheck = true}},
  }
end
