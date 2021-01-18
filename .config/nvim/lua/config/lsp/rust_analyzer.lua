return {
cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    settings = {
      ["rust-analyzer"] = {
    rustfmt = {
      extraArgs = {"+nightly"},
      },
    },
    },
}
