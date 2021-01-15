return {
  filetypes = {
    "lua",
    "vim",
    "sh",
    "python",
  },
  init_options = {
    filetypes = {
      lua = "luacheck",
      vim = "vint",
      sh = "shellcheck",
      python = "pydocstyle",
    },
    formatFiletypes = {sh = "shfmt"},
    linters = {
      -- TODO: why doesn't luacheck work?
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
      vint = {
        command = "vint",
        debounce = 100,
        args = {"--enable-neovim", "-"},
        offsetLine = 0,
        offsetColumn = 3,
        sourceName = "vint",
        formatLines = 1,
        formatPattern = {
          "[^:]+:(\\d+):(\\d+):\\s*(.*)(\\r|\\n)*$",
          {line = 1, column = 2, message = 3},
        },
      },
    },
    formatters = {
      shfmt = {command = "shfmt", args = {"-i", vim.fn.shiftwidth(), "-"}},
    },
  },
}
