local installed, tsconfigs = pcall(require, "nvim-treesitter.configs")

if not installed then
  return
end

tsconfigs.setup {
  ensure_installed = {
    "fish",
    "lua",
    "go",
    "rust",
    "bash",
    "yaml",
    "toml",
    "typescript",
    "javascript",
    "python",
    "c",
    "query",
    "markdown",
    "markdown_inline",
    "vimdoc",
  },
  highlight = {
    enable = true,
    disable = function(lang, buf)
      -- if lang == "vim" then
      --   local bufname = vim.api.nvim_buf_get_name(buf)
      --   return string.match(bufname, "%[Command Line%]")
      -- end
      if lang == "yaml" then
        return true
      end
      return false
    end,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["in"] = "@number.inner",
      },
    },
    matchup = { enable = true },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
  indent = { enable = false },
  -- treesitter playground
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = "o",
      toggle_hl_groups = "i",
      toggle_injected_languages = "t",
      toggle_anonymous_nodes = "a",
      toggle_language_display = "I",
      focus_language = "f",
      unfocus_language = "F",
      update = "R",
      goto_node = "<cr>",
      show_help = "?",
    },
  },
}

vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
