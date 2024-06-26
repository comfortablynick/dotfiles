local installed, neogit = pcall(require, "neogit")

if not installed then
  return
end

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
