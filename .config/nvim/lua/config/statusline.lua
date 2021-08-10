local devicons = vim.F.npcall(require, "nvim-web-devicons")
local api = vim.api
local uv = vim.loop
local util = require "util"

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

M.get = function()
  return table.concat {
    "%(%1* %{v:lua.statusline.bufnr()} %*%)",
    "%(%7* %{v:lua.statusline.file_size()} %*%)",
    "%([%{v:lua.statusline.bufnr_inactive()}]%)",
    "%( %{v:lua.statusline.file_name()} %)",
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

local winwidth = function()
  return api.nvim_list_uis()[1].width
end

local excluded_filetype = function()
  local exclude = {
    "help",
    "startify",
    "nerdtree",
    "fugitive",
    "netrw",
    "output",
    "vista",
    "undotree",
    "vimfiler",
    "tagbar",
    "minpac",
    "packager",
    "packer",
    "vista",
    "qf",
    "defx",
    "coc-explorer",
    "output:///info",
    "nofile",
  }
  local bufname = api.nvim_buf_get_name(0)
  local bufname_tail = vim.fn.fnamemodify(bufname, ":t")
  local names = { bufname, vim.bo.filetype, vim.bo.buftype, bufname_tail }
  return not vim.tbl_isempty(util.list_intersection(exclude, names))
end

local active_win = function()
  return api.nvim_get_current_win() == tonumber(vim.g.actual_curwin)
end

local active_file = function()
  return active_win() and not excluded_filetype()
end

M.ft_icon = function()
  if not devicons then
    return ""
  end
  return devicons.get_icon(vim.fn.expand "%", vim.fn.expand "%:e")
end

M.bufnr = function()
  if not active_win() then
    return ""
  end
  local bufnr = api.nvim_get_current_buf()
  if not vim.fn.buflisted(bufnr) then
    return ""
  end
  return bufnr
end

M.bufnr_inactive = function()
  if active_win() then
    return ""
  end
  local bufnr = api.nvim_get_current_buf()
  if not vim.fn.buflisted(bufnr) then
    return ""
  end
  return bufnr
end

M.file_size = function()
  if not active_file() then
    return ""
  end
  local stat = uv.fs_stat(api.nvim_buf_get_name(0))
  if stat == nil or stat.type == "directory" then
    return 0
  end
  return util.humanize_bytes(stat.size)
end

M.file_name = function()
  local ft = vim.bo.filetype
  local bt = vim.bo.buftype
  if ft == "help" then
    return vim.fn.expand "%:t"
  end
  if ft == "output:///info" then
    return ""
  end
  if ft == "" and (bt == "nofile" or bt == "acwrite") then
    return "[Scratch]"
  end
  local fname = vim.fn.expand "%:~:."
  if winwidth() < M.opts.width.min then
    return vim.fn.pathshorten(fname)
  end
  return fname
end

_G.statusline = M
