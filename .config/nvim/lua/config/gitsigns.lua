local gitsigns = nvim.packrequire("gitsigns.nvim", "gitsigns")
local api = vim.api

local init = function()
  if not gitsigns then return end
  gitsigns.setup{
    signs = {
      add = {hl = "DiffAdd", text = "│"},
      change = {hl = "DiffChange", text = "│"},
      delete = {hl = "DiffDelete", text = "_"},
      topdelete = {hl = "DiffDelete", text = "‾"},
      changedelete = {hl = "DiffChange", text = "~"},
    },
    keymaps = {},
    on_attach = function(bufnr)
      -- if vim.api.nvim_buf_get_name(bufnr):match(<PATTERN>) then
      --   -- Don't attach to specific buffers whose name matches a pattern
      --   return false
      api.nvim_buf_set_keymap(bufnr, "n", "]c",
                              [[&diff ? ']c' : "<Cmd>lua require'gitsigns'.next_hunk()<CR>"]],
                              {noremap = true, expr = true})
      api.nvim_buf_set_keymap(bufnr, "n", "[c",
                              [[&diff ? '[c' : "<Cmd>lua require'gitsigns'.prev_hunk()<CR>"]],
                              {noremap = true, expr = true})
      api.nvim_buf_set_keymap(bufnr, "n", "ghs",
                              "<Cmd>lua require'gitsigns'.stage_hunk()<CR>",
                              {noremap = true})
      api.nvim_buf_set_keymap(bufnr, "n", "ghu",
                              "<Cmd>lua require'gitsigns'.undo_stage_hunk()<CR>",
                              {noremap = true})
      api.nvim_buf_set_keymap(bufnr, "n", "ghr",
                              "<Cmd>lua require'gitsigns'.reset_hunk()<CR>",
                              {noremap = true})
      api.nvim_buf_set_keymap(bufnr, "n", "gs",
                              "<Cmd>lua require'gitsigns'.preview_hunk()<CR>",
                              {noremap = true})
      api.nvim_buf_set_keymap(bufnr, "o", "ih",
                              "<Cmd>lua require'gitsigns'.select_hunk()<CR>",
                              {noremap = true})
      api.nvim_buf_set_keymap(bufnr, "x", "ih",
                              "<Cmd>lua require'gitsigns'.select_hunk()<CR>",
                              {noremap = true})
    end,
    numhl = false,
    watch_index = {interval = 1000},
    sign_priority = 6,
    status_formatter = nil,
  }
end
return {init = init}
