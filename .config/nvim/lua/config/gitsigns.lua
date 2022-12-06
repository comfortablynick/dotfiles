local installed, gitsigns = pcall(require, "gitsigns")

if not installed then
  return
end

gitsigns.setup {
  signs = {
    add = { hl = "DiffAdd", text = "│" },
    change = { hl = "DiffChange", text = "│" },
    delete = { hl = "DiffDelete", text = "_" },
    topdelete = { hl = "DiffDelete", text = "‾" },
    changedelete = { hl = "DiffChange", text = "~" },
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local bmap = vim.map["buffer" .. bufnr]

    -- Navigation
    vim.keymap.set(
      "n",
      "]c",
      "&diff ? '[c' : '<Cmd>Gitsigns next_hunk<CR>'",
      { expr = true, buffer = bufnr, desc = "Git next hunk", replace_keycodes = false }
    )
    vim.keymap.set(
      "n",
      "[c",
      "&diff ? '[c' : '<Cmd>Gitsigns prev_hunk<CR>'",
      { expr = true, buffer = bufnr, desc = "Git prev hunk", replace_keycodes = false }
    )

    -- Actions
    bmap.n.gs = { gs.preview_hunk, "Git show hunk" }
    bmap.n.v.ghs = { gs.stage_hunk, "Git stage hunk" }
    bmap.n.v.ghr = { gs.reset_hunk, "Git reset hunk" }
    bmap.n.ghu = { gs.undo_stage_hunk, "Git undo staged hunk" }
    bmap.n.ghS = { gs.stage_buffer, "Git stage buffer" }
    bmap.n.ghR = { gs.stage_buffer, "Git reset buffer" }
    bmap.n.ghb = {
      function()
        gs.blame_line { full = true }
      end,
      "Git blame line",
    }
    bmap.n.ghd = { gs.toggle_deleted, "Git toggle deleted" }

    -- Text objects
    bmap.o.x.ih = { ":<C-U>Gitsigns select_hunk<CR>", "Git select hunk" }
  end,
  watch_gitdir = { interval = 1000 },
  sign_priority = 6,
  status_formatter = nil,
  current_line_blame = false,
  diff_opts = { internal = true },
}
