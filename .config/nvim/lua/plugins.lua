local M = {}

-- Lazy load user autocmd
local lazy_load_event = "VeryLazy"

local plugins = {
  ["tpope/vim-eunuch"] = { cmd = { "Delete", "Rename", "Chmod", "Move" } },
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
    build = "ln -sf $(pwd)/bin/asynctask ~/.local/bin/",
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
    enabled = false,
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
  ["tpope/vim-projectionist"] = { event = lazy_load_event },
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
      -- Remove visual mode mappings
      local maps = { "s", "S", "x", "X" }
      for _, v in ipairs(maps) do
        vim.keymap.del({ "x", "o" }, v)
      end
    end,
  },
  ["ggandor/flit.nvim"] = {
    event = lazy_load_event,
    config = true,
  },
  -- Text objects
  ["echasnovski/mini.ai"] = {
    event = lazy_load_event,
    config = function()
      require("mini.ai").setup()
    end,
  },
  ["gbprod/substitute.nvim"] = {
    enabled = true,
    config = true,
    keys = {
      {
        "cx",
        function()
          require("substitute.exchange").operator()
        end,
        desc = "Exchange operator",
      },
      {
        "cxx",
        function()
          require("substitute.exchange").line()
        end,
        desc = "Exchange line",
      },
      {
        "cxc",
        function()
          require("substitute.exchange").cancel()
        end,
        desc = "Exchange cancel",
      },
      {
        "E",
        function()
          require("substitute.exchange").visual()
        end,
        mode = "x",
        desc = "Exchange selection",
      },
    },
  },
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
  ["AndrewRadev/switch.vim"] = {
    keys = {
      { "g-", "<Plug>(Switch)", desc = "Switch item under cursor" },
    },
    init = function()
      vim.g.switch_mapping = ""
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
      "mkdir -p ~/.local/bin",
      "mkdir -p ~/.local/share/man/man1",
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
    keys = {
      { "<F5>", "<Cmd>UndotreeToggle<CR>", desc = "Toggle UndoTree" },
    },
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

      vim.keymap.set("n", "<Leader>e", "<Plug>(PickerEdit)", { desc = "Fuzzy edit" })
      vim.keymap.set("n", "<Leader>v", "<Plug>(PickerVsplit)", { desc = "Fuzzy vsplit edit" })
    end,
  },
  ["voldikss/vim-floaterm"] = {
    cmd = { "FloatermNew", "FloatermToggle" },
    keys = {
      { "<F7>", "<Cmd>FloatermToggle<CR>", desc = "Floaterm toggle" },
    },
    init = function()
      require "config.floaterm"
    end,
  },
  ["akinsho/toggleterm.nvim"] = {
    cmd = "ToggleTerm",
    keys = { { "<F8>", desc = "Toggle terminal" } },
    config = function()
      require "config.toggleterm"
    end,
  },
  -- Vim development
  ["tpope/vim-scriptease"] = { cmd = { "Messages", "Verbose", "Time", "PP" } },
  ["tweekmonster/startuptime.vim"] = {},
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
  -- Syntax/filetype
  ["vhdirk/vim-cmake"] = { lazy = false, enabled = vim.fn.executable "cmake" == 1 },
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
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewFileHistory" }, config = true },
    },
  },
  -- Snippets
  ["SirVer/ultisnips"] = {
    init = function()
      require "config.ultisnips"
    end,
    event = lazy_load_event,
    enabled = vim.g.python3_host_prog ~= nil,
  },
  ["honza/vim-snippets"] = { event = lazy_load_event },
  ["neovim/nvim-lspconfig"] = {
    dependencies = {
      "nvim-lua/lsp-status.nvim",
      "nvim-lua/lsp_extensions.nvim",
      { "j-hui/fidget.nvim", branch = "legacy" },
      -- "folke/neodev.nvim",
    },
  },
  ["lvimuser/lsp-inlayhints.nvim"] = {
    config = function()
      require "config.lsp-inlayhints"
    end,
  },
  ["folke/lazydev.nvim"] = {
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  -- { -- optional completion source for require statements and module annotations
  --   "hrsh7th/nvim-cmp",
  --   opts = function(_, opts)
  --     opts.sources = opts.sources or {}
  --     table.insert(opts.sources, {
  --       name = "lazydev",
  --       group_index = 0, -- set group index to 0 to skip loading LuaLS completions
  --     })
  --   end,
  -- },
  ["folke/trouble.nvim"] = {
    dependencies = { "kyazdani42/nvim-web-devicons" },
    cmd = "Trouble",
    keys = {
      {
        "<leader>d",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer diagnostics (Trouble)",
      },
      {
        "gR",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP references (Trouble)",
      },
    },
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
      { "quangnguyen30192/cmp-nvim-ultisnips", enabled = vim.g.python3_host_prog ~= nil },
    },
  },
  ["altermo/ultimate-autopair.nvim"] = {
    event = { "InsertEnter", "CmdlineEnter" },
    enabled = false,
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
  ["nvim-treesitter/nvim-treesitter-textobjects"] = { lazy = false },
  ["akinsho/bufferline.nvim"] = {
    event = "BufEnter",
    config = function()
      require "config.bufferline"
    end,
  },
  ["norcalli/profiler.nvim"] = {},
  ["kevinhwang91/nvim-bqf"] = { event = lazy_load_event },
  ["nvim-telescope/telescope.nvim"] = {
    cmd = "Telescope",
    keys = {
      { "<Leader><Leader>t", "<Cmd>Telescope<CR>", desc = "Open Telescope" },
      { "<Leader><Leader>d", "<Cmd>Telescope lsp_document_symbols<CR>", desc = "Show document symbols in Telescope" },
      {
        "<Leader><Leader>w",
        "<Cmd>Telescope lsp_workspace_symbols<CR>",
        desc = "Show workspace symbols in Telescope",
      },
      { "<Leader>s", "<Cmd>Telescope live_grep<CR>", desc = "Live grep with Telescope" },
      { "<C-e>", "<Cmd>Telescope find_files<CR>", desc = "Telescope fuzzy find" },
    },
    config = function()
      require "config.telescope"
    end,
    dependencies = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
  },
  ["nvim-telescope/telescope-fzf-native.nvim"] = {
    build = "make",
  },
  ["crispgm/telescope-heading.nvim"] = {},
  ["comfortablynick/telescope-scriptnames.nvim"] = {
    branch = "add-preview",
  },
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
    config = true,
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
