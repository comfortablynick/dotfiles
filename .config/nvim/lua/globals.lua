-- Global functions
-- p :: Debug print helper
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

-- String indexing
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
    local t = {}
    for k, v in ipairs(i) do t[k] = string.sub(str, v, v) end
    return table.concat(t)
  end
end
