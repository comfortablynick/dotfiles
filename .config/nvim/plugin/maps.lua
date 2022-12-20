local map = vim.keymap

-- Keep old commenting map out of muscle memory
map.set("n", "<Leader>c<Space>", "gcc", { desc = "Comment line (gcc)", remap = true })
map.set("v", "<Leader>c", "gc", { desc = "Comment selection", remap = true })

map.set("n", "U", "<C-r>", { desc = "Redo" })
map.set("n", "qq", "<Cmd>x<CR>", { desc = "Save (if changes have been made) and quit" })
map.set("n", "qqq", "<Cmd>q!<CR>", { desc = "Quit and abandon changes" })
map.set("n", "QQ", "ZQ", { desc = "Quit and abandon changes" })

-- Remap ; to :
map.set({ "n", "x", "o" }, ";", ":", { desc = "Acts like :" })
map.set("n", "g:", "g;")
map.set("n", "@;", "@:")
map.set({ "n", "x" }, "q;", "q:")

map.set("n", "<CR>", "<Cmd>noh<CR><Bar><Cmd>echon<CR><CR>", { desc = "Clear + Return" })

map.set("n", "<Leader><Leader>c", ":<Up>", { desc = "Last command" })

map.set("n", "k", "gk", { desc = "Move up wrapped lines" })
map.set("n", "j", "gj", { desc = "Move down wrapped lines" })

map.set("n", "<Up>", [[<Cmd>call search('\%'..virtcol('.')..'v\S', 'bw')<CR>]], { desc = "Previous non-blank row" })
map.set("n", "<Down>", [[<Cmd>call search('\%'..virtcol('.')..'v\S', 'w')<CR>]], { desc = "Next non-blank row" })

map.set("i", "kj", "<Esc>`^", { desc = "Escape insert mode" })

map.set("v", "<Tab>", "<Cmd>normal! >gv<CR>", { desc = "Indent" })
map.set("v", "<S-Tab>", "<Cmd>normal! <gv<CR>", { desc = "Outdent" })

-- Window navigation
map.set("n", "<C-h>", "<C-w>h", { desc = "Move to window left" })
map.set("n", "<C-j>", "<C-w>j", { desc = "Move to window below" })
map.set("n", "<C-k>", "<C-w>k", { desc = "Move to window above" })
map.set("n", "<C-l>", "<C-w>l", { desc = "Move to window right" })
map.set("n", "<C-p>", "<C-w>p", { desc = "Move to previous window" })

map.set("n", "<A-h>", "<Cmd>call window#tmux_aware_resize('h')<CR>", { desc = "Tmux-aware resize left" })
map.set("n", "<A-j>", "<Cmd>call window#tmux_aware_resize('j')<CR>", { desc = "Tmux-aware resize right" })
map.set("n", "<A-k>", "<Cmd>call window#tmux_aware_resize('k')<CR>", { desc = "Tmux-aware resize up" })
map.set("n", "<A-l>", "<Cmd>call window#tmux_aware_resize('l')<CR>", { desc = "Tmux-aware resize down" })

map.set("n", "d<C-j>", "<C-w>j<C-w>c", { desc = "Delete window below" })
map.set("n", "d<C-k>", "<C-w>k<C-w>c", { desc = "Delete window above" })
map.set("n", "d<C-h>", "<C-w>h<C-w>c", { desc = "Delete window left" })
map.set("n", "d<C-l>", "<C-w>l<C-w>c", { desc = "Delete window right" })

-- Override vim-impaired tagstack mapping
map.set("n", "[t", "<Cmd>tabprevious<CR>", { desc = "Previous tab" })
map.set("n", "]t", "<Cmd>tabnext<CR>", { desc = "Next tab" })

-- Buffer navigation
map.set("n", "<Tab>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map.set("n", "<S-Tab>", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })
map.set("n", "<Leader>w", "<Cmd>update\\|bwipeout<CR>", { desc = "Update + wipeout buffer" })
map.set("n", "<Leader>u", "<Cmd>update\\|Bdelete<CR>", { desc = "Update + delete buffer" })
map.set("n", "<Leader>q", "<Cmd>Bdelete<CR>", { desc = "Delete buffer" })
map.set("n", "<Leader>x", "<Cmd>call window#close_term()<CR>", { desc = "Close open terminal" })
map.set("n", "<Leader>xx", "<Cmd>BufOnly<CR>", { desc = "BufOnly" })

-- Quickfix
map.set("n", "cq", "<Cmd>call qf#toggle()<CR>", { desc = "Toggle quickfix window" })

-- Fold
map.set("n", "<Space>", "<Cmd>silent! exe 'normal! za'<CR>", { desc = "Open folds under cursor" })
map.set("n", "za", "zA", { desc = "Open folds recursively" })

-- Command line %% -> cwd
map.set("c", "%%", "<C-R>=fnameescape(expand('%:h')).'/'<CR>", { desc = "Insert cwd" })

-- Format/indent
map.set(
  "n",
  "<Leader>ff",
  "<Cmd>call buffer#restore_cursor_after('gggqG')<CR>",
  { desc = "Format buffer with 'formatprg'" }
)
map.set(
  "n",
  "<Leader>fi",
  "<Cmd>call buffer#restore_cursor_after('gg=G')<CR>",
  { desc = "Format buffer with 'indentexpr'" }
)

-- Easy insertion of a trailing ; or , from insert mode
map.set('i', ';;', '<Esc>A;<Esc>')
map.set('i', ',,', '<Esc>A,<Esc>')
