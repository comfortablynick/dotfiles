local wk = require "which-key"

wk.setup {
  window = { border = "double" },
}

wk.register({
  b = "Build file",
  c = "Commentary",
  e = "Fuzzy edit",
  f = {
    name = "+format",
    f = "Use fmtprg",
    i = "Use indentexpr",
  },
  g = {
    name = "+git",
    p = "Git push",
    g = "Diff mode: diffget 1",
    h = "Diff mode: diffget 2",
    l = "Diff mode: diffget 3",
  },
  h = "Command history",
  l = "Hop to line",
  n = "Toggle explorer",
  q = "Delete buffer",
  r = "Run file",
  s = "Hop to word",
  t = "Tags",
  u = "Update + delete buffer",
  v = "Fuzzy vsplit",
  w = "Update + wipeout buffer",
  x = "Close open terminal",
  [","] = { name = "+misc", c = "Last command", v = "Vista toggle" },
}, {
  prefix = "<leader>",
})

wk.register({
  a = "Lsp Code action",
  D = "Lsp preview definition",
  d = "Lsp diagnostics",
  s = "Show git hunk under cursor",
}, { prefix = "g" })
