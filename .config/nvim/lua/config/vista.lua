vim.g.vista_echo_cursor_strategy = "floating_win"
vim.g["vista#executives"] = { "nvim_lsp", "ctags" }
vim.g.vista_default_executive = "ctags"
vim.g.vista_fzf_preview = { "right:50%" }
vim.g.vista_fzf_opt = {
  "-m",
  "--bind",
  "left:preview-up," .. "right:preview-down," .. "ctrl-a:select-all," .. "?:toggle-preview",
}
vim.g.vista_echo_cursor = 1
vim.g.vista_floating_delay = 1000
vim.g["vista#renderer#enable_icon"] = 0
vim.g.vista_close_on_jump = 0
vim.g.vista_sidebar_width = 60

vim.map.n.nore["<Leader><Leader>v"] = { "<Cmd>Vista!!<CR>", "Vista toggle" }
