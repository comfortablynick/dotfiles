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
