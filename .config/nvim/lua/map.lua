-- Fluid keymapping interface
-- From: https://github.com/Iron-E/nvim-cartographer
--
-- Adapted for new `vim.keymap` module in nvim 0.70
-- including the ability to add a description to the mapping

-- Optionally set which-key labels
local wk_installed, wk = pcall(require, "which-key")

--- Return an empty table with all necessary fields initialized.
--- @return table
local function new()
  return { _modes = {} }
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

--- A fluent interface to create more straightforward syntax for Lua |:map|ping and |:unmap|ping.
--- @class Cartographer
--- @field buffer number the buffer to apply the keymap to.
--- @field _modes table the modes to apply a keymap to.
local Cartographer = {}

--- Set `key` to `true` if it was not already present
--- @param key string the setting to set to `true`
--- @returns table self so that this function can be called again
function Cartographer:__index(key)
  self = copy(self)

  if #key < 2 then -- set the mode
    self._modes[#self._modes + 1] = key
  elseif #key > 5 and key:sub(1, 1) == "b" then -- PERF: 'buffer' is the only 6-letter option starting with 'b'
    self.buffer = #key > 6 and tonumber(key:sub(7)) or 0 -- NOTE: 0 is the current buffer
  else -- the fluent interface
    self[key] = true
  end

  return setmetatable(self, Cartographer)
end

--- Set a `lhs` combination of keys to some `rhs`
--- @param lhs string the left-hand side |key-notation| which will execute `rhs` after running this function
--- @param rhs string|nil if `nil`, |:unmap| lhs. Otherwise, see |:map|.
function Cartographer:__newindex(lhs, rhs)
  local modes = rawget(self, "_modes")
  local buffer = rawget(self, "buffer")
  modes = #modes > 0 and modes or { "" }

  if rhs then
    local opts = {
      expr = rawget(self, "expr"),
      remap = rawget(self, "re"),
      nowait = rawget(self, "nowait"),
      script = rawget(self, "script"),
      silent = rawget(self, "silent"),
      unique = rawget(self, "unique"),
      buffer = buffer,
    }

    if type(rhs) == "table" then
      rhs, label = unpack(rhs)
      opts.desc = label

      if wk_installed then
        for _, mode in ipairs(modes) do
          wk.register({ [lhs] = label }, { mode = mode })
        end
      end
    end

    vim.keymap.set(modes, lhs, rhs, opts)
  else
    vim.keymap.del(modes, lhs, { buffer = buffer })
  end
end

vim.map = setmetatable(new(), Cartographer)
