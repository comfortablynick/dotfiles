local util = require "util"
local package_root = util.path.join(vim.fn.stdpath "data", "site", "pack")
local install_path = util.path.join(package_root, "packer", "opt", "packer.nvim")

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system { "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path }
end

local packer = nil

-- Join arguments into a path to pass to :runtime
-- runtime('autoload', 'plugins', 'ale') -> :runtime autoload/plugins/ale.vim
local runtime = function(...)
  local path = util.path.join(...)
  return ([[vim.cmd("runtime %s.vim")]]):format(path)
end

-- Lazy load user autocmd
local lazy_load_event = "User PackLoad"

local function init()
  if packer == nil then
    packer = require "packer"
    packer.init {
      package_root = package_root,
      disable_commands = true,
      opt_default = true,
      display = {
        open_cmd = "topleft 100vnew \\[packer\\]",
        prompt_border = "double",
        keybindings = {
          quit = "q",
          toggle_info = "<Space>",
          diff = "<CR>",
          prompt_revert = "r",
        },
      },
    }
  end

  local use = packer.use
  packer.reset()
  use "wbthomason/packer.nvim"

  -- Plugin definitions
  use {
    "airblade/vim-rooter",
    setup = function()
      vim.g.rooter_silent_chdir = 1
      vim.g.rooter_manual_only = 1
      vim.g.rooter_patterns = vim.g.root_patterns
    end,
  }
  use { "tpope/vim-eunuch", cmd = { "Delete", "Rename", "Chmod", "Move" } }
  use { "moll/vim-bbye", disable = true }
  use { "psliwka/vim-smoothie", event = lazy_load_event }

  use { "kkoomen/vim-doge", run = ":call doge#install(#{headless: 1})}", ft = { "python" } }
  use {
    "sbdchd/neoformat",
    cmd = "Neoformat",
    setup = function()
      require "config.neoformat"
    end,
  }
  use { "skywind3000/asyncrun.vim", cmd = "AsyncRun", setup = runtime("autoload", "plugins", "asyncrun") }
  use {
    "skywind3000/asynctasks.vim",
    run = "ln -sf $(pwd)/bin/asynctask ~/.local/bin",
    cmd = "AsyncTask",
    setup = function()
      vim.g.asynctasks_extra_config = {
        "~/.config/nvim/tasks.ini",
      }
      vim.g.asynctasks_profile = "release"
      vim.g.asynctasks_term_pos = "right"
      vim.g.asynctasks_term_reuse = 1

      vim.api.nvim_set_keymap("n", "<Leader>r", "<Cmd>AsyncTask file-run", { noremap = true })
      vim.api.nvim_set_keymap("n", "<Leader>b", "<Cmd>AsyncTask file-build", { noremap = true })
      vim.call("map#cabbr", "ta", "AsyncTask")
    end,
  }
  use { "michaelb/sniprun", run = "./install.sh" }

  -- Editing behavior
  use {
    "bfredl/nvim-miniyank",
    keys = {
      "<Plug>(miniyank-autoput)",
      "<Plug>(miniyank-autoPut)",
      "<Plug>(miniyank-startput)",
      "<Plug>(miniyank-startPut)",
      "<Plug>(miniyank-cycle)",
      "<Plug>(miniyank-cycleback)",
    },
    setup = function()
      vim.g.miniyank_maxitems = 50
      -- Replace built-in put with autoput
      vim.api.nvim_set_keymap("n", "p", "<Plug>(miniyank-autoput)", {})
      vim.api.nvim_set_keymap("n", "P", "<Plug>(miniyank-autoPut)", {})
      -- Put most recent item in shared history
      vim.api.nvim_set_keymap("n", "<Leader>p", "<Plug>(miniyank-startput)", {})
      vim.api.nvim_set_keymap("n", "<Leader>P", "<Plug>(miniyank-startPut)", {})
      vim.api.nvim_set_keymap("n", "<Leader>y", "<Plug>(miniyank-cycle)", {})
      vim.api.nvim_set_keymap("n", "<Leader>Y", "<Plug>(miniyank-cycleback)", {})
    end,
  }
  use {
    "junegunn/vim-easy-align",
    cmd = { "LiveEasyAlign", "EasyAlign" },
    keys = { "<Plug>(EasyAlign)" },
    setup = function()
      vim.api.nvim_set_keymap("x", "ga", "<Plug>(EasyAlign)", {})
      vim.g.easy_align_ignore_groups = { "Comment", "String" }
      vim.g.easy_align_delimiters = {
        ['"'] = { pattern = '"', ignore_groups = { "!Comment" }, ignore_unmatched = 0 },
      }
    end,
  }
  use "tpope/vim-projectionist"
  use { "tpope/vim-obsession", cmd = "Obsession" }

  -- Motions
  use { "tpope/vim-repeat", event = lazy_load_event }
  use { "tpope/vim-unimpaired", event = lazy_load_event }
  -- Lua impl of easymotion/sneak
  use {
    "phaazon/hop.nvim",
    cmd = { "HopWord", "HopChar1", "HopChar2", "HopLine" },
    config = function()
      local hop = require "hop"
      hop.setup { winblend = 100 }
    end,
    setup = function()
      local opts = { noremap = true }
      vim.api.nvim_set_keymap("n", "<Leader>s", "<Cmd>HopWord<CR>", opts)
      vim.api.nvim_set_keymap("n", "<Leader>l", "<Cmd>HopLine<CR>", opts)
      vim.api.nvim_set_keymap("n", "f", "<Cmd>HopChar1<CR>", opts)
      vim.api.nvim_set_keymap("n", "s", "<Cmd>HopChar2<CR>", opts)
    end,
  }

  -- [f|F]{char} motion
  use {
    "rhysd/clever-f.vim",
    setup = function()
      vim.g.clever_f_smart_case = 1
      vim.g.clever_f_chars_match_any_signs = ":;"
    end,
    disable = true,
    -- event = lazy_load_event,
  }

  -- Text objects
  use { "wellle/targets.vim", event = lazy_load_event }
  use { "tommcdo/vim-exchange", keys = { { "n", "cx" }, { "x", "X" }, { "n", "cxc" }, { "n", "cxx" } } }
  use {
    "machakann/vim-sandwich",
    event = lazy_load_event,
    setup = function()
      vim.g.sandwich_no_default_key_mappings = true
      vim.g.operator_sandwich_no_default_key_mappings = true
    end,
    config = function()
      -- Make sandwich behave like vim-surround
      vim.cmd [[runtime macros/sandwich/keymap/surround.vim]]
      -- Select text surrounded by brackets or other object
      vim.api.nvim_set_keymap("x", "is", "<Plug>(textobj-sandwich-query-i)", {})
      vim.api.nvim_set_keymap("o", "is", "<Plug>(textobj-sandwich-query-i)", {})
      vim.api.nvim_set_keymap("x", "as", "<Plug>(textobj-sandwich-query-a)", {})
      vim.api.nvim_set_keymap("o", "as", "<Plug>(textobj-sandwich-query-a)", {})
    end,
  }

  -- Commenting
  use {
    "tpope/vim-commentary",
    -- keys = { "<Plug>CommentaryLine", "<Plug>Commentary" },
    event = lazy_load_event,
    setup = function()
      vim.api.nvim_set_keymap("x", "<Leader>c", "<Plug>Commentary", {})
      vim.api.nvim_set_keymap("n", "<Leader>c", "<Plug>Commentary", {})
      vim.api.nvim_set_keymap("o", "<Leader>c", "<Plug>Commentary", {})
      vim.api.nvim_set_keymap("n", "<Leader>c<Space>", "<Plug>CommentaryLine", {})
    end,
  }

  -- Explorer/finder utils
  use {
    "junegunn/fzf",
    event = lazy_load_event,
    run = [[sh -c './install --bin && ln -sf $(pwd)/bin/* ~/.local/bin ]]
      .. [[&& ln -sf $(pwd)/man/man1/* ~/.local/share/man/man1']],
  }
  use { "junegunn/fzf.vim", event = lazy_load_event }
  use {
    "kevinhwang91/rnvimr",
    event = lazy_load_event,
    run = "pip3 install -U pynvim",
    cmd = "RnvimrToggle",
    setup = function()
      vim.g.rnvimr_enable_picker = 1
    end,
  }
  use {
    "liuchengxu/vista.vim",
    event = "BufEnter",
    setup = function()
      require "config.vista"
    end,
  }
  use {
    "liuchengxu/vim-clap",
    run = ":Clap install-binary",
    requires = "liuchengxu/vista.vim",
    setup = runtime("autoload", "plugins", "clap"),
  }
  use {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    setup = function()
      vim.api.nvim_set_keymap("n", "<F5>", "<Cmd>UndotreeToggle<CR>", { noremap = true })
    end,
    config = function()
      vim.g.undotree_WindowLayout = 4
    end,
  }
  use "justinmk/vim-dirvish"
  use {
    "srstevenson/vim-picker",
    keys = { "<Plug>(PickerEdit)", "<Plug>(PickerVsplit)" },
    setup = function()
      vim.g.picker_custom_find_executable = "fd"
      vim.g.picker_custom_find_flags = "-t f -HL --color=never"
      vim.api.nvim_set_keymap("n", "<Leader>e", "<Plug>(PickerEdit)", {})
      vim.api.nvim_set_keymap("n", "<Leader>v", "<Plug>(PickerVsplit)", {})
    end,
  }
  use { "voldikss/vim-floaterm", cmd = "FloatermNew", setup = runtime("autoload", "plugins", "floaterm") }

  -- Vim development
  use { "tpope/vim-scriptease", cmd = "Messages" }
  use "mhinz/vim-lookup"
  use { "tweekmonster/startuptime.vim", cmd = "StartupTime" }
  use "dstein64/vim-startuptime"

  -- Editor appearance
  use "ryanoasis/vim-devicons"
  use {
    "kyazdani42/nvim-web-devicons",
  }

  -- Colorschemes
  use {
    "NLKNguyen/papercolor-theme",
    setup = function()
      vim.g.PaperColor_Theme_Options = {
        language = {
          python = {
            highlight_builtins = 1,
          },
          cpp = {
            highlight_standard_library = 1,
          },
          c = {
            highlight_builtins = 1,
          },
        },
        theme = {
          default = {
            allow_bold = 1,
            allow_italic = 1,
          },
          ["default.dark"] = {
            override = {
              vertsplit_bg = { "#808080", "244" },
            },
          },
        },
      }
    end,
  }
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
  use { "tpope/vim-fugitive", cmd = { "Git", "Gstatus", "Gblame", "Gpush", "Gpull" } }
  use { "junegunn/gv.vim", cmd = "GV" }
  use { "iberianpig/tig-explorer.vim", cmd = { "Tig", "TigStatus" } }
  use {
    "TimUntersberger/neogit",
    cmd = "Neogit",
    config = function()
      require "config.neogit"
    end,
    requires = { { "nvim-lua/plenary.nvim" }, { "sindrets/diffview.nvim" } },
  }

  -- Snippets
  use { "SirVer/ultisnips", setup = runtime("autoload", "plugins", "ultisnips") }
  use { "honza/vim-snippets", event = lazy_load_event }
  use "norcalli/snippets.nvim"
  use "L3MON4D3/LuaSnip"
  use "rafamadriz/friendly-snippets"

  -- Language server/completion
  use {
    "neovim/nvim-lspconfig",
    requires = {
      { "nvim-lua/lsp-status.nvim" },
      { "nvim-lua/lsp_extensions.nvim" },
      { "glepnir/lspsaga.nvim" },
    },
  }
  use { "nvim-lua/completion-nvim", requires = { "steelsojka/completion-buffers" }, disable = true }
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    cmd = { "Trouble", "TroubleToggle" },
    config = function()
      require("trouble").setup {}
    end,
  }
  -- TODO: lazy load this using InsertCharPre?
  use "hrsh7th/nvim-compe"

  -- Lua/nvim
  use "rktjmp/lush.nvim"
  use { "norcalli/nvim-colorizer.lua", cmd = { "Colorizer", "ColorizerToggle" } }
  use {
    "lewis6991/gitsigns.nvim",
    event = "BufEnter",
    config = function()
      require "config.gitsigns"
    end,
  }
  use {
    "bfredl/nvim-luadev",
    ft = "lua",
    config = function()
      vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>(Luadev-Run)", {})
      vim.api.nvim_buf_set_keymap(0, "n", "grl", "<Plug>(Luadev-RunLine)", {})
    end,
  }
  use "nvim-lua/plenary.nvim"
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
  use {
    "akinsho/nvim-bufferline.lua",
    event = "BufEnter",
    config = function()
      require "config.bufferline"
    end,
  }
  use "norcalli/profiler.nvim"
  use { "romgrk/todoist.nvim", run = ":TodoistInstall" }
  use { "kevinhwang91/nvim-bqf", event = lazy_load_event }
  use "antoinemadec/FixCursorHold.nvim"
  use {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
  }

  -- Training/Vim help
  use "tjdevries/train.nvim"
  use {
    "folke/which-key.nvim",
    event = lazy_load_event,
    config = function()
      require "config.which-key"
    end,
  }

  -- Tmux
  use {
    "christoomey/vim-tmux-navigator",
    cmd = { "TmuxNavigateLeft", "TmuxNavigateRight", "TmuxNavigateDown", "TmuxNavigateUp", "TmuxNavigatePrevious" },
    setup = function()
      local opts = { noremap = true }
      vim.g.tmux_navigator_no_mappings = 1
      vim.api.nvim_set_keymap("n", "<C-h>", "<Cmd>TmuxNavigateLeft<CR>", opts)
      vim.api.nvim_set_keymap("n", "<C-j>", "<Cmd>TmuxNavigateDown<CR>", opts)
      vim.api.nvim_set_keymap("n", "<C-k>", "<Cmd>TmuxNavigateUp<CR>", opts)
      vim.api.nvim_set_keymap("n", "<C-l>", "<Cmd>TmuxNavigateRight<CR>", opts)
      vim.api.nvim_set_keymap("n", "<C-p>", "<Cmd>TmuxNavigatePrevious<CR>", opts)
    end,
  }
  use {
    "comfortablynick/vim-tmux-runner",
    cmd = { "VtrSendCommandToRunner", "VtrOpenRunner" },
    setup = function()
      vim.g.VtrPercentage = 40
      vim.g.VtrOrientation = "h"
      vim.g.VtrInitialCommand = ""
      vim.g.VtrGitCdUpOnOpen = 0
      vim.g.VtrClearBeforeSend = 1
      vim.g.VtrClearOnReorient = 1
      vim.g.VtrClearOnReattach = 1
      vim.g.VtrDetachedName = "VTR"
      vim.g.VtrDisplayPaneNumbers = 1
      vim.g.VtrStripLeadingWhitespace = 1
      vim.g.VtrClearEmptyLines = 1
      vim.g.VtrAppendNewline = 0
    end,
  }
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end,
})

return plugins
