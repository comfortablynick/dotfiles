-- Define plugins with packer.nvim
-- local directory = string.format(
--   '%s/site/pack/packer/opt/',
--   vim.fn.stdpath('data')
-- )
vim.cmd[[packadd packer.nvim]]
local packer_exists = pcall(require, "packer")
local pack_dir = "~/vim-test/pack"
local packer_dir = pack_dir .. "/test/opt/packer.nvim"

if not packer_exists then
  if vim.fn.input("Download Packer? (y for yes) ") ~= "y" then return end

  vim.fn.mkdir(packer_dir, "p")

  local out = vim.fn.system(
                "git clone https://github.com/wbthomason/packer.nvim " ..
                  packer_dir)
  print(out)
  vim.cmd[[packadd packer.nvim]]
end

local packer = nil
local function init()
  local options = {package_root = pack_dir, plugin_package = "test"}
  if packer == nil then
    packer = require"packer"
    packer.init(options)
  end

  local use = packer.use
  packer.reset()

  -- Plugins {{{1
  -- General {{{2
  -- Packer can manage itself as an optional plugin
  use{"wbthomason/packer.nvim", opt = true}
  use{"NLKNguyen/papercolor-theme", opt = true}

  -- Runners/Linters/Formatters {{{2
  use{"psf/black", branch = "stable", opt = true}
  use{"skywind3000/asyncrun.vim", opt = true}
  use{
    "skywind3000/asynctasks.vim",
    opt = true,
    run = "ln -sf $(pwd)/bin/asynctask ~/.local/bin",
  }
end

-- Packer config {{{1
-- Plugins object {{{2
local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end,
})

-- config = {
--   display = {
--     _open_fn = function(name)
--       -- Can only use plenary when we have our plugins.
--       --  We can only get plenary when we don't have our plugins ;)
--       local ok, float_win = pcall(function()
--         return require("plenary.window.float").percentage_range_window(0.8,
--                                                                        0.8)
--       end)

--       if not ok then
--         vim.cmd[[65vnew  [packer] ]]

--         return vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf()
--       end

--       local bufnr = float_win.buf
--       local win = float_win.win

--       vim.api.nvim_buf_set_name(bufnr, name)
--       vim.api.nvim_win_set_option(win, "winblend", 10)

--       return win, bufnr
--     end,
--   },
-- }

return plugins
-- vim:fdl=1:
