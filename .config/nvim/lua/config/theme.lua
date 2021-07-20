local base16 = require "theme.base16"
local theme_names = base16.theme_names()
local M = {}

M.base16_position = 1
M.base16_theme = nil
table.sort(theme_names)

function M.cycle_theme()
  M.base16_position = (M.base16_position % #theme_names) + 1
  local theme = theme_names[M.base16_position]
  base16(base16.themes[theme], true)
  print(theme)
end

function M.set_theme(theme_name)
  base16(base16.themes[theme_name], true)
  M.base16_theme = theme_name
end

function M.themes_after(name)
  local prev_themes = {}
  local next_themes = {}
  for i = 1, #theme_names do
    if theme_names[i] >= (name or "") then
      table.insert(next_themes, theme_names[i])
    else
      table.insert(prev_themes, theme_names[i])
    end
  end
  return vim.list_extend(next_themes, prev_themes)
end

return M
