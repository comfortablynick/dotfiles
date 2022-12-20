-- Utility functions, not necessarily integral to vim
local uv = vim.loop
local ffi = vim.F.npcall(require, "ffi")
local api = vim.api
local M = {}

function M.require(mod)
  local ok, ret = M.try(require, mod)
  return ok and ret
end

function M.try(fn, ...)
  local args = { ... }

  return xpcall(function()
    return fn(unpack(args))
  end, function(err)
    local lines = {}
    table.insert(lines, err)
    table.insert(lines, debug.traceback("", 3))

    M.error(table.concat(lines, "\n"))
    return err
  end)
end

-- Root finder utilities originally from nvim-lspconfig
function M.search_ancestors(startpath, func)
  vim.validate { func = { func, "f" } }
  if func(startpath) then
    return startpath
  end
  local guard = 100
  for path in M.path.iterate_parents(startpath) do
    -- Prevent infinite recursion if our algorithm breaks
    guard = guard - 1
    if guard == 0 then
      return
    end

    if func(path) then
      return path
    end
  end
end

function M.root_pattern(...)
  local patterns = vim.tbl_flatten { ... }
  local function matcher(path)
    for _, pattern in ipairs(patterns) do
      -- TODO: use luv funcs instead of vim?
      if M.path.exists(vim.fn.glob(M.path.join(path, pattern))) then
        return path
      end
    end
  end
  return function(startpath)
    return M.search_ancestors(startpath, matcher)
  end
end

function M.find_git_ancestor(startpath)
  return M.search_ancestors(startpath, function(path)
    if M.path.is_dir(M.path.join(path, ".git")) then
      return path
    end
  end)
end

function M.find_node_modules_ancestor(startpath)
  return M.search_ancestors(startpath, function(path)
    if M.path.is_dir(M.path.join(path, "node_modules")) then
      return path
    end
  end)
end

function M.find_package_json_ancestor(startpath)
  return M.search_ancestors(startpath, function(path)
    if M.path.is_file(M.path.join(path, "package.json")) then
      return path
    end
  end)
end

function M.get_current_root()
  local bufnr = api.nvim_get_current_buf()
  return M.root_pattern(unpack(vim.g.root_patterns))(api.nvim_buf_get_name(bufnr))
end

function M.humanize_bytes(size)
  local div = 1024
  if size < div then
    return tostring(size)
  end
  for _, unit in ipairs { "", "k", "M", "G", "T", "P", "E", "Z" } do
    if size < div then
      return string.format("%.1f%s", size, unit)
    end
    size = size / div
  end
end

function M.bench(iters, cb)
  vim.validate { cb = { cb, "f" } }
  local start_time = uv.hrtime()
  iters = iters or 100
  for _ = 1, iters do
    cb()
  end
  local end_time = uv.hrtime()
  local elapsed_time = (end_time - start_time) / 1e6
  print(("time elapsed for %d runs: %d ms"):format(iters, elapsed_time))
end

