local tsconfigs = nvim.packrequire("nvim-treesitter", "nvim-treesitter.configs")
if not tsconfigs then return end

tsconfigs.setup{
  ensure_installed = {"lua", "go", "rust", "bash", "yaml", "toml"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,
    -- disable = { "c", "rust" },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {enable = true},
}
