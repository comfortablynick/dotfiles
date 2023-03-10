local ok, fzf = pcall(require, "fzf-lua")
if not ok then
  return
end

-- vim.keymap.set("n", "<Leader><Leader>d", function()
--   fzf.lsp_document_symbols()
-- end, { desc = "Show document symbols in fzf" })
--
-- vim.keymap.set("n", "<Leader><Leader>w", function()
--   fzf.lsp_workspace_symbols()
-- end, { desc = "Show workspace symbols in fzf" })

fzf.setup {
  winopts = {
    height = 0.75,
    width = 0.65,
  },
}
