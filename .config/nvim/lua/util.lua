-- Utility functions, not necessarily integral to vim
local vim = vim
local uv = vim.loop
local ffi = require"ffi"
local M = {}

function M.humanize_bytes(size)
  local div = 1024
  if size < div then return tostring(size) end
  for _, unit in ipairs({"", "k", "M", "G", "T", "P", "E", "Z"}) do
    if size < div then return string.format("%.1f%s", size, unit) end
    size = size / div
  end
end

function M.epoch_ms()
  local s, ns = vim.loop.gettimeofday()
  return s * 1000 + math.floor(ns / 1000)
end

function M.epoch_ns()
  local s, ns = vim.loop.gettimeofday()
  return s * 1000000 + ns
end

function M.bench(iters, cb)
  assert(cb, "Must provide callback to benchmark")
  local start_time = M.epoch_ms()
  iters = iters or 100
  for _ = 1, iters do cb() end
  local end_time = M.epoch_ms()
  local elapsed_time = end_time - start_time
  p("time elapsed for %d runs: %d ms", iters, elapsed_time)
end

---
-- Error handling
---

-- Some path utilities
-- From: https://github.com/neovim/nvim-lsp/blob/master/lua/nvim_lsp/util.lua
M.path = (function()
  local function exists(filename)
    local stat = uv.fs_stat(filename)
    return stat and stat.type or false
  end

  local function basename(str)
    local name = string.gsub(str, "(.*/)(.*)", "%2")
    return name
  end

  local function is_dir(filename) return exists(filename) == "directory" end

  local function is_file(filename) return exists(filename) == "file" end

  local is_windows = uv.os_uname().version:match("Windows")

  local path_sep = is_windows and "\\" or "/"

  local is_fs_root
  if is_windows then
    is_fs_root = function(path) return path:match("^%a:$") end
  else
    is_fs_root = function(path) return path == "/" end
  end

  local function is_absolute(filename)
    if is_windows then
      return filename:match("^%a:") or filename:match("^\\\\")
    else
      return filename:match("^/")
    end
  end

  local dirname
  do
    local strip_dir_pat = path_sep .. "([^" .. path_sep .. "]+)$"
    local strip_sep_pat = path_sep .. "$"
    dirname = function(path)
      if not path then return end
      local result = path:gsub(strip_sep_pat, ""):gsub(strip_dir_pat, "")
      if #result == 0 then return "/" end
      return result
    end
  end

  local function path_join(...)
    local result = table.concat(vim.tbl_flatten{...}, path_sep):gsub(
                     path_sep .. "+", path_sep)
    return result
  end

  -- Traverse the path calling cb along the way.
  local function traverse_parents(path, cb)
    path = uv.fs_realpath(path)
    local dir = path
    -- Just in case our algo is buggy, don't infinite loop.
    for _ = 1, 100 do
      dir = dirname(dir)
      if not dir then return end
      -- If we can't ascend further, then stop looking.
      if cb(dir, path) then return dir, path end
      if is_fs_root(dir) then break end
    end
  end

  -- Iterate the path until we find the rootdir.
  local function iterate_parents(path)
    path = uv.fs_realpath(path)
    local function it(v)
      if not v then return end
      if is_fs_root(v) then return end
      return dirname(v), path
    end
    return it, path, path
  end

  local function is_descendant(root, path)
    if (not path) then return false; end

    local function cb(dir, _) return dir == root; end

    local dir, _ = traverse_parents(path, cb);

    return dir == root;
  end

  ffi.cdef[[
  typedef unsigned char char_u;
  char_u *shorten_dir(char_u *str);
  ]]

  local function shorten(path)
    path = path:gsub(uv.os_homedir(), '~')
    local c_str = ffi.new("char[?]", #path + 1)
    ffi.copy(c_str, path)
    return ffi.string(ffi.C.shorten_dir(c_str))
  end

  return {
    is_dir = is_dir,
    is_file = is_file,
    is_absolute = is_absolute,
    exists = exists,
    basename = basename,
    sep = path_sep,
    dirname = dirname,
    join = path_join,
    traverse_parents = traverse_parents,
    iterate_parents = iterate_parents,
    is_descendant = is_descendant,
    shorten = shorten,
  }
end)()

return M
