local g = vim.g
local api = vim.api

g.vista_echo_cursor_strategy = "floating_win"
g["vista#executives"] = { "nvim_lsp", "ctags" }
g.vista_default_executive = "ctags"
g.vista_fzf_preview = { "right:50%" }
g.vista_fzf_opt = {
  "-m",
  "--bind",
  "left:preview-up," .. "right:preview-down," .. "ctrl-a:select-all," .. "?:toggle-preview",
}
g.vista_echo_cursor = 1
g.vista_floating_delay = 1000
g["vista#renderer#enable_icon"] = 0
g.vista_close_on_jump = 0
g.vista_sidebar_width = 60
api.nvim_set_keymap("n", "<Leader><Leader>v", "<Cmd>Vista!!<CR>", { noremap = true })
