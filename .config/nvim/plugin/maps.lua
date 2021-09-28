local map = vim.map
local n = map.n
local x = map.x
local o = map.o
local i = map.i
local v = map.v
local c = map.c

n.nore.U = "<C-r>"
n.nore.qq = "<Cmd>x<CR>"
n.nore.qqq = "<Cmd>q!<CR>"
n.nore.QQ = "ZQ"

-- Remap ; to :
n.nore[";"] = ":"
x.nore[";"] = ":"
o.nore[";"] = ":"
n.nore["g:"] = "g;"
n.nore["@;"] = "@:"
n.nore["q;"] = "q:"
x.nore["q;"] = "q:"

n.nore["<CR>"] = { "<Cmd>noh<CR><Bar><Cmd>echon<CR><CR>", "Clear + Return" }

n.nore["<Leader><Leader>c"] = { ":<Up>", "Last command" }

-- Move up/down wrapped lines
n.nore.k = "gk"
n.nore.j = "gj"

n.nore["<Up>"] = { [[<Cmd>call search('\%'..virtcol('.')..'v\S', 'bw')<CR>]], "Previous non-blank row" }
n.nore["<Down>"] = { [[<Cmd>call search('\%'..virtcol('.')..'v\S', 'w')<CR>]], "Next non-blank row" }

-- Use kj to escape insert mode
i.nore.kj = "<Esc>`^"

-- Indent/outdent
v.nore["<Tab>"] = { "<Cmd>normal! >gv<CR>", "Indent" }
v.nore["<S-Tab>"] = { "<Cmd>normal! <gv<CR>", "Outdent" }

-- Window navigation
-- `CTRL+{h,j,k,l}` to navigate in normal mode
n.nore["<C-h>"] = { "<C-w>h", "Move to window left" }
n.nore["<C-j>"] = { "<C-w>j", "Move to window below" }
n.nore["<C-k>"] = { "<C-w>k", "Move to window above" }
n.nore["<C-l>"] = { "<C-w>l", "Move to window right" }
n.nore["<C-p>"] = { "<C-w>p", "Move to previous window" }

n.nore["<A-h>"] = { "<Cmd>call window#tmux_aware_resize('h')<CR>", "Tmux-aware resize left" }
n.nore["<A-j>"] = { "<Cmd>call window#tmux_aware_resize('j')<CR>", "Tmux-aware resize right" }
n.nore["<A-k>"] = { "<Cmd>call window#tmux_aware_resize('k')<CR>", "Tmux-aware resize up" }
n.nore["<A-l>"] = { "<Cmd>call window#tmux_aware_resize('l')<CR>", "Tmux-aware resize down" }

-- Delete window to the left/below/above/to the right with d<C-h/j/k/l>
n.nore["d<C-j>"] = { "<C-w>j<C-w>c", "Delete window below" }
n.nore["d<C-k>"] = { "<C-w>k<C-w>c", "Delete window above" }
n.nore["d<C-h>"] = { "<C-w>h<C-w>c", "Delete window left" }
n.nore["d<C-l>"] = { "<C-w>l<C-w>c", "Delete window right" }

-- Override vim-impaired tagstack mapping
n.nore["[t"] = { "<Cmd>tabprevious<CR>", "Previous tab" }
n.nore["]t"] = { "<Cmd>tabnext<CR>", "Next tab" }

-- Buffer navigation
n.nore["<Tab>"] = { "<Cmd>bnext<CR>", "Next buffer" }
n.nore["<S-Tab>"] = { "<Cmd>bprevious<CR>", "Previous buffer" }
n.nore["<Leader>w"] = { "<Cmd>update\\|bwipeout<CR>", "Update + wipeout buffer" }
n.nore["<Leader>u"] = { "<Cmd>update\\|Bdelete<CR>", "Update + delete buffer" }
n.nore["<Leader>q"] = { "<Cmd>Bdelete<CR>", "Delete buffer" }
n.nore["<Leader>x"] = { "<Cmd>call window#close_term()<CR>", "Close open terminal" }
n.nore["<Leader>xx"] = "<Cmd>BufOnly<CR>"

-- Quickfix
n.nore.cq = "<Cmd>call qf#toggle()<CR>"

-- Fold
n.nore["<Space>"] = "<Cmd>silent! exe 'normal! za'<CR>"
n.nore.za = "zA"

-- Command line %% -> cwd
c.nore["%%"] = "<C-R>=fnameescape(expand('%:h')).'/'<CR>"

-- Format/indent
-- Format buffer and restore cursor position
n.nore["<Leader>ff"] = { "<Cmd>call buffer#restore_cursor_after('gggqG')<CR>", "Format buffer with &formatprg" }
-- Indent buffer and restore cursor position
n.nore["<Leader>fi"] = { "<Cmd>call buffer#restore_cursor_after('gg=G')<CR>", "Format buffer with &indentexpr" }

-- Diff mode
-- TODO: try these when actually using diff mode
-- nnoremap <expr> <Leader>gg &diff ? "<Cmd>diffget //1\<CR>" : ""
-- nnoremap <expr> <Leader>gh &diff ? "<Cmd>diffget //2\<CR>" : ""
-- nnoremap <expr> <Leader>gl &diff ? "<Cmd>diffget //3\<CR>" : ""
