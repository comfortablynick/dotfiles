local M = {}

-- Lazy load user autocmd
local lazy_load_event = "VeryLazy"

-- Workaround for packer using $SHELL instead of &shell
-- When $SHELL == fish, posix syntax will fail in hooks
vim.env.SHELL = vim.o.shell

local plugins = {
  ["airblade/vim-rooter"] = {
    init = function()
      vim.g.rooter_silent_chdir = 1
      vim.g.rooter_manual_only = 1
      vim.g.rooter_patterns = vim.g.root_patterns
    end,
  },
  ["tpope/vim-eunuch"] = { cmd = { "Delete", "Rename", "Chmod", "Move" } },
  ["psliwka/vim-smoothie"] = { event = lazy_load_event },
  ["kkoomen/vim-doge"] = {
    build = function()
      vim.fn["doge#install"] { headless = 1 }
    end,
    ft = { "python" },
  },
  ["sbdchd/neoformat"] = {
    cmd = "Neoformat",
    init = function()
      require "config.neoformat"
    end,
  },
  ["skywind3000/asyncrun.vim"] = {
    cmd = "AsyncRun",
    init = function()
      vim.cmd.runtime "autoload/plugins/asyncrun.vim"
    end,
  },
  ["skywind3000/asynctasks.vim"] = {
    build = "ln -sf $(pwd)/bin/asynctask ~/.local/bin",
    cmd = "AsyncTask",
    init = function()
      vim.g.asynctasks_extra_config = {
        vim.fn.stdpath "config" .. "/tasks.ini",
      }
      vim.g.asynctasks_profile = "release"
      vim.g.asynctasks_term_pos = "right"
      vim.g.asynctasks_term_reuse = 1

      vim.keymap.set("n", "<Leader>r", "<Cmd>AsyncTask file-run<CR>", { desc = "Run file with AsyncTask" })
      vim.keymap.set("n", "<Leader>b", "<Cmd>AsyncTask file-build<CR>", { desc = "Build file with AsyncTask" })
      vim.fn["map#cabbr"]("ta", "AsyncTask")
    end,
  },
  ["stevearc/overseer.nvim"] = {
    event = lazy_load_event,
    dependencies = "stevearc/dressing.nvim",
    config = function()
      require "config.overseer"
    end,
  },
  ["michaelb/sniprun"] = { build = "./install.sh" },
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
    init = function()
      vim.g.miniyank_maxitems = 50
      -- Replace built-in put with autoput
      vim.keymap.set("n", "p", "<Plug>(miniyank-autoput)")
      vim.keymap.set("n", "P", "<Plug>(miniyank-autoPut)")
      -- Put most recent item in shared history
      vim.keymap.set("n", "<Leader>p", "<Plug>(miniyank-startput)")
      vim.keymap.set("n", "<Leader>P", "<Plug>(miniyank-startPut)")
      vim.keymap.set("n", "<Leader>y", "<Plug>(miniyank-cycle)")
      vim.keymap.set("n", "<Leader>Y", "<Plug>(miniyank-cycleback)")
    end,
  },
  ["junegunn/vim-easy-align"] = {
    cmd = { "LiveEasyAlign", "EasyAlign" },
    keys = { "<Plug>(EasyAlign)" },
    init = function()
      vim.keymap.set("x", "ga", "<Plug>(EasyAlign)")
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
  ["echasnovski/mini.bracketed"] = {
    event = lazy_load_event,
    version = false,
    config = function()
      require("mini.bracketed").setup {
        comment = { suffix = "x" },
        treesitter = { suffix = "n" },
      }
    end,
  },
  ["ggandor/leap.nvim"] = {
    event = lazy_load_event,
    config = function()
      require("leap").add_default_mappings()
      -- I don't want the visual mode mappings
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")
    end,
  },
  ["ggandor/flit.nvim"] = {
    event = lazy_load_event,
    config = true,
  },
  ["wellle/targets.vim"] = { event = lazy_load_event },
  ["tommcdo/vim-exchange"] = {
    keys = {
      { "cxx" },
      { "cxc" },
      { "cx" },
    },
  },
  -- Text objects
  ["kylechui/nvim-surround"] = {
    event = lazy_load_event,
    config = true,
  },
  ["chrisgrieser/nvim-various-textobjs"] = {
    event = lazy_load_event,
    config = function()
      require("various-textobjs").setup { useDefaultKeymaps = true }
    end,
  },
  ["machakann/vim-sandwich"] = {
    enabled = false,
    event = lazy_load_event,
    init = function()
      vim.g.sandwich_no_default_key_mappings = true
      vim.g.operator_sandwich_no_default_key_mappings = true
    end,
    config = function()
      -- Make sandwich behave like vim-surround
      vim.cmd.runtime "macros/sandwich/keymap/surround.vim"
      -- Select text surrounded by brackets or other object
      vim.keymap.set("x", "is", "<Plug>(textobj-sandwich-query-i)")
      vim.keymap.set("o", "is", "<Plug>(textobj-sandwich-query-i)")
      vim.keymap.set("x", "as", "<Plug>(textobj-sandwich-query-a)")
      vim.keymap.set("o", "as", "<Plug>(textobj-sandwich-query-a)")
    end,
  },
  ["AndrewRadev/switch.vim"] = {
    keys = { "<Plug>(Switch)" },
    init = function()
      vim.g.switch_mapping = ""
      vim.keymap.set("n", "g-", "<Plug>(Switch)", { desc = "Switch item under cursor" })
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
    build = {
      "./install --bin",
      "ln -sf $(pwd)/bin/* ~/.local/bin",
      "ln -sf $(pwd)/man/man1/* ~/.local/share/man/man1",
    },
  },
  ["ibhagwan/fzf-lua"] = {
    event = lazy_load_event,
    config = function()
      require "config.fzf"
    end,
  },
  ["junegunn/fzf.vim"] = {
    event = lazy_load_event,
    init = function()
      vim.cmd.runtime "autoload/plugins/fzf.vim"
    end,
  },
  ["kevinhwang91/rnvimr"] = {
    event = lazy_load_event,
    build = "pip3 install -U pynvim",
    cmd = "RnvimrToggle",
    init = function()
      vim.g.rnvimr_enable_picker = 1
      vim.keymap.set("n", "<C-e>", "<Cmd>RnvimrToggle<CR>", { desc = "Toggle Rnvimr" })
      vim.keymap.set("n", "<Leader>n", "<Cmd>RnvimrToggle<CR>", { desc = "Toggle Rnvimr" })
    end,
  },
  ["liuchengxu/vista.vim"] = {
    event = lazy_load_event,
    init = function()
      require "config.vista"
    end,
  },
  ["liuchengxu/vim-clap"] = {
    cmd = "Clap",
    build = ":call clap#installer#force_download()",
    dependencies = { "liuchengxu/vista.vim" },
    init = function()
      vim.cmd.runtime "autoload/plugins/clap.vim"
    end,
  },
  ["mbbill/undotree"] = {
    cmd = "UndotreeToggle",
    init = function()
      vim.keymap.set("n", "<F5>", "<Cmd>UndotreeToggle<CR>", { desc = "Toggle UndoTree" })
    end,
    config = function()
      vim.g.undotree_WindowLayout = 4
    end,
  },
  ["justinmk/vim-dirvish"] = { lazy = false },
  ["srstevenson/vim-picker"] = {
    keys = { "<Plug>(PickerEdit)", "<Plug>(PickerVsplit)" },
    init = function()
      vim.g.picker_custom_find_executable = "fd"
      vim.g.picker_custom_find_flags = "-t f -HL --strip-cwd-prefix"

      vim.keymap.set("n", "<Leader>v", "<Plug>(PickerVsplit)", { desc = "Fuzzy vsplit edit" })
    end,
  },
  ["voldikss/vim-floaterm"] = {
    cmd = { "FloatermNew", "FloatermToggle" },
    init = function()
      vim.cmd.runtime "autoload/plugins/floaterm.vim"
    end,
  },
  ["akinsho/toggleterm.nvim"] = {
    event = lazy_load_event,
    config = function()
      require "config.toggleterm"
    end,
  },
  -- Vim development
  ["tpope/vim-scriptease"] = { cmd = { "Messages", "Verbose", "Time", "PP" } },
  ["tweekmonster/startuptime.vim"] = { cmd = "Startup" },
  ["dstein64/vim-startuptime"] = { cmd = "StartupTime" },
  -- Editor appearance
  ["ryanoasis/vim-devicons"] = {},
  ["kyazdani42/nvim-web-devicons"] = {},
  -- Colorschemes
  ["NLKNguyen/papercolor-theme"] = {
    init = function()
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
  ["ellisonleao/gruvbox.nvim"] = {
    config = function()
      require "config.gruvbox"
    end,
  },
  ["loctvl842/monokai-pro.nvim"] = {
    opts = { filter = "pro" }, -- spectrum
  },
  -- Syntax/filetype
  ["vhdirk/vim-cmake"] = { lazy = false },
  ["cespare/vim-toml"] = { lazy = false },
  ["lervag/vimtex"] = { lazy = false },
  ["ron-rs/ron.vim"] = { lazy = false },
  ["Glench/Vim-Jinja2-Syntax"] = { lazy = false },
  ["blankname/vim-fish"] = { lazy = false },
  ["habamax/vim-asciidoctor"] = { lazy = false },
  ["benknoble/gitignore-vim"] = { lazy = false },
  ["comfortablynick/todo.txt-vim"] = { dir = "~/git/todo.txt-vim", lazy = false },
  ["pearofducks/ansible-vim"] = {
    lazy = false,
    build = "./UltiSnips/generate.sh",
    config = function()
      vim.g.ansible_extra_keywords_highlight = 1
    end,
  },
  ["LhKipp/nvim-nu"] = { lazy = false, build = ":silent TSInstall nu" },
  ["tpope/vim-fugitive"] = {
    event = lazy_load_event,
  },
  ["junegunn/gv.vim"] = {
    cmd = "GV",
  },
  ["iberianpig/tig-explorer.vim"] = { cmd = { "Tig", "TigStatus" } },
  ["TimUntersberger/neogit"] = {
    cmd = "Neogit",
    config = function()
      require "config.neogit"
    end,
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
  },
  -- Snippets
  ["SirVer/ultisnips"] = {
    init = function()
      vim.g.UltiSnipsExpandTrigger = "<C-s>"
      vim.g.UltiSnipsJumpForwardTrigger = "<C-k>"
      vim.g.UltiSnipsJumpBackwardTrigger = "<C-h>"
      vim.g.UltiSnipsSnippetDirectories = { "~/.config/ultisnips" }
      vim.g.UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit = "~/.config/ultisnips"
      vim.g.snips_author = "Nick Murphy"
      vim.g.snips_email = "comfortablynick@gmail.com"
      vim.g.snips_github = "https://github.com/comfortablynick"

      vim.fn["map#cabbr"]("es", "UltiSnipsEdit")
      vim.keymap.set("i", "<Plug>(UltiForward)", "<C-R>=UltiSnips#JumpForwards()<CR>")
    end,
    event = lazy_load_event,
  },
  ["honza/vim-snippets"] = { event = lazy_load_event },
  ["neovim/nvim-lspconfig"] = {
    dependencies = {
      "nvim-lua/lsp-status.nvim",
      "nvim-lua/lsp_extensions.nvim",
      "j-hui/fidget.nvim",
      "folke/neodev.nvim",
    },
  },
  ["lvimuser/lsp-inlayhints.nvim"] = {
    config = function()
      require "config.lsp-inlayhints"
    end,
  },
  ["folke/neodev.nvim"] = {},
  ["folke/trouble.nvim"] = {
    dependencies = { "kyazdani42/nvim-web-devicons" },
    cmd = { "Trouble", "TroubleToggle" },
    config = function()
      require "config.trouble"
    end,
  },
  ["hrsh7th/nvim-cmp"] = {
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "quangnguyen30192/cmp-nvim-ultisnips",
    },
  },
  ["altermo/ultimate-autopair.nvim"] = {
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      require("ultimate-autopair").setup {
        default_pairs = {
          ft = {
            TelescopePrompt = { disable = true },
          },
        },
      }
    end,
  },
  ["jose-elias-alvarez/nvim-lsp-ts-utils"] = {},
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
      vim.keymap.set("v", "<Enter>", "<Plug>(Luadev-Run)", { desc = "Run in REPL", buffer = true })
      vim.keymap.set("n", "grl", "<Plug>(Luadev-RunLine)", { desc = "Run line in REPL", buffer = true })
    end,
  },
  ["rcarriga/nvim-notify"] = {
    event = lazy_load_event,
    config = function()
      vim.notify = require "notify"
    end,
  },
  ["nvim-lua/plenary.nvim"] = {},
  ["nvim-treesitter/nvim-treesitter"] = {
    build = function()
      local ts_update = require("nvim-treesitter.install").update { with_sync = true }
      ts_update()
    end,
  },
  ["nvim-treesitter/playground"] = { cmd = { "TSPlaygroundToggle", "TSNodeUnderCursor" } },
  ["akinsho/bufferline.nvim"] = {
    event = "BufEnter",
    config = function()
      require "config.bufferline"
    end,
  },
  ["norcalli/profiler.nvim"] = {},
  ["romgrk/todoist.nvim"] = { -- TODO: add 'UpdateRemotePlugins' to this once the table issue is fixed
    build = "npm install",
    init = function()
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
    init = function()
      vim.keymap.set("n", "<Leader><Leader>t", "<Cmd>Telescope<CR>", { desc = "Open Telescope" })
    end,
    config = function()
      require "config.telescope"
    end,
    cmd = "Telescope",
    dependencies = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
  },
  ["nvim-telescope/telescope-fzf-native.nvim"] = {
    build = "make",
  },
  ["crispgm/telescope-heading.nvim"] = {},
  ["LinArcX/telescope-scriptnames.nvim"] = { dir = "~/git/telescope-scriptnames.nvim" },
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
    config = function()
      require "nvim-tmux-navigation"
    end,
  },
  ["comfortablynick/vim-tmux-runner"] = {
    cmd = { "VtrSendCommandToRunner", "VtrOpenRunner" },
    init = function()
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
  local tbl = vim.tbl_extend("force", { repo }, config)
  table.insert(M, tbl)
end

M.load = function(plugin)
  vim.validate { plugin = { plugin, "s" } }
  return require("lazy").load { plugins = { plugin } }
end

-- Load :: Create command as generic interface to Lazy. Makes it easier in case plugin mgr is changed later
vim.api.nvim_create_user_command("Load", function(opts)
  require("plugins").load(opts.args)
end, {
  nargs = 1,
  desc = "Load plugin",
  complete = function(_)
    return vim.tbl_map(
      function(e)
        return e.name
      end,
      vim.tbl_filter(function(e)
        return not e._.loaded
      end, require("lazy").plugins())
    )
  end,
})
return M
