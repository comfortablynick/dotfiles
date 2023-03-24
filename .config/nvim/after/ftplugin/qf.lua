if vim.fn.exists ":Cfilter" == 0 then
  vim.cmd.packadd "cfilter"
end

vim.opt_local.list = false
vim.opt_local.relativenumber = false
vim.opt_local.buflisted = false
vim.opt_local.cursorline = true
vim.opt_local.errorformat = "%f|%l col %c|%m"

-- Identify loclist vs qflist
vim.b.qf_is_loc = not vim.fn.empty(vim.fn.getloclist(0))

vim.keymap.set(
  "n",
  "<Left>",
  "<Cmd>call qf#older()<CR>",
  { silent = true, buffer = true, desc = "Open older quickfix list" }
)

vim.keymap.set(
  "n",
  "<Right>",
  "<Cmd>call qf#newer()<CR>",
  { silent = true, buffer = true, desc = "Open newer quickfix list" }
)

vim.keymap.set(
  "n",
  "q",
  "<Cmd>call buffer#quick_close()<CR>",
  { nowait = true, silent = true, buffer = true, desc = "Quick close qflist" }
)
