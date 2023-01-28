return function(on_attach)
  local rust_on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    -- vim.api.nvim_create_autocmd({ "InsertLeave", "BufEnter", "BufWinEnter", "TabEnter", "BufWritePost" }, {
    --   group = vim.api.nvim_create_augroup("ra_inlay_hints", {}),
    --   buffer = bufnr,
    --   callback = function()
    --     require("lsp_extensions").inlay_hints {
    --       prefix = " » ",
    --       aligned = false,
    --       highlight = "NonText",
    --       enabled = { "ChainingHint", "TypeHint" },
    --     }
    --   end,
    --   desc = "Rust_analyzer inlay hints",
    -- })
  end

  return {
    cmd = { "rust-analyzer" },
    on_attach = rust_on_attach,
    filetypes = { "rust" },
    settings = {
      ["rust-analyzer"] = {
        diagnostics = { disabled = { "inactive-code" } },
        rustfmt = { extraArgs = { "+nightly" } },
        trace = { server = "off" },
      },
    },
    handlers = {
      ["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        { update_in_insert = false }
      ),
    },
  }
end
