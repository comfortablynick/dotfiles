local api = vim.api
local g = vim.g

api.nvim_set_keymap("", "<F3>", "<Cmd>Neoformat<CR>", { noremap = true })
g.neoformat_try_formatprg = 1 -- Use formatprg if defined
g.neoformat_run_all_formatters = 1 -- By default, stops after first formatter succeeds
g.neoformat_basic_format_align = 1 -- Enable basic formatting
g.neoformat_basic_format_retab = 1 -- Enable tab -> spaces
g.neoformat_basic_format_trim = 1 -- Trim trailing whitespace
g.neoformat_only_msg_on_error = 1 -- Quieter

-- Filetype-specific formatters
g.neoformat_enabled_python = {
  "black",
  "isort",
}
g.neoformat_enabled_typescript = { "prettier" }
g.neoformat_enabled_javascript = { "prettier" }
g.neoformat_typescript_prettier = {
  exe = "prettier",
  args = {
    "--stdin",
    "--stdin-filepath",
    '"%:p"',
  },
  stdin = 1,
}

g.neoformat_cmake_cmakeformat = {
  exe = "cmake-format",
  args = { "-c", "$HOME/.config/cmake/cmake-format.py" },
}
-- Same options for javascript
g.neoformat_javascript_prettier = vim.g.neoformat_typescript_prettier

g.neoformat_enabled_go = { "goimports" }
g.neoformat_enabled_yaml = { "prettier" }
g.neoformat_enabled_lua = {}
