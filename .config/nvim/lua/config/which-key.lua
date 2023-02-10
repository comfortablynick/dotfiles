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
  c = { name = "comment" },
  f = {
    name = "format",
  },
  g = {
    name = "git",
  },
  [","] = { name = "misc" },
}, {
  prefix = "<leader>",
})
