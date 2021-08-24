local gitsigns = require "gitsigns"

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
  keymaps = {
    noremap = true,
    buffer = true,

    ["n ]c"] = { expr = true, "&diff ? ']c' : '<Cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'" },
    ["n [c"] = { expr = true, "&diff ? '[c' : '<Cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'" },

    ["n ghs"] = '<Cmd>lua require"gitsigns".stage_hunk()<CR>',
    ["v ghs"] = '<Cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ["n ghu"] = '<Cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    ["n ghr"] = '<Cmd>lua require"gitsigns".reset_hunk()<CR>',
    ["v ghr"] = '<Cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ["n ghR"] = '<Cmd>lua require"gitsigns".reset_buffer()<CR>',
    ["n gs"] = '<Cmd>lua require"gitsigns".preview_hunk()<CR>',
    ["n ghb"] = '<Cmd>lua require"gitsigns".blame_line(true)<CR>',

    -- Text objects
    ["o ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    ["x ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
  },
  on_attach = function(bufnr)
    local exclude_fts = { "clap_input", "qf", "floaterm", "" }

    -- Don't load completion
    if vim.tbl_contains(exclude_fts, vim.bo[bufnr].filetype) then
      return false
    end
  end,
  watch_index = { interval = 1000 },
  sign_priority = 6,
  status_formatter = nil,
  current_line_blame = false,
  use_internal_diff = true,
}
