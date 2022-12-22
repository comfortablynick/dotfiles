-- Nvim helpers, available globally
local api = vim.api
local npcall = vim.F.npcall
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

function M.relative_name(path)
  -- Return path relative to config
  -- E.g. ~/.config/nvim/lua/file.lua -> 'lua_file'
  local fp = vim.fn.expand(path or "%")
  return vim.fn.fnamemodify(fp, ":p:~:r"):gsub(".*config/nvim/", ""):gsub("%W", "_")
end

function M.module_name(path)
  -- Return module name of path or current file
  local fp = vim.fn.expand(path or "%")
  return vim.fn.fnamemodify(fp, ":p:~:r"):gsub(".*config/nvim/lua/", ""):gsub("%W", ".")
end

function M.source_current_buffer()
  -- luacheck: ignore loadstring
  loadstring(table.concat(api.nvim_buf_get_lines(0, 0, -1, true), "\n"))()
end

function M.unload(prefix)
  local found = vim.tbl_map(function(s)
    if s:find("^" .. prefix .. "[%./]?%w*$") then
      return s
    else
      return nil
    end
  end, vim.tbl_keys(package.loaded))
  for _, v in pairs(found) do
    package.loaded[v] = nil
  end
  return found
  -- local prefix_with_dot = prefix .. "."
  -- for k in pairs(package.loaded) do
  --   -- if k == prefix or k:sub(1, #prefix_with_dot) == prefix_with_dot then
  --   --   package.loaded[k] = nil
  --   -- end
  -- end
end

function M.reload()
  -- Remove module from `package.loaded` and source buffer to hot reload
  local bufname = api.nvim_buf_get_name(0)
  package.loaded[M.module_name(bufname)] = nil
  M.source_current_buffer()
  vim.notify(bufname .. " reloaded")
end

function M.warn(text) -- :: echo warning message
  vim.validate { text = { text, "string" } }
  api.nvim_echo({ { text, "WarningMsg" } }, false, {})
end

function M.unlet(var_name, var_scope) -- :: unlet variable even if it doesn't exist (equivalent to `unlet! g:var`)
  pcall(function()
    vim[var_scope or "g"][var_name] = nil
  end)
end

function M.packrequire(packname, modname) -- :: load pack + lua module and return module or nil
  vim.validate { packname = { packname, "string" } }
  -- Skip any vim rtp stuff if lua module exists
  local pack = package.loaded[modname or packname]
  if pack ~= nil then
    return pack
  end
  vim.cmd.packadd{packname, mods = { emsg_silent = true }}
  -- No need to check; just return nil if pcall fails
  return npcall(require, modname or packname)
end

function M.get_hl(name) -- :: return highlight def with hex values
  local ok, hl = pcall(api.nvim_get_hl_by_name, name, true)
  if not ok then
    return nil
  end
  for _, key in ipairs { "foreground", "background", "special" } do
    if hl[key] then
      hl[key] = string.format("#%06x", hl[key])
    end
  end
  return hl
end

function M.has(...) -- :: return bool from vim.fn.has()
  return vim.fn.has(...) == 1
end

function M.executable(...) -- :: return bool from vim.fn.executable()
  return vim.fn.executable(...) == 1
end

setmetatable(M, { -- :: Lazy load vim.api.nvim_{method} into nvim.{method} for easier cmdline work
  __index = function(_, k)
    return api["nvim_" .. k]
  end,
})

_G.nvim = M
