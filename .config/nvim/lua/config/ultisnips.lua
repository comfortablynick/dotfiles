vim.g.UltiSnipsExpandTrigger = "<C-s>"
vim.g.UltiSnipsJumpForwardTrigger = "<C-k>"
vim.g.UltiSnipsJumpBackwardTrigger = "<C-h>"
vim.g.UltiSnipsSnippetDirectories = { "~/.config/ultisnips" }
vim.g.UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit = "~/.config/ultisnips"
vim.g.snips_author = "Nick Murphy"
vim.g.snips_email = "comfortablynick@gmail.com"
vim.g.snips_github = "https://github.com/comfortablynick"

vim.fn["map#cabbr"]("es", "UltiSnipsEdit")
vim.keymap.set("i", "<Plug>(UltiForward)", "<C-R>=UltiSnips#JumpForwards()<CR>")

