local installed, wk = pcall(require, "which-key")

if not installed then
  return
end

wk.setup {
  window = { border = "double" },
  operators = { gc = "Comments" },
  show_help = false,
  -- Not sure if this is needed
  triggers_blacklist = { i = { "k", "j" } },
}

wk.register({
  f = {
    name = "format",
  },
  g = {
    name = "git",
    p = "Git push",
    g = "Diff mode: diffget 1",
    h = "Diff mode: diffget 2",
    l = "Diff mode: diffget 3",
  },
  n = "Toggle explorer",
  [","] = { name = "+misc" },
}, {
  prefix = "<leader>",
})

wk.register({
  a = "Lsp Code action",
  D = "Lsp preview definition",
  d = "Lsp diagnostics",
  s = "Show git hunk under cursor",
}, {
  prefix = "g",
})
