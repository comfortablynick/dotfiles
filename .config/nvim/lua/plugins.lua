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
  local options = {
    package_root = pack_dir,
    plugin_package = "test",
    disable_commands = true,
    opt_default = true,
  }
  if packer == nil then
    packer = require"packer"
    packer.init(options)
  end

  local use = packer.use
  packer.reset()

  -- Plugins {{{1
  -- General {{{2
  -- Packer can manage itself as an optional plugin
  use{"wbthomason/packer.nvim"}
  use{"NLKNguyen/papercolor-theme"}

  -- Editing behavior {{{2
  use{"tpope/vim-commentary"}
  use{"tpope/vim-unimpaired"}
  use{"machakann/vim-sandwich"}
  use{"justinmk/vim-sneak"}
  use{"rhysd/clever-f.vim"}
  use{"wellle/targets.vim"}
  use{"bfredl/nvim-miniyank"}
  use{"antoinemadec/FixCursorHold.nvim"}

  -- Explorer/finder utils {{{2
  use{"majutsushi/tagbar", cmd = "TagbarToggle"}
  use{"mbbill/undotree", cmd = "UndotreeToggle"}
  use{"preservim/nerdtree", cmd = "NERDTreeToggle"}
  use{"Shougo/defx.nvim", cmd = "Defx"}
  use{"tpope/vim-projectionist"}
  use{"kyazdani42/nvim-tree.lua", cmd = "LuaTreeToggle"}
  use{"justinmk/vim-dirvish"}
  use{"srstevenson/vim-picker"}
  use{"voldikss/vim-floaterm"}
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
  use{"neovim/nvim-lsp"}
  use{
    "nvim-lua/completion-nvim",
    after = "nvim-lsp",
    requires = {{"norcalli/snippets.nvim", after = "nvim-lsp"}},
  }
  use{"steelsojka/completion-buffers", after = "nvim-lsp"}

  -- Vim Development {{{2
  use{"tweekmonster/startuptime.vim", cmd = "StartupTime"}
  use{"tpope/vim-scriptease"}
  use{"mhinz/vim-lookup"}
  use{"bfredl/nvim-luadev"}

  -- Tmux {{{2
  use{"christoomey/vim-tmux-navigator"}
  use{"RyanMillerC/better-vim-tmux-resizer"}
  use{"comfortablynick/vim-tmux-runner"}

  -- Runners/Linters/Formatters {{{2
  use{"dense-analysis/ale"}
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
  use{"skywind3000/asyncrun.vim"}
  use{
    "skywind3000/asynctasks.vim",
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
