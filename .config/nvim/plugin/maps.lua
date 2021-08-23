local api = vim.api
local map = vim.map
local n = map.n
local x = map.x
local o = map.o
local i = map.i
local v = map.v
local c = map.c

local tc = function(str)
  return api.nvim_replace_termcodes(str, true, true, true)
end

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

n.nore.expr["<CR>"] = function() -- Clears hlsearch after doing a search, otherwise <CR>
  return tc(vim.v.hlsearch == 1 and "<Cmd>nohlsearch<CR>" or "<CR>")
end

n.nore["<Leader><Leader>c"] = ":<Up>"

-- Move up/down wrapped lines
n.nore.k = "gk"
n.nore.j = "gj"

n.nore["<Up>"] = [[<Cmd>call search('\%'..virtcol('.')..'v\S', 'bw')<CR>]]
n.nore["<Down>"] = [[<Cmd>call search('\%'..virtcol('.')..'v\S', 'w')<CR>]]

-- Use kj to escape insert mode
i.nore.kj = "<Esc>`^"

-- Indent/outdent
v.nore["<Tab>"] = "<Cmd>normal! >gv<CR>"
v.nore["<S-Tab>"] = "<Cmd>normal! <gv<CR>"

-- Window navigation
-- `CTRL+{h,j,k,l}` to navigate in normal mode
n.nore["<C-h>"] = "<C-w>h"
n.nore["<C-j>"] = "<C-w>j"
n.nore["<C-k>"] = "<C-w>k"
n.nore["<C-l>"] = "<C-w>l"
n.nore["<C-p>"] = "<C-w>p"

n.noremap["<A-h>"] = "<Cmd>call window#tmux_aware_resize('h')<CR>"
n.noremap["<A-j>"] = "<Cmd>call window#tmux_aware_resize('j')<CR>"
n.noremap["<A-k>"] = "<Cmd>call window#tmux_aware_resize('k')<CR>"
n.noremap["<A-l>"] = "<Cmd>call window#tmux_aware_resize('l')<CR>"

-- Delete window to the left/below/above/to the right with d<C-h/j/k/l>
n.nore["d<C-j>"] = "<C-w>j<C-w>c"
n.nore["d<C-k>"] = "<C-w>k<C-w>c"
n.nore["d<C-h>"] = "<C-w>h<C-w>c"
n.nore["d<C-l>"] = "<C-w>l<C-w>c"

-- Override vim-impaired tagstack mapping
n.nore["[t"] = "<Cmd>tabprevious<CR>"
n.nore["]t"] = "<Cmd>tabnext<CR>"

-- iBuffer navigation
n.nore["<Tab>"] = "<Cmd>bnext<CR>"
n.nore["<S-Tab>"] = "<Cmd>bprevious<CR>"
n.nore["<Leader>w"] = "<Cmd>update\\|bwipeout<CR>"
n.nore["<Leader>u"] = "<Cmd>update\\|Bdelete<CR>"
n.nore["<Leader>q"] = "<Cmd>Bdelete<CR>"
n.nore["<Leader>x"] = "<Cmd>call window#close_term()<CR>"
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
n.nore["<Leader>ff"] = "<Cmd>call buffer#restore_cursor_after('gggqG')<CR>"
-- Indent buffer and restore cursor position
n.nore["<Leader>fi"] = "<Cmd>call buffer#restore_cursor_after('gg=G')<CR>"

-- Diff mode
-- TODO: try these when actually using diff mode
-- nnoremap <expr> <Leader>gg &diff ? "<Cmd>diffget //1\<CR>" : ""
-- nnoremap <expr> <Leader>gh &diff ? "<Cmd>diffget //2\<CR>" : ""
-- nnoremap <expr> <Leader>gl &diff ? "<Cmd>diffget //3\<CR>" : ""
