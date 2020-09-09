local snippets = require"snippets"
local U = require"snippets.utils"

snippets.snippets = {
  lua = {
    req = [[local ${2:${1|S.v:match"([^.()]+)[()]*$"}} = require '$1']],
    func = [[function${1|vim.trim(S.v):gsub("^%S"," %0")}(${2|vim.trim(S.v)})$0 end]],
    ["local"] = [[local ${2:${1|S.v:match"([^.()]+)[()]*$"}} = ${1}]],
    -- Match the indentation of the current line for newlines.
    ["for"] = U.match_indentation[[
for ${1:i}, ${2:v} in ipairs(${3:t}) do
  $0
end]],
  },
  vim = {
    scriptguard = [[let s:guard = 'g:loaded_${=vim.fn.expand("%:p:~:r"):gsub(".*config/nvim/", ""):gsub("%W", "_")}' | if exists(s:guard) | finish | endif
let {s:guard} = 1]],
  },
  _global = {
    -- If you aren't inside of a comment, make the line a comment.
    copyright = U.force_comment[[© Nicholas Murphy ${=os.date("%Y")}]],
    date = [[${=os.date("%F")}]],
  },
}
snippets.use_suggested_mappings(true)
