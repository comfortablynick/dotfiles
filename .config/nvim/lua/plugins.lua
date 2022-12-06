local util = require "util"
local package_root = util.path.join(vim.fn.stdpath "data", "site", "pack")
local install_path = util.path.join(package_root, "packer", "opt", "packer.nvim")
local M = {}

if not util.path.is_dir(install_path) then
  vim.fn.system { "git", "clone", "--depth", 1, "https://github.com/wbthomason/packer.nvim", install_path }
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
    vim.cmd "packadd packer.nvim"
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

  -- Workaround for packer using $SHELL instead of &shell
  -- When $SHELL == fish, posix syntax will fail in hooks
  vim.env.SHELL = vim.o.shell

  local use = packer.use
  packer.reset()

  local plugins = {
    ["wbthomason/packer.nvim"] = {},
    ["airblade/vim-rooter"] = {
      setup = function()
        vim.g.rooter_silent_chdir = 1
        vim.g.rooter_manual_only = 1
        vim.g.rooter_patterns = vim.g.root_patterns
      end,
    },
    ["tpope/vim-eunuch"] = { cmd = { "Delete", "Rename", "Chmod", "Move" } },
    ["moll/vim-bbye"] = { disable = true },
    ["psliwka/vim-smoothie"] = { event = lazy_load_event },
    ["kkoomen/vim-doge"] = { run = ":call doge#install(#{headless: 1})}", ft = { "python" } },
    ["sbdchd/neoformat"] = {
      cmd = "Neoformat",
      setup = function()
        require "config.neoformat"
      end,
    },
    ["skywind3000/asyncrun.vim"] = { cmd = "AsyncRun", setup = runtime("autoload", "plugins", "asyncrun") },
    ["skywind3000/asynctasks.vim"] = {
      run = "ln -sf $(pwd)/bin/asynctask ~/.local/bin",
      cmd = "AsyncTask",
      setup = function()
        vim.g.asynctasks_extra_config = {
          "~/.config/nvim/tasks.ini",
        }
        vim.g.asynctasks_profile = "release"
        vim.g.asynctasks_term_pos = "right"
        vim.g.asynctasks_term_reuse = 1

        vim.map.n["<Leader>r"] = { "<Cmd>AsyncTask file-run<CR>", "Run file" }
        vim.map.n["<Leader>b"] = { "<Cmd>AsyncTask file-build<CR>", "Build file" }
        vim.call("map#cabbr", "ta", "AsyncTask")
      end,
    },
    ["michaelb/sniprun"] = { run = "./install.sh" },
    -- Editing behavior
    ["bfredl/nvim-miniyank"] = {
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
        vim.map.n.p = "<Plug>(miniyank-autoput)"
        vim.map.n.P = "<Plug>(miniyank-autoPut)"
        -- Put most recent item in shared history
        vim.map.n["<Leader>p"] = "<Plug>(miniyank-startput)"
        vim.map.n["<Leader>P"] = "<Plug>(miniyank-startPut)"
        vim.map.n["<Leader>y"] = "<Plug>(miniyank-cycle)"
        vim.map.n["<Leader>Y"] = "<Plug>(miniyank-cycleback)"
      end,
    },
    ["junegunn/vim-easy-align"] = {
      cmd = { "LiveEasyAlign", "EasyAlign" },
      keys = { "<Plug>(EasyAlign)" },
      setup = function()
        vim.map.x.ga = "<Plug>(EasyAlign)"
        vim.g.easy_align_ignore_groups = { "Comment", "String" }
        vim.g.easy_align_delimiters = {
          ['"'] = { pattern = '"', ignore_groups = { "!Comment" }, ignore_unmatched = 0 },
        }
      end,
    },
    ["tpope/vim-projectionist"] = {},
    ["tpope/vim-obsession"] = { cmd = "Obsession" },
    -- Motions
    ["tpope/vim-repeat"] = { event = lazy_load_event },
    ["tpope/vim-unimpaired"] = { event = lazy_load_event },
    ["phaazon/hop.nvim"] = { -- Lua impl of easymotion/sneak
      cmd = { "HopWord", "HopChar1", "HopChar2", "HopLine" },
      config = function()
        local hop = require "hop"
        hop.setup { winblend = 100 }
      end,
      setup = function()
        vim.map.n["<Leader>s"] = { "<Cmd>HopWord<CR>", "Hop to word" }
        vim.map.n["<Leader>l"] = { "<Cmd>HopLine<CR>", "Hop to line" }
        vim.map.n.f = { "<Cmd>HopChar1<CR>", "Hop to char" }
        vim.map.n.s = { "<Cmd>HopChar2<CR>", "Hop to 2 chars" }
      end,
      disable = true,
    },
    ["rhysd/clever-f.vim"] = { -- [f|F]{char} motion
      setup = function()
        vim.g.clever_f_smart_case = 1
        vim.g.clever_f_chars_match_any_signs = ":;"
      end,
      disable = true,
    },
    ["ggandor/lightspeed.nvim"] = { event = lazy_load_event, disable = true },
    ["ggandor/leap.nvim"] = {
      event = lazy_load_event,
      config = function()
        require("leap").add_default_mappings()
      end,
    },
    ["ggandor/flit.nvim"] = {
      event = lazy_load_event,
      config = function()
        require("flit").setup()
      end,
    },
    ["wellle/targets.vim"] = { event = lazy_load_event },
    ["tommcdo/vim-exchange"] = { keys = { { "n", "cx" }, { "x", "X" }, { "n", "cxc" }, { "n", "cxx" } } },
    -- Text objects
    ["machakann/vim-sandwich"] = {
      event = lazy_load_event,
      setup = function()
        vim.g.sandwich_no_default_key_mappings = true
        vim.g.operator_sandwich_no_default_key_mappings = true
      end,
      config = function()
        -- Make sandwich behave like vim-surround
        vim.cmd [[runtime macros/sandwich/keymap/surround.vim]]
        -- Select text surrounded by brackets or other object
        vim.map.x.is = "<Plug>(textobj-sandwich-query-i)"
        vim.map.o.is = "<Plug>(textobj-sandwich-query-i)"
        vim.map.x.as = "<Plug>(textobj-sandwich-query-a)"
        vim.map.o.as = "<Plug>(textobj-sandwich-query-a)"
      end,
    },
    ["AndrewRadev/switch.vim"] = {
      -- event = lazy_load_event,
      keys = { "<Plug>(Switch)" },
      setup = function()
        vim.g.switch_mapping = ""
        vim.map.n["g-"] = { "<Plug>(Switch)", "Switch item under cursor" }
      end,
    },
    -- Commenting
    ["numToStr/Comment.nvim"] = {
      event = lazy_load_event,
      config = function()
        require "config.comment"
      end,
    },
    -- Explorer/finder utils
    ["junegunn/fzf"] = {
      event = lazy_load_event,
      run = {
        "./install --bin",
        "ln -sf $(pwd)/bin/* ~/.local/bin",
        "ln -sf $(pwd)/man/man1/* ~/.local/share/man/man1",
      },
    },
    ["junegunn/fzf.vim"] = { event = lazy_load_event, setup = runtime("autoload", "plugins", "fzf") },
    ["kevinhwang91/rnvimr"] = {
      event = lazy_load_event,
      run = "pip3 install -U pynvim",
      cmd = "RnvimrToggle",
      setup = function()
        vim.g.rnvimr_enable_picker = 1
        vim.map.n["<C-e>"] = "<Cmd>RnvimrToggle<CR>"
        vim.map.n["<Leader>n"] = "<Cmd>RnvimrToggle<CR>"
      end,
    },
    ["liuchengxu/vista.vim"] = {
      event = lazy_load_event,
      setup = function()
        require "config.vista"
      end,
    },
    ["liuchengxu/vim-clap"] = {
      run = ":call clap#installer#force_download()",
      requires = "liuchengxu/vista.vim",
      setup = runtime("autoload", "plugins", "clap"),
    },
    ["mbbill/undotree"] = {
      cmd = "UndotreeToggle",
      setup = function()
        vim.map.n["<F5>"] = { "<Cmd>UndotreeToggle<CR>", "Toggle UndoTree" }
      end,
      config = function()
        vim.g.undotree_WindowLayout = 4
      end,
    },
    ["justinmk/vim-dirvish"] = {},
    ["srstevenson/vim-picker"] = {
      keys = { "<Plug>(PickerEdit)", "<Plug>(PickerVsplit)" },
      setup = function()
        vim.g.picker_custom_find_executable = "fd"
        vim.g.picker_custom_find_flags = "-t f -HL --strip-cwd-prefix"
        vim.map.n["<Leader>e"] = { "<Plug>(PickerEdit)", "Fuzzy edit" }
        vim.map.n["<Leader>v"] = { "<Plug>(PickerVsplit)", "Fuzzy vsplit edit" }
      end,
    },
    ["voldikss/vim-floaterm"] = {
      cmd = { "FloatermNew", "FloatermToggle" },
      setup = runtime("autoload", "plugins", "floaterm"),
    },
    ["akinsho/toggleterm.nvim"] = {
      event = lazy_load_event,
      config = function()
        require "config.toggleterm"
      end,
    },
    -- Vim development
    ["tpope/vim-scriptease"] = { cmd = { "Messages", "Verbose", "Time" } },
    ["mhinz/vim-lookup"] = {},
    ["tweekmonster/startuptime.vim"] = { cmd = "StartupTime" },
    ["dstein64/vim-startuptime"] = {},
    -- Editor appearance
    ["ryanoasis/vim-devicons"] = {},
    ["kyazdani42/nvim-web-devicons"] = {},
    -- Colorschemes
    ["NLKNguyen/papercolor-theme"] = {
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
    },
    ["lifepillar/vim-gruvbox8"] = {},
    ["ellisonleao/gruvbox.nvim"] = {
      opt = false,
      config = function()
        require("gruvbox").setup {
          undercurl = true,
          underline = true,
          bold = true,
          italic = true,
          strikethrough = true,
          invert_selection = false,
          invert_signs = false,
          invert_tabline = false,
          invert_intend_guides = false,
          inverse = true, -- invert background for search, diffs, statuslines and errors
          contrast = "", -- can be "hard", "soft" or empty string
          overrides = {},
        }
      end,
    },
    -- Syntax/filetype
    ["vhdirk/vim-cmake"] = {},
    ["cespare/vim-toml"] = {},
    ["tbastos/vim-lua"] = {},
    ["lervag/vimtex"] = {},
    ["ron-rs/ron.vim"] = { opt = false },
    ["Glench/Vim-Jinja2-Syntax"] = { opt = false },
    ["blankname/vim-fish"] = { opt = false },
    ["habamax/vim-asciidoctor"] = { opt = false },
    ["benknoble/gitignore-vim"] = { opt = false },
    ["~/git/todo.txt-vim"] = { opt = false },
    ["pearofducks/ansible-vim"] = {
      opt = false,
      run = "./UltiSnips/generate.sh",
      config = function()
        vim.g.ansible_extra_keywords_highlight = 1
      end,
    },
    ["LhKipp/nvim-nu"] = { opt = false, run = ":TSInstall nu" },
    ["tpope/vim-fugitive"] = {
      event = lazy_load_event,
    },
    ["junegunn/gv.vim"] = {
      cmd = "GV",
      config = function()
        vim.cmd [[packadd vim-fugitive]]
      end,
    },
    ["iberianpig/tig-explorer.vim"] = { cmd = { "Tig", "TigStatus" } },
    ["TimUntersberger/neogit"] = {
      cmd = "Neogit",
      config = function()
        require "config.neogit"
      end,
      requires = { { "nvim-lua/plenary.nvim" }, { "sindrets/diffview.nvim" } },
    },
    -- Snippets
    ["SirVer/ultisnips"] = { setup = runtime("autoload", "plugins", "ultisnips"), event = lazy_load_event },
    ["honza/vim-snippets"] = { event = lazy_load_event },
    ["ZhiyuanLck/smart-pairs"] = {
      event = "InsertEnter",
      config = function()
        require "config.smart-pairs"
      end,
      disable = true,
    },
    ["neovim/nvim-lspconfig"] = {
      requires = {
        { "nvim-lua/lsp-status.nvim" },
        { "nvim-lua/lsp_extensions.nvim" },
        { "j-hui/fidget.nvim" },
      },
    },
    ["folke/trouble.nvim"] = {
      requires = "kyazdani42/nvim-web-devicons",
      event = lazy_load_event,
      config = function()
        require "config.trouble"
      end,
    },
    ["hrsh7th/nvim-cmp"] = {
      requires = {
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "quangnguyen30192/cmp-nvim-ultisnips" },
      },
    },
    ["jose-elias-alvarez/nvim-lsp-ts-utils"] = {},
    ["rktjmp/lush.nvim"] = {},
    -- Lua/nvim
    ["norcalli/nvim-colorizer.lua"] = { cmd = { "Colorizer", "ColorizerToggle" } },
    ["lewis6991/gitsigns.nvim"] = {
      event = lazy_load_event,
      config = function()
        require "config.gitsigns"
      end,
    },
    ["bfredl/nvim-luadev"] = {
      ft = "lua",
      config = function()
        vim.map.v.buffer["<Enter>"] = { "<Plug>(Luadev-Run)", "Run in REPL" }
        vim.map.n.buffer.grl = { "<Plug>(Luadev-RunLine)", "Run line in REPL" }
      end,
    },
    ["rcarriga/nvim-notify"] = {
      setup = function()
        vim.notify = require "notify"
      end,
    },
    ["nvim-lua/plenary.nvim"] = {},
    ["nvim-treesitter/nvim-treesitter"] = {
      run = function()
        local ts_update = require("nvim-treesitter.install").update { with_sync = true }
        ts_update()
      end,
    },
    ["nvim-treesitter/playground"] = {},
    ["akinsho/bufferline.nvim"] = {
      event = "BufEnter",
      config = function()
        require "config.bufferline"
      end,
    },
    ["norcalli/profiler.nvim"] = {},
    ["romgrk/todoist.nvim"] = { -- TODO: add 'UpdateRemotePlugins' to this once the table issue is fixed
      run = "npm install",
      setup = function()
        vim.g.todoist = {
          icons = {
            unchecked = "  ",
            checked = "  ",
            loading = "  ",
            error = "  ",
          },
        }
      end,
    },
    ["kevinhwang91/nvim-bqf"] = { event = lazy_load_event },
    ["nvim-telescope/telescope.nvim"] = {
      cmd = "Telescope",
      requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
    },
    ["nanotee/luv-vimdocs"] = { opt = false }, -- luv docs in vim help format
    ["lewis6991/impatient.nvim"] = { opt = false },
    -- Training/Vim help
    ["tjdevries/train.nvim"] = {},
    ["folke/which-key.nvim"] = {
      event = lazy_load_event,
      config = function()
        require "config.which-key"
      end,
    },
    -- Tmux
    ["alexghergh/nvim-tmux-navigation"] = {
      cmd = {
        "NvimTmuxNavigateLeft",
        "NvimTmuxNavigateRight",
        "NvimTmuxNavigateDown",
        "NvimTmuxNavigateUp",
        "NvimTmuxNavigateLastActive",
      },
      setup = function()
        local n = vim.map.n
        n["<C-h>"] = { "<Cmd>NvimTmuxNavigateLeft<CR>", "Vim/Tmux navigate left" }
        n["<C-j>"] = { "<Cmd>NvimTmuxNavigateDown<CR>", "Vim/Tmux navigate down" }
        n["<C-k>"] = { "<Cmd>NvimTmuxNavigateUp<CR>", "Vim/Tmux navigate up" }
        n["<C-l>"] = { "<Cmd>NvimTmuxNavigateRight<CR>", "Vim/Tmux navigate right" }
        n["<C-p>"] = { "<Cmd>NvimTmuxNavigateLastActive<CR>", "Vim/Tmux navigate to last active window" }
      end,
      config = function()
        require "nvim-tmux-navigation"
      end,
    },
    ["comfortablynick/vim-tmux-runner"] = {
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
    },
  }

  for repo, config in pairs(plugins) do
    use(vim.tbl_extend("force", { repo }, config))
  end

  nvim.au.group("lua_plugins", function(grp)
    grp.FileType = {
      "packer",
      function()
        vim.map.n.J = "lua require'plugins'.goto_plugin(false)"
        vim.map.n.K = "lua require'plugins'.goto_plugin(true)"
      end,
    }
  end)
end

local get_status_symbols = function()
  local display = require("packer").config.display
  local sym_str = ""
  for k, v in pairs(display) do
    if k:match "_sym" then
      sym_str = sym_str .. v
    end
  end
  return sym_str
end

M.goto_plugin = function(backward)
  local flag = backward and "b" or ""
  local cmd = string.format([[^\s[%s]\s.*$]], get_status_symbols())
  return vim.fn.search(cmd, flag)
end

local plugins = setmetatable(M, {
  __index = function(_, key)
    init()
    return packer[key]
  end,
})

return plugins
