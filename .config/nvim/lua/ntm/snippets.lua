local snippets_exists, snippets = pcall(require, "snippets")

if not snippets_exists then return end

local U = require"snippets.utils"
local indent = U.match_indentation
local comment = U.force_comment

snippets.snippets = {
  lua = {
    req = [[local ${2:${1|S.v:match"([^.()]+)[()]*$"}} = require '$1']],
    func = [[function${1|vim.trim(S.v):gsub("^%S"," %0")}(${2|vim.trim(S.v)})$0 end]],
    ["local"] = [[local ${2:${1|S.v:match"([^.()]+)[()]*$"}} = ${1}]],
    -- Match the indentation of the current line for newlines.
    ["for"] = indent[[
for ${1:i}, ${2:v} in ipairs(${3:t}) do
  $0
end]],
    use = [[use"${1}"]],
    useopt = [[use{"${1}", opt = true}]],
  },
  vim = {
    scriptguard = [[let s:guard = 'g:loaded_${=vim.fn.expand("%:p:~:r"):gsub(".*config/nvim/", ""):gsub("%W", "_")}' | if exists(s:guard) | finish | endif
let {s:guard} = 1]],
    func = indent[[function! ${1|vim.trim(S.v)}(${2}) abort
    $0
endfunction]],
  },
  toml = {
    abbr = indent[=[[[abbr]]
key = '${1}'
val = '${2}'
cat = '${3}'
desc = '${4}'
shell = ['bash', 'zsh', 'fish']
]=],
    env = indent[=[[[env]]
key = '${1}'
val = '${2}'
cat = '${3}'
desc = '${4}'
shell = ['bash', 'zsh', 'fish']
]=],
  },
  _global = {
    -- If you aren't inside of a comment, make the line a comment.
    copyright = comment[[© Nicholas Murphy ${=os.date("%Y")}]],
    date = [[${=os.date("%F")}]],
  },
}
snippets.use_suggested_mappings(true)
