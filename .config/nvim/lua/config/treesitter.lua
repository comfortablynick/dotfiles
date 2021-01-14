local tsconfigs = nvim.packrequire("nvim-treesitter", "nvim-treesitter.configs")
if not tsconfigs then return end

tsconfigs.setup{
  ensure_installed = {"lua", "go", "rust", "bash", "yaml", "toml"},
  highlight = {
    enable = true,
    -- disable = { "c", "rust" },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_nelection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {enable = true},
}

vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
