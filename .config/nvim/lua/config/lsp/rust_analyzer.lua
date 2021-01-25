return {
  cmd = {"rust-analyzer"},
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
      vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = false,
      }),
  },
}
