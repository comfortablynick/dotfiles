local installed, comment = pcall(require, "Comment")

if not installed then
  return
end

comment.setup {
  ---Add a space b/w comment and the line
  padding = true,
  ---Line which should be ignored while comment/uncomment
  ---Example: Use '^$' to ignore empty lines
  ---@type string Lua regex
  ignore = nil,
  ---Whether to create basic (operator-pending) and extra mappings for NORMAL/VISUAL mode
  mappings = {
    ---operator-pending mapping
    ---Includes `gcc`, `gcb`, `gc[count]{motion}` and `gb[count]{motion}`
    basic = true,
    ---extended mapping
    ---Includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
    extra = false,
  },
  ---LHS of line and block comment toggle mapping in NORMAL/VISUAL mode
  toggler = {
    line = "gcc",
    block = "gbc",
  },
  ---LHS of line and block comment operator-mode mapping in NORMAL/VISUAL mode
  opleader = {
    line = "gc",
    block = "gb",
  },
  ---Pre-hook, called before commenting the line
  ---@type function|nil
  pre_hook = nil,
  ---Post-hook, called after commenting is done
  ---@type function|nil
  post_hook = nil,
}
