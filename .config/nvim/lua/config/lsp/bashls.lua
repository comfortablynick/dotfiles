return function(on_attach)
  return {
    cmd = { "bash-language-server", "start" },
    on_attach = on_attach,
    filetypes = { "sh" },
  }
end
