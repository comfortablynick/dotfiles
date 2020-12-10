local gitsigns = vim.F.npcall(require, "gitsigns")
if not gitsigns then return end

gitsigns.setup{
  signs = {
    add = {hl = "DiffAdd", text = "│"},
    change = {hl = "DiffChange", text = "│"},
    delete = {hl = "DiffDelete", text = "_"},
    topdelete = {hl = "DiffDelete", text = "‾"},
    changedelete = {hl = "DiffChange", text = "~"},
  },
  keymaps = {
    -- Default keymap options
    noremap = true,
    buffer = true,

    ["n ]c"] = {
      expr = true,
      [[&diff ? ']c' : "<Cmd>lua require'gitsigns'.next_hunk()<CR>"]],
    },
    ["n [c"] = {
      expr = true,
      [[&diff ? '[c' : "<Cmd>lua require'gitsigns'.prev_hunk()<CR>"]],
    },

    ["n ghs"] = "<Cmd>lua require'gitsigns'.stage_hunk()<CR>",
    ["n ghu"] = "<Cmd>lua require'gitsigns'.undo_stage_hunk()<CR>",
    ["n ghr"] = "<Cmd>lua require'gitsigns'.reset_hunk()<CR>",
    ["n gs"] = "<Cmd>lua require'gitsigns'.preview_hunk()<CR>",
  },
  watch_index = {interval = 1000},
  sign_priority = 6,
  status_formatter = nil,
}
