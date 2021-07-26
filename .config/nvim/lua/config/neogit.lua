local neogit = require "neogit"
vim.cmd [[packadd diffview.nvim]]

neogit.setup {
  disable_signs = false,
  disable_context_highlighting = false,
  disable_commit_confirmation = true,
  -- customize displayed signs
  signs = {
    -- { CLOSED, OPENED }
    section = { "ᐅ", "ᐁ" },
    item = { "›", "ˇ" },
    hunk = { "", "" },
  },
  integrations = {
    -- Requires `sindrets/diffview.nvim` installed for full diff
    diffview = true,
  },
  -- override/add mappings
  mappings = {
    -- modify status buffer mappings
    status = {
      ["<Space>"] = "Toggle",
    },
  },
}
