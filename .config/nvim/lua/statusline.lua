local api = vim.api
local uv = vim.loop
local getbufvar = api.nvim_buf_get_var
local getbufopt = api.nvim_buf_get_option
local winbufnr = api.nvim_win_get_buf
local winwidth = api.nvim_win_get_width
local exists = vim.fn.exists
local util = require"util"
local npcall = vim.F.npcall
local nvim = require"helpers"
sl = {}

-- Local vars {{{1
-- Vim global settings {{{2
-- vim.g.lightline_use_lua = 1
vim.g.LL_pl = vim.g.LL_pl or 0
vim.g.LL_nf = vim.g.LL_nf or 0

-- Script globals {{{2
local vars = { -- {{{2
  min_width = 90,
  med_width = 140,
  max_width = 200,
  use_pl_fonts = vim.g.LL_pl,
  use_nerd_fonts = vim.g.LL_nf,
  glyphs = {
    sep = "┊",
    line_no = "",
    vcs = vim.g.LL_nf ~= 1 and "" or " ",
    branch = "",
    line = "☰",
    read_only = " ",
    modified = " ●",
    func = "ƒ ",
    linter_checking = vim.g.LL_nf ~= 1 and "..." or "\u{f110}",
    linter_warnings = vim.g.LL_nf ~= 1 and "•" or "\u{f071}",
    linter_errors = vim.g.LL_nf ~= 1 and "✘" or "\u{f05e}",
    linter_ok = "",
    lvimrc = [[Ⓛ ]],
    -- lvimrc = "⚑",
    -- lvimrc = "ʟʀc",
  },
}

-- List of plugins/non-files for special handling
-- Key: filetype
-- Value: special mode (set to `false` to skip setting mode)
local special_filetypes = { -- {{{2
  nerdtree = "NERD",
  netrw = "NETRW",
  defx = "DEFX",
  vista = "VISTA",
  tagbar = "TAGS",
  undotree = "UNDO",
  qf = "",
  ["coc-explorer"] = "EXPLORER",
  ["output=///info"] = "COC-INFO",
  vimfiler = "FILER",
  minpac = "PACK",
  packager = "PACK",
  fugitive = "FUGITIVE",
  startify = "STARTIFY",
  help = "HELP",
}

-- Utility functions {{{1
-- lpad/rpad {{{2
local lpad = function(s) return tostring(s) ~= "" and " " .. s or "" end
local rpad = function(s) return tostring(s) ~= "" and s .. " " or "" end

-- Component Functions {{{1
function sl.is_not_file(bufnr) -- {{{2
  local ft = getbufopt(bufnr, "filetype")
  return special_filetypes[ft] ~= nil or ft == ""
end

function sl.line_info() -- {{{2
  if sl.is_not_file() then return "" end
  local line_ct = api.nvim_buf_line_count(0)
  local pos = api.nvim_win_get_cursor(0)
  local row = pos[1]
  local col = pos[2] + 1
  local row_pos = function()
    local max_digits = string.len(tostring(line_ct))
    return string.format("%" .. max_digits .. "d/%" .. max_digits .. "d", row,
                         line_ct)
  end
  return string.format("%3d%% %s %s %s :%3d", row * 100 / line_ct,
                       vars.glyphs.line, row_pos(), vars.glyphs.line_no, col)
end

function sl.bufnr(winid) -- {{{2
  local bufnr = winbufnr(winid)
  if winwidth(winid) < vars.min_width then return "" end
  local buflisted = getbufopt(bufnr, "buflisted")
  return buflisted and "[" .. bufnr .. "]" or ""
end

function sl.file_type(winid) -- {{{2
  local winw = winwidth(winid)
  if winw <= vars.med_width then return "" end
  local bufnr = winbufnr(winid)
  local ft_glyph = winw > vars.med_width and
                     npcall(function()
      return vim.fn.WebDevIconsGetFileTypeSymbol()
    end) or ""
  return rpad(ft_glyph) .. getbufopt(bufnr, "filetype")
end

function sl.python_venv(bufnr) -- {{{2
  local venv = not vim.g.did_coc_loaded and
                 (getbufopt(bufnr, "filetype") == "python" and
                   string.basename(vim.env.VIRTUAL_ENV)) or ""
  return venv ~= "" and "(" .. venv .. ")" or ""
end

function sl.file_format(winid) -- {{{2
  local bufnr = winbufnr(winid)
  local ff = getbufopt(bufnr, "fileformat")
  if ff == "unix" then return "" end
  local winw = winwidth(winid)
  local ff_glyph = winw > vars.med_width and
                     npcall(function()
      return vim.fn.WebDevIconsGetFileFormatSymbol()
    end) or ""
  return ff .. lpad(ff_glyph)
end

function sl.file_size(bufnr) -- {{{2
  local stat = uv.fs_stat(api.nvim_buf_get_name(bufnr))
  local size = stat ~= nil and stat.size or 0
  return size > 0 and util.humanize_bytes(size) or ""
end

function sl.file_name(winid) -- {{{2
  local bufnr = winbufnr(winid)
  local path = vim.fn.fnamemodify(api.nvim_buf_get_name(bufnr), ":~:.")
  if winwidth(winid) < vars.min_width then
    return vim.fn.pathshorten(path)
  else
    return path
  end
end

function sl.read_only(bufnr) -- {{{2
  return getbufopt(bufnr, "readonly") and vars.glyphs.read_only or ""
end

function sl.modified(bufnr) -- {{{2
  return getbufopt(bufnr, "modified") and vars.glyphs.modified or ""
end

function sl.local_vimrc(bufnr) -- {{{2
  local lrc = npcall(getbufvar, bufnr, "localrc_loaded")
  return lrc and lrc > 0 and vars.glyphs.lvimrc or ""
end

function sl.file_encoding(bufnr) -- {{{2
  local enc = getbufopt(bufnr, "fileencoding")
  return enc ~= "utf-8" and enc or ""
end

function sl.tab_name() -- {{{2
  return sl.is_not_file() and "" or sl.file_name()
end

function sl.git_summary(bufnr) -- {{{2
  -- Look for git hunk summary in this order:
  -- 1. coc-git
  -- 2. gitgutter
  -- 3. signify
  if exists("b:coc_git_status") == 1 then
    return getbufvar(bufnr, "coc_git_status")
  end
  local hunks = (function()
    -- return npcall(vim.fn["gitgutter#hunk#summary"], bufnr) or
    return npcall(vim.fn.GitGutterGetHunkSummary) or
             npcall(vim.fn["sy#repo#get_stats"]) or {0, 0, 0}
  end)()
  local added = hunks[1] and hunks[1] ~= 0 and "+" .. hunks[1] .. " " or ""
  local changed = hunks[2] and hunks[2] ~= 0 and "~" .. hunks[2] .. " " or ""
  local deleted = hunks[3] and hunks[3] ~= 0 and "-" .. hunks[3] .. " " or ""
  return added .. changed .. deleted
end

function sl.git_branch() -- {{{2
  if vim.fn.exists("g:coc_git_status") == 1 then
    return vim.g.coc_git_status
  end
  local head = npcall(vim.fn.FugitiveHead)
  return head ~= "" and head or ""
end

function sl.git_status(winid) -- {{{2
  if winwidth(winid) > vars.min_width then
    local branch = sl.git_branch()
    local hunks = sl.git_summary(winbufnr(winid))
    return branch ~= "" and hunks .. branch:gsub("master", "") .. vars.glyphs.branch or ""
  end
end

function sl.coc_status(winid) -- {{{2
  if winwidth(winid) < vars.min_width then return "" end
  if vim.fn.exists("g:coc_status") == 1 then
    local st = vim.g.coc_status
    return st and st
  end
  return ""
end

function sl.lsp_status() -- {{{2
  return vim.lsp.buf.server_ready() and "LSP" or ""
end

function sl.job_status(winid) -- {{{2
  if winwidth(winid) < vars.min_width then return "" end
  if vim.fn.exists("g:asyncrun_status") == 1 then
    local st = vim.g.asyncrun_status
    if st ~= "" then return "Job: " .. st end
  end
  return ""
end

function sl.current_tag(winid) -- {{{2
  if winwidth(winid) < vars.max_width then return "" end
  local bufnr = winbufnr(winid)
  local coc_tag = (function()
    return vim.fn.exists("b:coc_current_function") == 1 and
             getbufvar(bufnr, "coc_current_function") or ""
  end)()
  local tagbar_tag = function()
    if vim.fn.exists("g:loaded_tagbar") ~= 1 then vim.cmd("packadd tagbar") end
    return vim.fn["tagbar#currenttag"]("%s", "", "f")
  end
  -- return coc_tag or tagbar_tag() or ""
  return coc_tag ~= "" and coc_tag or tagbar_tag() or ""
end

function sl.linter_errors(winid) -- {{{2
  local bufnr = winbufnr(winid)
  local coc_error_ct = function()
    if vim.fn.exists("b:coc_diagnostic_info") ~= 1 then return 0 end
    local info = getbufvar(bufnr, "coc_diagnostic_info")
    return info.error
  end
  local ale_error_ct = function()
    local counts = npcall(vim.fn["ale#statusline#Count"], bufnr)
    return not not counts and counts.error + counts.style_error or 0
  end
  local lsp_error_ct = vim.lsp.util.buf_diagnostics_count("Error") or 0
  local error_ct = coc_error_ct() + ale_error_ct() + lsp_error_ct
  return error_ct > 0 and
           string.format("%s %d", vars.glyphs.linter_errors, error_ct) or ""
end

function sl.linter_warnings(winid) -- {{{2
  local bufnr = winbufnr(winid)
  local coc_warning_ct = function()
    if vim.fn.exists("b:coc_diagnostic_info") ~= 1 then return 0 end
    local info = getbufvar(bufnr, "coc_diagnostic_info")
    return info.warning
  end
  local ale_warning_ct = function()
    local counts = npcall(vim.fn["ale#statusline#Count"], bufnr)
    return not not counts and counts.warning + counts.style_warning or 0
  end
  local lsp_warning_ct = vim.lsp.util.buf_diagnostics_count("Warning") or 0
  local warning_ct = coc_warning_ct() + ale_warning_ct() + lsp_warning_ct
  return warning_ct > 0 and
           string.format("%s %d", vars.glyphs.linter_warnings, warning_ct) or ""
end

-- Main functions {{{1
function sl.statusline(winid) -- {{{2
  local bufnr = api.nvim_win_get_buf(winid)
  local active = api.nvim_get_current_win() == winid
  local default_status = "%<%f %h%m%r%"
  local inactive_status = " %n %<%f %h%m%r%"

  if sl.is_not_file(bufnr) then
    return default_status
  elseif not active then
    return inactive_status
  end

  local left = {
    "%( %{v:lua.sl.bufnr(" .. winid .. ")}%)",
    "%( %h%w%)",
    "%( %{v:lua.sl.file_name(" .. winid .. ")}%)",
    "%<",
    "%( %m%r%)",
    "%(  %{v:lua.sl.linter_errors(" .. winid .. ")} %{v:lua.sl.linter_warnings(" ..
      winid .. ")}%)",
  }
  local right = {
    "%( %{v:lua.sl.lsp_status()} " .. vars.glyphs.sep .. "%)",
    "%( %{v:lua.sl.coc_status(" .. winid .. ")} " .. vars.glyphs.sep .. "%)",
    "%( %{v:lua.sl.git_status(" .. winid .. ")} " .. vars.glyphs.sep .. "%)",
    "%( %{v:lua.sl.file_type(" .. winid .. ")} " .. vars.glyphs.sep .. "%)",
    "%( %l,%c%) %4(%p%% %)",
  }
  return table.concat(left) .. "%=" .. table.concat(right)
end

function sl.set_statusline() -- {{{2
  api.nvim_win_set_option(0, "statusline", sl.statusline())
end

function sl.refresh() -- {{{2
  for _, win in ipairs(api.nvim_list_wins()) do
    api.nvim_win_set_option(win, "statusline",
                            "%!v:lua.sl.statusline(" .. win .. ")")
  end
end

function sl.init() -- {{{2
  vim.g.statusline_set = 1
  local set_statusline_events =
    { -- events where `setlocal statusline` would be called
      "WinEnter",
      "BufWinEnter",
      "VimEnter",
      "ColorScheme",
    }

  local set_statusline_user_events = {"GitGutter", "Startified", "CocNvimInit"}

  local set_statusline_command = "lua sl.refresh()"
  local augroups = {
    statusline = {
      {table.concat(set_statusline_events, ","), "*", set_statusline_command},
      {
        "User ",
        table.concat(set_statusline_user_events, ","),
        set_statusline_command,
      },
    },
  }

  nvim.create_augroups(augroups)
end
-- Tests {{{1
-- Benchmarks {{{2
-- local runs = 1000
-- require'util'.bench(runs, sl.git_status)
-- require'util'.bench(runs, vim.fn.LL_GitStatus)
-- vim:fdm=marker fdl=1:
