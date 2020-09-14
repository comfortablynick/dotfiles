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

  -- Editing behavior {{{2
  use{"tpope/vim-commentary", opt = true}
  use{"tpope/vim-unimpaired", opt = true}
  use{"machakann/vim-sandwich", opt = true}
  use{"justinmk/vim-sneak", opt = true}
  use{"rhysd/clever-f.vim", opt = true}
  use{"wellle/targets.vim", opt = true}
  use{"bfredl/nvim-miniyank", opt = true}
  use{"antoinemadec/FixCursorHold.nvim", opt = true}

  -- Explorer/finder utils {{{2
  use{"majutsushi/tagbar", cmd = "TagbarToggle"}
  use{"mbbill/undotree", cmd = "UndotreeToggle"}
  use{"preservim/nerdtree", cmd = "NERDTreeToggle"}
  use{"Shougo/defx.nvim", cmd = "Defx"}
  use{"tpope/vim-projectionist", opt = true}
  use{"kyazdani42/nvim-tree.lua", cmd = "LuaTreeToggle"}
  use{"justinmk/vim-dirvish", opt = true}
  use{"srstevenson/vim-picker", opt = true}
  use{"voldikss/vim-floaterm", opt = true}
  use{
    "junegunn/fzf.vim",
    cmd = {
      "Files",
      "Rg",
      "History",
      "Commands",
      "Help",
      "Lines",
      "Buffers",
      "Commits",
      "Tags",
      "BTags",
      "Map",
      "Maps",
      "RG",
    },
  }

  -- Completion {{{2
  use{"neovim/nvim-lsp", opt = true}
  use{
    "nvim-lua/completion-nvim",
    opt = true,
    after = "nvim-lsp",
    requires = {{"norcalli/snippets.nvim", opt = true, after = "nvim-lsp"}},
  }
  use{"steelsojka/completion-buffers", opt = true, after = "nvim-lsp"}

  -- Vim Development {{{2
  use{"tweekmonster/startuptime.vim", cmd = "StartupTime"}
  use{"tpope/vim-scriptease", opt = true}
  use{"mhinz/vim-lookup", opt = true}
  use{"bfredl/nvim-luadev", opt = true}

  -- Tmux {{{2
  use{"christoomey/vim-tmux-navigator", opt = true}
  use{"RyanMillerC/better-vim-tmux-resizer", opt = true}
  use{"comfortablynick/vim-tmux-runner", opt = true}

  -- Runners/Linters/Formatters {{{2
  use{"dense-analysis/ale", opt = true}
  use{
    "sbdchd/neoformat",
    cmd = "Neoformat",
    setup = [[vim.api.nvim_set_keymap("", "<F3>", ":Neoformat<CR>", {silent = true})]],
    config = [[
    vim.g.neoformat_test_var = 1
    vim.g.neoformat_test2 = 1
    ]],
  }
  use{"psf/black", branch = "stable", ft = "python"}
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
