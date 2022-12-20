local ok, fzf = pcall(require, "fzf-lua")
if not ok then
  return
end

fzf.setup {
  winopts = {
    height = 0.75,
    width = 0.65,
  },
}
