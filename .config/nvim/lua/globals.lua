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

---A helper function to print a table's contents.
---@param tbl table @The table to print.
---@param depth number @The depth of sub-tables to traverse through and print.
---@param n number @Do NOT manually set this. This controls formatting through recursion.
function table.print(tbl, depth, n)
  n = n or 0;
  depth = depth or 5;

  if (depth == 0) then
      print(string.rep(' ', n).."...");
      return;
  end

  if (n == 0) then
      print(" ");
  end

  for key, value in pairs(tbl) do
      if (key and type(key) == "number" or type(key) == "string") then
          key = string.format("[\"%s\"]", key);

          if (type(value) == "table") then
              if (next(value)) then
                  print(string.rep(' ', n)..key.." = {");
                  table.print(value, depth - 1, n + 4);
                  print(string.rep(' ', n).."},");
              else
                  print(string.rep(' ', n)..key.." = {},");
              end
          else
              if (type(value) == "string") then
                  value = string.format("\"%s\"", value);
              else
                  value = tostring(value);
              end

              print(string.rep(' ', n)..key.." = "..value..",");
          end
      end
  end

  if (n == 0) then
      print(" ");
  end
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