-- Some path utilities
-- From: https://github.com/neovim/nvim-lsp/blob/master/lua/nvim_lsp/util.lua
M.path = (function()
  local is_windows = uv.os_uname().sysname == "Windows"

  local path_sep = is_windows and "\\" or "/"

  local function exists(filename)
    local stat = uv.fs_stat(filename)
    return stat and stat.type or false
  end

  local function basename(str)
    local pat = "(.*" .. path_sep .. ")(.*)"
    return str:gsub(pat, "%2")
  end

  local function is_dir(filename)
    return exists(filename) == "directory"
  end

  local function is_file(filename)
    return exists(filename) == "file"
  end

  -- Create folder with non existing parents
  -- TODO: use traverse_parents to implement through luv?
  local mkdir_p = function(path)
    return os.execute((is_windows and "mkdir " .. path or "mkdir -p " .. path))
  end

  local is_fs_root
  if is_windows then
    is_fs_root = function(path)
      return path:match "^%a:$"
    end
  else
    is_fs_root = function(path)
      return path == "/"
    end
  end

  local function is_absolute(filename)
    if is_windows then
      return filename:match "^%a:" or filename:match "^\\\\"
    else
      return filename:match "^/"
    end
  end

  local dirname
  do
    local strip_dir_pat = path_sep .. "([^" .. path_sep .. "]+)$"
    local strip_sep_pat = path_sep .. "$"
    dirname = function(path)
      if not path then
        return
      end
      local result = path:gsub(strip_sep_pat, ""):gsub(strip_dir_pat, "")
      if #result == 0 then
        return "/"
      end
      return result
    end
  end

  local function path_join(...)
    local result = table.concat(vim.tbl_flatten { ... }, path_sep):gsub(path_sep .. "+", path_sep)
    return result
  end

  -- Traverse the path calling cb along the way.
  local function traverse_parents(path, cb)
    path = uv.fs_realpath(path)
    local dir = path
    -- Just in case our algo is buggy, don't infinite loop.
    for _ = 1, 100 do
      dir = dirname(dir)
      if not dir then
        return
      end
      -- If we can't ascend further, then stop looking.
      if cb(dir, path) then
        return dir, path
      end
      if is_fs_root(dir) then
        break
      end
    end
  end

  -- Iterate the path until we find the rootdir.
  local function iterate_parents(path)
    local function it(s, v) -- luacheck: ignore unused s
      if v and not is_fs_root(v) then
        v = dirname(v)
      else
        return
      end
      if v and uv.fs_realpath(v) then
        return v, path
      else
        return
      end
    end
    return it, path, path
  end

  local function is_descendant(root, path)
    if not path then
      return false
    end

    local function cb(dir, _)
      return dir == root
    end

    local dir, _ = traverse_parents(path, cb)

    return dir == root
  end

  local function shorten(path)
    path = path:gsub(uv.os_homedir(), "~")

    if ffi then
      ffi.cdef [[
void shorten_dir(const char *str)
]]

      return (function()
        local c_str = ffi.new("const char[?]", #path + 1, path)
        ffi.C.shorten_dir(c_str)
        return ffi.string(c_str)
      end)()
    else
      return path
    end
  end

  return {
    is_dir = is_dir,
    is_file = is_file,
    is_absolute = is_absolute,
    exists = exists,
    basename = basename,
    sep = path_sep,
    dirname = dirname,
    mkdir_p = mkdir_p,
    join = path_join,
    traverse_parents = traverse_parents,
    iterate_parents = iterate_parents,
    is_descendant = is_descendant,
    shorten = shorten,
  }
end)()

local function _comp(a, b)
  if type(a) ~= type(b) then
    return false
  end
  if type(a) == "table" then
    for k, v in pairs(a) do
      if not b[k] then
        return false
      end
      if not _comp(v, b[k]) then
        return false
      end
    end
  else
    if a ~= b then
      return false
    end
  end
  return true
end

--- Table Key-Value Intersection.
---
--- @return Returns a table that is the intersection of the provided tables. This is an
---   intersection of key/value pairs. See table.n_intersection() for an intersection of values.
---   Note that the resulting table may not be reliably traversable with ipairs() due to
---   the fact that it preserves keys. If there is a gap in numerical indices, ipairs() will
---   cease traversal.
function M.tbl_intersection(...)
  sets = { ... }
  if #sets < 2 then
    return false
  end

  local function intersect(set1, set2)
    local result = {}
    for key, val in pairs(set1) do
      if set2[key] then
        if _comp(val, set2[key]) then
          result[key] = val
        end
      end
    end
    return result
  end

  local intersection = intersect(sets[1], sets[2])

  for i, _ in ipairs(sets) do
    if i > 2 then
      intersection = intersect(intersection, sets[i])
    end
  end

  return intersection
end

--- List Table Intersection.
---
--- @return Returns a numerically indexed table that is the intersection of the provided tables.
---   This is an intersection of unique values. The order and keys of the input tables are
---   not preserved.
function M.list_intersection(...)
  sets = { ... }
  if #sets < 2 then
    return false
  end

  local function intersect(set1, set2)
    local intersection_keys = {}
    local result = {}
    for _, val1 in pairs(set1) do
      for _, val2 in pairs(set2) do
        if _comp(val1, val2) and not intersection_keys[val1] then
          table.insert(result, val1)
          intersection_keys[val1] = true
        end
      end
    end
    return result
  end

  local intersection = intersect(sets[1], sets[2])

  for i, _ in ipairs(sets) do
    if i > 2 then
      intersection = intersect(intersection, sets[i])
    end
  end

  return intersection
end

return M
