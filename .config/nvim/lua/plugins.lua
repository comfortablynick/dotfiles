local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"
-- local install_path = vim.loop.os_tmpdir() .. "/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system { "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path }
end

-- local packer = nil
package.loaded["packer"] = nil
local function init()
  -- if packer == nil then
  vim.cmd "packadd packer.nvim"
  packer = require "packer"
  packer.init { disable_commands = true, opt_default = true }
  -- end

  local use = packer.use
  packer.reset()
  --[=[
  use {
    'myusername/example',        -- The plugin location string (only required param)
    disable = boolean,           -- Mark a plugin as inactive
    as = string,                 -- Specifies an alias under which to install the plugin
    installer = function,        -- Specifies custom installer. See "custom installers" below.
    updater = function,          -- Specifies custom updater. See "custom installers" below.
    after = string or list,      -- Specifies plugins to load before this plugin. See "sequencing" below
    rtp = string,                -- Specifies a subdirectory of the plugin to add to runtimepath.
    opt = boolean,               -- Manually marks a plugin as optional.
    branch = string,             -- Specifies a git branch to use
    tag = string,                -- Specifies a git tag to use
    commit = string,             -- Specifies a git commit to use
    lock = boolean,              -- Skip this plugin in updates/syncs
    run = string, function, or table, -- Post-update/install hook. See "update/install hooks".
    requires = string or list,   -- Specifies plugin dependencies. See "dependencies".
    rocks = string or list,      -- Specifies Luarocks dependencies for the plugin
    config = string or function, -- Specifies code to run after this plugin is loaded.

    -- The following keys all imply lazy-loading and imply opt = true
    setup = string or function,  -- Specifies code to run before this plugin is loaded.
    cmd = string or list,        -- Specifies commands which load this plugin.
    ft = string or list,         -- Specifies filetypes which load this plugin.
    keys = string or list,       -- Specifies maps which load this plugin. See "Keybindings".
    event = string or list,      -- Specifies autocommand events which load this plugin.
    fn = string or list          -- Specifies functions which load this plugin.
    cond = string, function, or list of strings/functions,   -- Specifies a conditional test to load this plugin
    module = string or list      -- Specifies Lua module names for require. When requiring a string which starts
                                 -- with one of these module names, the plugin will be loaded.
  }
  --]=]

  use "wbthomason/packer.nvim"

  -- Plugin definitions
  use { "airblade/vim-rooter", cmd = "Rooter" }
  use "tpope/vim-eunuch"
  use "moll/vim-bbye"
  use "psliwka/vim-smoothie"

  use { "kkoomen/vim-doge", run = ":call doge#install(#{headless: 1})}" }
  use "dense-analysis/ale"
  use { "sbdchd/neoformat", cmd = "Neoformat" }
  use { "skywind3000/asyncrun.vim", cmd = "AsyncRun" }
  use { "skywind3000/asynctasks.vim", run = "ln -sf $(pwd)/bin/asynctask ~/.local/bin", cmd = "AsyncTask" }
  use { "michaelb/sniprun", run = "./install.sh" }
  use "tpope/vim-dispatch"

  -- Editing behavior
  use "bfredl/nvim-miniyank"
  use "junegunn/vim-easy-align"
  use "tpope/vim-projectionist"

  -- Motions
  use "tpope/vim-repeat"
  use "tpope/vim-unimpaired"
  -- Lua impl of easymotion
  use "phaazon/hop.nvim"

  -- [s|S]{char}{char} motion
  use "justinmk/vim-sneak"
  -- [f|F]{char} motion
  use "rhysd/clever-f.vim"

  -- Text objects
  use "wellle/targets.vim"
  use "tommcdo/vim-exchange"
  use "machakann/vim-sandwich"

  -- Commenting
  use "tpope/vim-commentary"
  use "tomtom/tcomment_vim"

  -- Explorer/finder utils
  use {
    "junegunn/fzf",
    run = "./install --bin && ln -sf $(pwd)/bin/* ~/.local/bin && ln -sf $(pwd)/man/man1/* ~/.local/share/man/man1",
  }
  use { "kevinhwang91/rnvimr", run = "pip3 install -U pynvim" }
  use { "liuchengxu/vista.vim", cmd = "Vista" }
  use { "liuchengxu/vim-clap", run = ":Clap install-binary!" }
  use "junegunn/fzf.vim"
  use { "laher/fuzzymenu.vim", cmd = "Fzm" }
  use { "mbbill/undotree", cmd = "UndotreeToggle" }
  use "preservim/nerdtree"
  use "justinmk/vim-dirvish"
  use "srstevenson/vim-picker"
  use { "voldikss/vim-floaterm", cmd = "Floaterm" }

  -- Vim development
  use { "tpope/vim-scriptease", cmd = "Messages" }
  use "mhinz/vim-lookup"
  use { "tweekmonster/startuptime.vim", cmd = "StartupTime" }
  use "dstein64/vim-startuptime"

  -- Editor appearance
  use "ryanoasis/vim-devicons"
  use "kyazdani42/nvim-web-devicons"

  -- Colorschemes
  use "NLKNguyen/papercolor-theme"
  use "lifepillar/vim-gruvbox8"

  -- Syntax/filetype
  use "vhdirk/vim-cmake"
  use "cespare/vim-toml"
  use "tbastos/vim-lua"
  use { "Glench/Vim-Jinja2-Syntax", opt = false }
  use { "blankname/vim-fish", opt = false }
  use { "habamax/vim-asciidoctor", opt = false }
  use { "benknoble/gitignore-vim", opt = false }
  use { "~/git/todo.txt-vim", opt = false }

  -- Git
  use "airblade/vim-gitgutter"
  use "mhinz/vim-signify"
  use "tpope/vim-fugitive"
  use { "junegunn/gv.vim", cmd = "GV" }
  use { "iberianpig/tig-explorer.vim", cmd = { "Tig", "TigStatus" } }
  use {
    "TimUntersberger/neogit",
    cmd = "Neogit",
    requires = { { "nvim-lua/plenary.nvim" }, { "sindrets/diffview.nvim" } },
  }

  -- Snippets
  use "SirVer/ultisnips"
  use "honza/vim-snippets"
  use "norcalli/snippets.nvim"
  use "L3MON4D3/LuaSnip"

  -- Language server/completion
  use {
    "neovim/nvim-lspconfig",
    requires = {
      { "nvim-lua/lsp-status.nvim" },
      { "nvim-lua/lsp_extensions.nvim" },
      { "glepnir/lspsaga.nvim" },
    },
  }
  use { "nvim-lua/completion-nvim", requires = { "steelsojka/completion-buffers" } }
  use "hrsh7th/nvim-compe"
  use "lifepillar/vim-mucomplete"

  -- Lua/nvim
  use "MunifTanjim/nui.nvim"
  use "rktjmp/lush.nvim"
  use "norcalli/nvim-colorizer.lua"
  use "lewis6991/gitsigns.nvim"
  use { "bfredl/nvim-luadev", cmd = "Luadev" }
  use "nvim-lua/plenary.nvim"
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
  use "akinsho/nvim-bufferline.lua"
  use "norcalli/profiler.nvim"
  use { "romgrk/todoist.nvim", run = ":TodoistInstall" }
  use "kevinhwang91/nvim-bqf"
  use "antoinemadec/FixCursorHold.nvim"
  use { "nvim-telescope/telescope.nvim", requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } } }

  -- Training/Vim help
  use "tjdevries/train.nvim"
  use { "liuchengxu/vim-which-key", cmd = { "WhichKey", "WhichKeyVisual" } }

  -- Tmux {{{2
  use "christoomey/vim-tmux-navigator"
  use "comfortablynick/vim-tmux-runner"
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end,
})

return plugins
