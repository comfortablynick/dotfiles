-- 0 Always do NOT close floaterm window
-- 1 Close window only if the job exits normally
-- 2 Always close floaterm window
vim.g.floaterm_autoclose = 1
vim.g.floaterm_shell = vim.g.term_shell
vim.g.floaterm_wintitle = true

vim.api.nvim_create_autocmd("FileType", {
  pattern = "floaterm",
  group = vim.api.nvim_create_augroup("plugins_floaterm", {}),
  callback = function()
    vim.keymap.set("t", "<F7>", "<C-\\><C-n><Cmd>FloatermToggle<CR>", { buffer = true })
    vim.keymap.set("t", "<Esc>", "<C-\\><C-n><Cmd>FloatermKill<CR>", { buffer = true })
    vim.keymap.set("t", "<C-c>", "<C-\\><C-n><Cmd>FloatermKill<CR>", { buffer = true })
  end,
})

