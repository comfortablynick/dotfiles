return function(on_attach)
  return {
    cmd = {"rust-analyzer"},
    on_attach = on_attach,
    filetypes = {"rust"},
    settings = {
      ["rust-analyzer"] = {
        diagnostics = {disabled = {"inactive-code"}},
        rustfmt = {extraArgs = {"+nightly"}},
        trace = {server = "off"},
      },
    },
    handlers = {
      ["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {update_in_insert = false}),
    },
  }
end
