local api = vim.api
local uv = vim.loop
local npcall = vim.F.npcall
local winwidth = api.nvim_win_get_width
local util = require "util"
local devicons = npcall(require, "nvim-web-devicons")
local lsp = require "config.lsp"

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
    "%(  %4*%{v:lua.statusline.lsp_errors()}%*%)",
    "%( %5*%{v:lua.statusline.lsp_warnings()}%*%)",
    "%( %6*%{v:lua.statusline.lsp_hints()}%*%)",
    "%=",
    -- "%( %{statusline#toggled()} ",
    -- M.opts.sep,
    -- "%)",
    "%( %{v:lua.statusline.job_status()} ",
    M.opts.sep,
    "%)",
    "%( %-20.80{v:lua.statusline.lsp_status()}%)",
    "%( %{statusline#file_type()} %)",
    "%(%3* %{statusline#git_status()} %*%)",
    "%(%2* %{statusline#line_info()}%*%)",
  }
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
    return ""
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
  if winwidth(0) < M.opts.width.min then
    return vim.fn.pathshorten(fname)
  end
  return fname
end

M.lsp_errors = function()
  return lsp.errors() or ""
end

M.lsp_warnings = function()
  return lsp.warnings() or ""
end

M.lsp_hints = function()
  return lsp.hints() or ""
end

M.job_status = function()
  if not active_file() then
    return ""
  end
  local status = vim.g.asyncrun_status or vim.g.job_status or ""
  if status ~= "" then
    return "Job: " .. status
  else
    return ""
  end
end

M.lsp_status = function()
  if not active_file() then
    return ""
  end
  return lsp.attached_lsps() .. " " .. lsp.status()
end

_G.statusline = M
