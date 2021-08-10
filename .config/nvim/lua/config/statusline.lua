local devicons = vim.F.npcall(require, "nvim-web-devicons")
local api = vim.api

local M = {}
M.opts = {
  ignore = { "pine", "vfinder", "qf", "undotree", "diff", "coc-explorer" },
  sep = "┊",
  symbol = {
    branch = "",
    buffer = "❖",
    error_sign = "✘",
    git = "",
    ["git-reverse"] = "",
    hint_sign = "•",
    line_no = "",
    lines = "☰",
    modified = "●",
    readonly = "",
    success_sign = "✓",
    unmodifiable = "-",
    warning_sign = "‼",
  },
  width = {
    max = 200,
    med = 140,
    min = 90,
  },
}

M.is_active_win = function()
  return api.nvim_get_current_win() == vim.g.actual_curwin
end

M.ft_icon = function()
  if not devicons then
    return ""
  end
  return devicons.get_icon(vim.fn.expand "%", vim.fn.expand "%:e")
end

M.get = function()
  return table.concat {
    "%(%1* %{statusline#bufnr()} %*%)",
    "%(%7* %{statusline#file_size()} %*%)",
    "%([%{statusline#bufnr_inactive()}]%)",
    "%( %{statusline#file_name()} %)",
    "%<",
    "%(%h%w%q%m%r %)",
    "%(  %4*%{statusline#linter_errors()}%*%)",
    "%( %5*%{statusline#linter_warnings()}%*%)",
    "%( %6*%{statusline#linter_hints()}%*%)",
    "%=",
    "%( %{statusline#toggled()} ",
    M.opts.sep,
    "%)",
    "%( %{statusline#mucomplete_method()} %)",
    "%( %{statusline#job_status()} ",
    M.opts.sep,
    "%)",
    "%( %{statusline#current_tag()}%)",
    "%( %-20.60{statusline#lsp_status()}%)",
    "%( %{statusline#coc_status()} %)",
    "%( %{statusline#file_type()} %)",
    "%(%3* %{statusline#git_status()} %*%)",
    "%(%2* %{statusline#line_info()}%*%)",
  }
end

_G.statusline = M
