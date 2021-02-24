local hop = nvim.packrequire("hop.nvim", "hop")

if not hop then return end

hop.setup{winblend = 100}

local opts = {remap = false}
vim.api.nvim_set_keymap("n", "<Leader>s",
                        "<Cmd>lua require'hop'.hint_words()<CR>", opts)
vim.api.nvim_set_keymap("n", "f", "<Cmd>lua require'hop'.hint_char1()<CR>", opts)
vim.api.nvim_set_keymap("n", "s", "<Cmd>lua require'hop'.hint_char2()<CR>", opts)
