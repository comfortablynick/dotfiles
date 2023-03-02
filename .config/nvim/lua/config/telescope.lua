local installed, telescope = pcall(require, "telescope")

if not installed then
  return
end

telescope.setup {
  defaults = {
    winblend = 0,
    prompt_prefix = "❯ ",
    selection_caret = "❯ ",
  },
}

-- Extensions
pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "heading")
pcall(telescope.load_extension, "scriptnames")
