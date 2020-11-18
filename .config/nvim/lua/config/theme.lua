local base16 = require"theme.base16"
local theme_names = base16.theme_names()
local M = {}

M.base16_position = 1

function M.cycle_theme()
  M.base16_position = (M.base16_position % #theme_names) + 1
  local theme = theme_names[M.base16_position]
  base16(base16.themes[theme], true)
  print(theme)
end

-- function M.
return M
