-- Fluid keymapping interface
-- From: https://github.com/Iron-E/nvim-cartographer
local api = vim.api

-- Optionally set which-key labels
local wk_installed, wk = pcall(require, "which-key")

local Callbacks = {}

--- Register a callback to be
--- @param cb function the callback
--- @return number id the handle of the callback
function Callbacks.new(cb)
  Callbacks[#Callbacks + 1] = cb
  return #Callbacks
end

--- Return an empty table with all necessary fields initialized.
--- @return table
local function new()
  return { _modes = {}, callbacks = Callbacks }
end

--- Make a deep copy of opts table
--- @param tbl table the table to copy
local function copy(tbl)
  local new_tbl = new()

  for key, val in pairs(tbl) do
    if key ~= "_modes" then
      new_tbl[key] = val
    else
      for i, mode in ipairs(tbl._modes) do
        new_tbl._modes[i] = mode
      end
    end
  end

  return new_tbl
end

--- The fluent interface `:map`s. Used as a metatable.
local MetaMapper
MetaMapper = {
  --- Set `key` to `true` if it was not already present
  --- @param self table the collection of settings
  --- @param key string the setting to set to `true`
  --- @returns table self so that this function can be called again
  __index = function(self, key)
    self = copy(self)

    if #key < 2 then -- set the mode
      self._modes[#self._modes + 1] = key
    elseif #key > 5 and key:sub(1, 1) == "b" then -- PERF: 'buffer' is the only 6-letter option starting with 'b'
      self.buffer = #key > 6 and tonumber(key:sub(7)) or 0 -- NOTE: 0 is the current buffer
    else -- the fluent interface
      self[key] = true
    end

    return setmetatable(self, MetaMapper)
  end,

  --- Set a `lhs` combination of keys to some `rhs`
  --- @param self table the collection of settings and the mode
  --- @param lhs string the left-hand side |key-notation| which will execute `rhs` after running this function
  --- @param rhs string if `nil`, |:unmap| lhs. Otherwise, see |:map|.
  __newindex = function(self, lhs, rhs)
    local buffer = rawget(self, "buffer")
    local modes = rawget(self, "_modes")
    local eval_str = "luaeval('vim.map.callbacks[%d]')()"
    local cmd_str = "<Cmd>lua vim.map.callbacks[%d]()<CR>"
    modes = #modes > 0 and modes or { "" }

    if rhs then
      local opts = {
        expr = rawget(self, "expr"),
        noremap = rawget(self, "nore"),
        nowait = rawget(self, "nowait"),
        script = rawget(self, "script"),
        silent = rawget(self, "silent"),
        unique = rawget(self, "unique"),
      }

      if type(rhs) == "table" then
        rhs, label = unpack(rhs)

        if wk_installed then
          for _, mode in ipairs(modes) do
            wk.register({ [lhs] = label }, { mode = mode })
          end
        end
      end

      if type(rhs) == "function" then
        local id = Callbacks.new(rhs)
        rhs = opts.expr and eval_str:format(id) or cmd_str:format(id)
        opts.noremap = true
      end

      if buffer then
        for _, mode in ipairs(modes) do
          api.nvim_buf_set_keymap(buffer, mode, lhs, rhs, opts)
        end
      else
        for _, mode in ipairs(modes) do
          api.nvim_set_keymap(mode, lhs, rhs, opts)
        end
      end
    else
      if buffer then
        for _, mode in ipairs(modes) do
          api.nvim_buf_del_keymap(buffer, mode, lhs)
        end
      else
        for _, mode in ipairs(modes) do
          api.nvim_del_keymap(mode, lhs)
        end
      end
    end
  end,
}

vim.map = setmetatable(new(), {
  -- NOTE: For backwards compatability. `__index` is preferred.
  __call = function(_)
    return setmetatable(new(), MetaMapper)
  end,
  __index = function(_, key)
    return setmetatable(new(), MetaMapper)[key]
  end,
  __newindex = MetaMapper.__newindex,
})
