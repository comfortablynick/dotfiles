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
    vim.keymap.set("n", "gs", gs.preview_hunk, { desc = "Git show hunk", buffer = bufnr })
    vim.keymap.set({ "n", "v" }, "ghs", gs.stage_hunk, { desc = "Git stage hunk", buffer = bufnr })
    vim.keymap.set({ "n", "v" }, "ghr", gs.reset_hunk, { desc = "Git reset hunk", buffer = bufnr })
    vim.keymap.set("n", "ghu", gs.undo_stage_hunk, { desc = "Git undo staged hunk", buffer = bufnr })
    vim.keymap.set("n", "ghS", gs.stage_buffer, { desc = "Git stage buffer", buffer = bufnr })
    vim.keymap.set("n", "ghR", gs.stage_buffer, { desc = "Git reset buffer", buffer = bufnr })
    vim.keymap.set("n", "ghb", function()
      gs.blame_line { full = true }
    end, { desc = "Git blame line", buffer = bufnr })
    vim.keymap.set("n", "ghd", gs.toggle_deleted, { desc = "Git toggle deleted", buffer = bufnr })

    -- Text objects
    vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git select hunk", buffer = bufnr })
  end,
  watch_gitdir = { interval = 1000 },
  sign_priority = 6,
  status_formatter = nil,
  current_line_blame = false,
  diff_opts = { internal = true },
}
