-- Global functions
-- p :: Debug print helper {{{1
-- If `val` is not a simple type, run it through inspect() first
-- Else treat as printf
function _G.p(val, ...)
  local wrapper = function(s, ...)
    if type(val) == ("string" or "number") then
      print(string.format(s, ...))
    else
      print(vim.inspect(s))
    end
  end
  -- Just print if there's an error (bad format str, etc.)
  if not pcall(wrapper, val, ...) then print(val, ...) end
end

-- Smart [S-]Tab {{{1
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- TODO: possibly include markdown tab logic
local check_back_space = function()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.smart_tab = function()
  if vim.fn.pumvisible() == 1 then
    return t"<C-n>"
    -- TODO: why doesn't this work?
    -- elseif vim.F.npcall(vim.fn["Ultisnips#CanJumpForwards"]) == 1 then
    --   return t"<Plug>(UltiForward)"
  elseif require"luasnip".expand_or_jumpable() then
    return t"<Plug>luasnip-expand-or-jump"
  elseif check_back_space() then
    return t"<Tab>"
  else
    return vim.fn["compe#complete"]()
  end
end

_G.smart_s_tab = function()
  if vim.fn.pumvisible() == 1 then
    return t"<C-p>"
  elseif require"luasnip".jumpable(-1) then
    return t"<Plug>luasnip-jump-prev"
  else
    return t"<S-Tab>"
  end
end

-- String indexing metamethods {{{1
-- Example:
-- a='abcdef'
-- return a[4]       --> d
-- return a(3,5)     --> cde
-- return a{1,-4,5}  --> ace
getmetatable("").__index = function(str, i)
  if type(i) == "number" then
    return string.sub(str, i, i)
  else
    return string[i]
  end
end

getmetatable("").__call = function(str, i, j)
  if type(i) ~= "table" then
    return string.sub(str, i, j)
  else
    local tbl = {}
    for k, v in ipairs(i) do tbl[k] = string.sub(str, v, v) end
    return table.concat(tbl)
  end
end
