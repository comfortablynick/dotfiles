local util = require "util"
local package_root = util.path.join(vim.fn.stdpath "data", "site", "pack")
local install_path = util.path.join(package_root, "packer", "opt", "packer.nvim")
local M = {}

if not util.path.is_dir(install_path) then
  vim.fn.system { "git", "clone", "--depth", 1, "https://github.com/wbthomason/packer.nvim", install_path }
end

local packer = nil

-- Lazy load user autocmd
local lazy_load_event = "User PackLoad"

local function init()
  if packer == nil then
    vim.cmd.packadd "packer.nvim"
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
    ["psliwka/vim-smoothie"] = { event = lazy_load_event },
    ["kkoomen/vim-doge"] = { run = ":call doge#install(#{headless: 1})}", ft = { "python" } },
    ["sbdchd/neoformat"] = {
      cmd = "Neoformat",
      setup = function()
        require "config.neoformat"
      end,
    },
    ["skywind3000/asyncrun.vim"] = {
      cmd = "AsyncRun",
      setup = function()
        vim.cmd.runtime "autoload/plugins/asyncrun.vim"
      end,
    },
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

        vim.keymap.set("n", "<Leader>r", "<Cmd>AsyncTask file-run<CR>", { desc = "Run file with AsyncTask" })
        vim.keymap.set("n", "<Leader>b", "<Cmd>AsyncTask file-build<CR>", { desc = "Build file with AsyncTask" })
        vim.fn["map#cabbr"]("ta", "AsyncTask")
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
      setup = function()
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
    ["tpope/vim-unimpaired"] = { event = lazy_load_event },
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
      setup = function()
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
      run = {
        "./install --bin",
        "ln -sf $(pwd)/bin/* ~/.local/bin",
        "ln -sf $(pwd)/man/man1/* ~/.local/share/man/man1",
      },
    },
    ["ibhagwan/fzf-lua"] = { event = lazy_load_event },
    ["junegunn/fzf.vim"] = {
      event = lazy_load_event,
      setup = function()
        vim.cmd.runtime "autoload/plugins/fzf.vim"
      end,
    },
    ["kevinhwang91/rnvimr"] = {
      event = lazy_load_event,
      run = "pip3 install -U pynvim",
      cmd = "RnvimrToggle",
      setup = function()
        vim.g.rnvimr_enable_picker = 1
        vim.keymap.set("n", "<C-e>", "<Cmd>RnvimrToggle<CR>", { desc = "Toggle Rnvimr" })
        vim.keymap.set("n", "<Leader>n", "<Cmd>RnvimrToggle<CR>", { desc = "Toggle Rnvimr" })
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
      setup = function()
        vim.cmd.runtime "autoload/plugins/clap.vim"
      end,
    },
    ["mbbill/undotree"] = {
      cmd = "UndotreeToggle",
      setup = function()
        vim.keymap.set("n", "<F5>", "<Cmd>UndotreeToggle<CR>", { desc = "Toggle UndoTree" })
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
        vim.keymap.set("n", "<Leader>e", "<Plug>(PickerEdit)", { desc = "Fuzzy edit" })
        vim.keymap.set("n", "<Leader>v", "<Plug>(PickerVsplit)", { desc = "Fuzzy vsplit edit" })
      end,
    },
    ["voldikss/vim-floaterm"] = {
      cmd = { "FloatermNew", "FloatermToggle" },
      setup = function()
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
    ["SirVer/ultisnips"] = {
      setup = function()
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
        { "hrsh7th/cmp-cmdline" },
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
        vim.keymap.set("v", "<Enter>", "<Plug>(Luadev-Run)", { desc = "Run in REPL", buffer = true })
        vim.keymap.set("n", "grl", "<Plug>(Luadev-RunLine)", { desc = "Run line in REPL", buffer = true })
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
        vim.keymap.set("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", { desc = "Vim/Tmux navigate left" })
        vim.keymap.set("n", "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>", { desc = "Vim/Tmux navigate down" })
        vim.keymap.set("n", "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>", { desc = "Vim/Tmux navigate up" })
        vim.keymap.set("n", "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", { desc = "Vim/Tmux navigate right" })
        vim.keymap.set(
          "n",
          "<C-p>",
          "<Cmd>NvimTmuxNavigateLastActive<CR>",
          { desc = "Vim/Tmux navigate to last active window" }
        )
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
end

local plugins = setmetatable(M, {
  __index = function(_, key)
    init()
    return packer[key]
  end,
})

return plugins
