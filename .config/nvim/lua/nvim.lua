-- Additions to the "api" (common nvim helpers)
-- Also api methods can be called from here without leading `nvim_`
-- Ex: vim.api.nvim_buf_get_lines() == nvim.buf_get_lines()
local api = vim.api
local npcall = vim.F.npcall
local M = {}

-- Adapted from github.com/norcalli/nvim_utils
function M.create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    vim.cmd("augroup " .. group_name)
    vim.cmd "autocmd!"
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten { "autocmd", def }, " ")
      vim.cmd(command)
    end
    vim.cmd "augroup END"
  end
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
  end, vim.tbl_keys(
    package.loaded
  ))
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
end

function M.smart_tab()
  if vim.fn.pumvisible() ~= 0 then
    api.nvim_eval [[feedkeys("\<c-n>", "n")]]
    return
  end
  local col = vim.fn.col "." - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match "%s" then
    api.nvim_eval [[feedkeys("\<tab>", "n")]]
    return
  end
  -- npcall(fallback_cb)
  -- Trigger completion otherwise?
  -- source.triggerCompletion(true, manager)
  api.nvim_eval [[feedkeys("\<C-Space>")]]
end

function M.smart_s_tab()
  if vim.fn.pumvisible() ~= 0 then
    api.nvim_eval [[feedkeys("\<c-p>", "n")]]
    return
  end
  api.nvim_eval [[feedkeys("\<s-tab>", "n")]]
end

-- warn :: echo warning message
function M.warn(text)
  vim.validate { text = { text, "string" } }
  api.nvim_echo({ { text, "WarningMsg" } }, false, {})
end

-- unlet :: unlet variable even if it doesn't exist (equivalent to `unlet! g:var`)
function M.unlet(var_name, var_scope)
  pcall(function()
    vim[var_scope or "g"][var_name] = nil
  end)
end

-- packrequire :: load pack + lua module and return module or nil
function M.packrequire(packname, modname)
  vim.validate { packname = { packname, "string" } }
  -- Skip any vim rtp stuff if lua module exists
  local pack = package.loaded[modname or packname]
  if pack ~= nil then
    return pack
  end
  vim.cmd("silent! packadd " .. packname)
  -- No need to check; just return nil if pcall fails
  return npcall(require, modname or packname)
end

-- get_hl :: return highlight def with hex values
function M.get_hl(name)
  local ok, hl = pcall(api.nvim_get_hl_by_name, name, true)
  if not ok then
    return
  end
  for _, key in pairs { "foreground", "background", "special" } do
    if hl[key] then
      hl[key] = string.format("#%06x", hl[key])
    end
  end
  return hl
end

-- Lazy load vim.api.nvim_{method} into nvim.{method} for easier cmdline work
setmetatable(M, {
  __index = function(_, k)
    return api["nvim_" .. k]
  end,
})

_G.nvim = M
