return {
  cmd = {"diagnostic-languageserver", "--stdio"},
  filetypes = {"lua", "vim", "sh", "python", "rust", "toml"},
  init_options = {
    filetypes = {
      lua = "luacheck",
      vim = "vint",
      sh = "shellcheck",
      python = "pydocstyle",
      toml = "taplo",
    },
    formatFiletypes = {
      sh = "shfmt",
      lua = "luaformat",
      rust = "rustfmt",
      python = "black",
    },
    linters = {
      luacheck = {
        command = "luacheck",
        debounce = 100,
        args = {"--formatter=plain", "--codes", "-"},
        offsetLine = 0,
        offsetColumn = 0,
        sourceName = "luacheck",
        formatLines = 1,
        formatPattern = {
          "([^:]+):(\\d+):(\\d+):\\s*(.*)$",
          {file = 1, line = 2, column = 3, message = 4},
        },
      },
      shellcheck = {
        command = "shellcheck",
        rootPatterns = {},
        isStdout = true,
        isStderr = false,
        debounce = 100,
        args = {"--format=gcc", "-"},
        offsetLine = 0,
        offsetColumn = 0,
        sourceName = "shellcheck",
        formatLines = 1,
        formatPattern = {
          "^([^:]+):(\\d+):(\\d+):\\s+([^:]+):\\s+(.*)$",
          {
            line = 2,
            column = 3,
            endline = 2,
            endColumn = 3,
            message = {5},
            security = 4,
          },
        },
        securities = {error = "error", warning = "warning", note = "info"},
      },
      taplo = {
        command = "taplo",
        args = {"lint", "-"},
        formatLines = 1,
        formatPattern = {"(.*)", {message = 1}},
      },
      vint = {
        command = "vint",
        debounce = 100,
        args = {"--enable-neovim", "-"},
        offsetLine = 0,
        offsetColumn = 0,
        sourceName = "vint",
        formatLines = 1,
        formatPattern = {
          "[^:]+:(\\d+):(\\d+):\\s*(.*)(\\r|\\n)*$",
          {line = 1, column = 2, message = 3},
        },
      },
    },
    formatters = {
      -- Use lua-format wrapper script
      luaformat = {command = "lua_format", isStdout = true},
      rustfmt = {},
      shfmt = {command = "shfmt", args = {"-i", vim.fn.shiftwidth(), "-"}},
      black = {command = "black", args = {"quiet", "-"}},
    },
  },
}
