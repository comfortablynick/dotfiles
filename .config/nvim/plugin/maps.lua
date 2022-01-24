local map = vim.map
local n = map.n
local i = map.i
local v = map.v
local c = map.c

-- Keep old commenting map out of muscle memory
n.re["<Leader>c<Space>"] = { "gcc", "Comment line (gcc)" }
v.re["<Leader>c"] = { "gc", "Comment selection" }

n.ghh = function()
  print "called from lua"
end

vim.keymap.set("n", "U", "<C-r>")
vim.keymap.set("n", "qq", "<Cmd>x<CR>")
vim.keymap.set("n", "qqq", "<Cmd>q!<CR>")
vim.keymap.set("n", "QQ", "ZQ")

-- Remap ; to :
vim.keymap.set({ "n", "x", "o" }, ";", ":", { desc = "Acts like :" })
vim.keymap.set("n", "g:", "g;")
vim.keymap.set("n", "@;", "@:")
vim.keymap.set({ "n", "x" }, "q;", "q:")

n["<CR>"] = { "<Cmd>noh<CR><Bar><Cmd>echon<CR><CR>", "Clear + Return" }

n["<Leader><Leader>c"] = { ":<Up>", "Last command" }

-- Move up/down wrapped lines
n.k = "gk"
n.j = "gj"

n["<Up>"] = { [[<Cmd>call search('\%'..virtcol('.')..'v\S', 'bw')<CR>]], "Previous non-blank row" }
n["<Down>"] = { [[<Cmd>call search('\%'..virtcol('.')..'v\S', 'w')<CR>]], "Next non-blank row" }

-- Use kj to escape insert mode
i.kj = "<Esc>`^"

-- Indent/outdent
v["<Tab>"] = { "<Cmd>normal! >gv<CR>", "Indent" }
v["<S-Tab>"] = { "<Cmd>normal! <gv<CR>", "Outdent" }

-- Window navigation
-- `CTRL+{h,j,k,l}` to navigate in normal mode
n["<C-h>"] = { "<C-w>h", "Move to window left" }
n["<C-j>"] = { "<C-w>j", "Move to window below" }
n["<C-k>"] = { "<C-w>k", "Move to window above" }
n["<C-l>"] = { "<C-w>l", "Move to window right" }
n["<C-p>"] = { "<C-w>p", "Move to previous window" }

n["<A-h>"] = { "<Cmd>call window#tmux_aware_resize('h')<CR>", "Tmux-aware resize left" }
n["<A-j>"] = { "<Cmd>call window#tmux_aware_resize('j')<CR>", "Tmux-aware resize right" }
n["<A-k>"] = { "<Cmd>call window#tmux_aware_resize('k')<CR>", "Tmux-aware resize up" }
n["<A-l>"] = { "<Cmd>call window#tmux_aware_resize('l')<CR>", "Tmux-aware resize down" }

-- Delete window to the left/below/above/to the right with d<C-h/j/k/l>
n["d<C-j>"] = { "<C-w>j<C-w>c", "Delete window below" }
n["d<C-k>"] = { "<C-w>k<C-w>c", "Delete window above" }
n["d<C-h>"] = { "<C-w>h<C-w>c", "Delete window left" }
n["d<C-l>"] = { "<C-w>l<C-w>c", "Delete window right" }

-- Override vim-impaired tagstack mapping
n["[t"] = { "<Cmd>tabprevious<CR>", "Previous tab" }
n["]t"] = { "<Cmd>tabnext<CR>", "Next tab" }

-- Buffer navigation
n["<Tab>"] = { "<Cmd>bnext<CR>", "Next buffer" }
n["<S-Tab>"] = { "<Cmd>bprevious<CR>", "Previous buffer" }
n["<Leader>w"] = { "<Cmd>update\\|bwipeout<CR>", "Update + wipeout buffer" }
n["<Leader>u"] = { "<Cmd>update\\|Bdelete<CR>", "Update + delete buffer" }
n["<Leader>q"] = { "<Cmd>Bdelete<CR>", "Delete buffer" }
n["<Leader>x"] = { "<Cmd>call window#close_term()<CR>", "Close open terminal" }
n["<Leader>xx"] = "<Cmd>BufOnly<CR>"

-- Quickfix
n.cq = "<Cmd>call qf#toggle()<CR>"

-- Fold
n["<Space>"] = "<Cmd>silent! exe 'normal! za'<CR>"
n.za = "zA"

-- Command line %% -> cwd
c["%%"] = "<C-R>=fnameescape(expand('%:h')).'/'<CR>"

-- Format/indent
-- Format buffer and restore cursor position
n["<Leader>ff"] = { "<Cmd>call buffer#restore_cursor_after('gggqG')<CR>", "Format buffer with 'formatprg'" }
-- Indent buffer and restore cursor position
n["<Leader>fi"] = { "<Cmd>call buffer#restore_cursor_after('gg=G')<CR>", "Format buffer with 'indentexpr'" }

-- Diff mode
-- TODO: try these when actually using diff mode
-- nnoremap <expr> <Leader>gg &diff ? "<Cmd>diffget //1\<CR>" : ""
-- nnoremap <expr> <Leader>gh &diff ? "<Cmd>diffget //2\<CR>" : ""
-- nnoremap <expr> <Leader>gl &diff ? "<Cmd>diffget //3\<CR>" : ""
