local api = vim.api
local uv = vim.loop
local npcall = vim.F.npcall
local winwidth = api.nvim_win_get_width
local util = require "util"
local devicons = npcall(require, "nvim-web-devicons")
local lsp = require "config.lsp"

local M = {}
_G.statusline = M

local opts = {
  ignore = { "pine", "vfinder", "qf", "undotree", "diff", "coc-explorer" },
  sep = "|",
  symbol = {
    branch = "",
    buffer = "❖",
    error_sign = "✘",
    git = "",
    git_reverse = "",
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
    "%( %{v:lua.statusline.job_status()} ",
    opts.sep,
    "%)",
    "%( %-20.80{v:lua.statusline.lsp_status()}%)",
    "%( %{v:lua.statusline.file_type()} %)",
    "%(%3* %{v:lua.statusline.git_status()} %*%)",
    "%(%2* %{v:lua.statusline.line_info()}%*%)",
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
    "man",
  }
  local bufname = api.nvim_buf_get_name(0)
  local bufname_tail = vim.fn.fnamemodify(bufname, ":t")
  local names = { bufname, vim.bo.filetype, vim.bo.buftype, bufname_tail }
  return not vim.tbl_isempty(util.list_intersection(exclude, names))
end

local empty = function(s)
  return s == nil or s == ""
end

local active_win = function()
  return api.nvim_get_current_win() == tonumber(vim.g.actual_curwin)
end

local active_file = function()
  return active_win() and not excluded_filetype()
end

local valid_buf = function(bufnr)
  if not bufnr or bufnr < 1 then
    return false
  end
  local exists = api.nvim_buf_is_valid(bufnr)
  return exists and vim.bo[bufnr].buflisted
end

local rpad = function(s)
  if empty(s) then
    return ""
  end
  return s .. " "
end

local pad = function(s)
  if empty(s) then
    return ""
  end
  return " " .. s .. " "
end

M.ft_icon = function()
  if not devicons then
    return ""
  end
  return devicons.get_icon(vim.fn.expand "%", vim.fn.expand "%:e")
end

M.bufnr = function()
  local bufnr = api.nvim_get_current_buf()
  if not active_win() or not valid_buf(bufnr) then
    return ""
  end
  return bufnr
end

M.bufnr_inactive = function()
  local bufnr = api.nvim_get_current_buf()
  if active_win() or not valid_buf(bufnr) then
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
  if winwidth(0) < opts.width.min then
    return util.path.shorten(fname)
  end
  return fname
end

M.file_type = function()
  if not active_file() or devicons == nil or winwidth(0) < opts.width.med then
    return ""
  end
  local ftsym = rpad(devicons.get_icon(vim.fn.expand "%", vim.fn.expand "%:e"))
  return ftsym .. vim.bo.filetype
end

M.git_status = function()
  if not active_file() or winwidth(0) < opts.width.med then
    return ""
  end
  local branch = vim.b.gitsigns_head
  if empty(branch) then
    return ""
  end
  branch = branch:gsub("master", ""):gsub("main", "")
  if not empty(branch) then
    branch = branch .. pad(opts.symbol.branch)
  end
  local summary = rpad(vim.b.gitsigns_status)
  local out = summary .. branch
  if winwidth(0) >= opts.width.max then
    out = out .. rpad(opts.symbol.git)
  end
  return out
end

M.line_info = function()
  if not active_file() then
    return ""
  end
  local tot_lines = api.nvim_buf_line_count(0)
  local line, col = unpack(api.nvim_win_get_cursor(0))
  local line_pct = line * 100 / tot_lines
  return ("%d,%d %3d%%"):format(line, col + 1, line_pct)
end

M.lsp_errors = function()
  return active_file() and npcall(lsp.errors) or ""
end

M.lsp_warnings = function()
  return active_file() and npcall(lsp.warnings) or ""
end

M.lsp_hints = function()
  return active_file() and npcall(lsp.hints) or ""
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
  local attached = lsp.attached_lsps()
  if attached == nil then
    return ""
  end
  return attached .. " " .. (lsp.status() or "")
end

local syn_derive = function(ns, from, to, hl_map)
  local hl = api.nvim_get_hl_by_name(from, true)
  api.nvim_set_hl(ns, to, vim.tbl_extend("force", hl, hl_map or {}))
end

M.set_hl = function()
  local stl = api.nvim_get_hl_by_name("StatusLine", true)
  local ns = 0 -- use default :highlight namespace
  syn_derive(ns, "StatusLine", "StatusLine", { reverse = true, bold = false })
  syn_derive(ns, "IncSearch", "User1")
  syn_derive(ns, "WildMenu", "User2", { bold = false })
  syn_derive(ns, "Visual", "User3")
  syn_derive(ns, "DiffDelete", "User4", { background = stl.foreground, reverse = false })
  syn_derive(ns, "DiffText", "User5", { background = stl.foreground, reverse = false, bold = false })
  -- TODO: derive User6 for hints
  syn_derive(ns, "StatusLine", "User6", { background = "#ecff00", reverse = true, bold = true })
  syn_derive(ns, "CursorLineNr", "User7")

  -- Set these for themes that don't have it (like gruvbox8)
  api.nvim_set_hl(ns, "DiffAdded", { foreground = "#b8bb26" })
  api.nvim_set_hl(ns, "DiffChanged", { foreground = "#8ec07c" })
  api.nvim_set_hl(ns, "DiffRemoved", { foreground = "#fb4934" })
  api.nvim_set_hl_ns(ns)
end

---@return {name:string, text:string, texthl:string}[]
M.get_signs = function()
  local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  return vim.tbl_map(function(sign)
    return vim.fn.sign_getdefined(sign.name)[1]
  end, vim.fn.sign_getplaced(buf, { group = "*", lnum = vim.v.lnum })[1].signs)
end

M.column = function()
  local sign, git_sign
  for _, s in ipairs(M.get_signs()) do
    if s.name:find "GitSign" then
      git_sign = s
    else
      sign = s
    end
  end
  local components = {
    sign and ("%#" .. sign.texthl .. "#" .. sign.text .. "%*") or " ",
    [[%=]],
    [[%{&nu?(&rnu&&v:relnum?v:relnum:v:lnum):''} ]],
    git_sign and ("%#" .. git_sign.texthl .. "#" .. git_sign.text .. "%*") or "  ",
  }
  return table.concat(components, "")
end

-- vim.opt.statuscolumn = [[%!v:lua.statusline.column()]]

vim.opt.statusline = [[%!v:lua.statusline.get()]]

return M
