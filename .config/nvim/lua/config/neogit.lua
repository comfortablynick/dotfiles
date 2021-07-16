local neogit = nvim.packrequire "neogit"

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
    diffview = false,
  },
  -- override/add mappings
  -- mappings = {
  --   -- modify status buffer mappings
  --   status = {
  --     -- Adds a mapping with "B" as key that does the "BranchPopup" command
  --     ["B"] = "BranchPopup",
  --     -- Removes the default mapping of "s"
  --     ["s"] = "",
  --   },
  -- },
}

return neogit
