local devicons = require "nvim-web-devicons"

if not devicons then
  return nil
end

return devicons.setup {
  -- your personnal icons can go here (to override)
  -- DevIcon will be appended to `name`
  override = {
    zsh = { icon = "", color = "#428850", name = "Zsh" },
    todo = { icon = "🗹", color = "#519aba", name = "Todo_txt" },
  },
}
