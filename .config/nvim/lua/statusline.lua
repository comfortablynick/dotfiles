local api = vim.api
local exists = vim.fn.exists
local util = require"util"
local npcall = util.npcall
local nvim = require"helpers"
local getbufvar = api.nvim_buf_get_var
local getbufopt = api.nvim_buf_get_option
sl = {}

-- Local vars {{{1
-- Vim global settings {{{2
-- vim.g.lightline_use_lua = 1
vim.g.LL_pl = vim.g.LL_pl or 0
vim.g.LL_nf = vim.g.LL_nf or 0

-- Script globals {{{2
local WINWIDTH = api.nvim_win_get_width(0)
local FILENAME = api.nvim_buf_get_name(0)
local vars = { -- {{{2
  min_width = 90,
  med_width = 140,
  max_width = 200,
  use_simple_sep = vim.env.SUB ~= "|" and 0 or 1,
  use_pl_fonts = vim.g.LL_pl,
  use_nerd_fonts = vim.g.LL_nf,
  glyphs = {
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
}

sl.mode_map = {
  n = {"NORMAL", "NRM", "N"},
  niI = {"NORMAL·CMD", "NRM", "N"},
  i = {"INSERT", "INS", "I"},
  ic = {"INSERT", "INS", "I"},
  ix = {"INSERT COMPL", "I·COMPL", "IC"},
  R = {"REPLACE", "REP", "R"},
  v = {"VISUAL", "VIS", "V"},
  V = {"V·LINE", "V·LN", "V·L"},
  ["\x16"] = {"V·BLOCK", "V·BL", "V·B"},
  c = {"COMMAND", "CMD", "C"},
  s = {"SELECT", "SEL", "S"},
  S = {"S·LINE", "S·LN", "S·L"},
  ["<C-s>"] = {"S·BLOCK", "S·BL", "S·B"},
  t = {"TERMINAL", "TERM", "T"},
}

-- Component Functions {{{1
function sl.is_not_file(bufnr) -- {{{2
  local ft = api.nvim_buf_get_option(bufnr, "filetype")
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

function sl.simple_line_info() -- {{{2
  local line_ct = api.nvim_buf_line_count(0)
  local pos = api.nvim_win_get_cursor(0)
  local row = pos[1]
  local col = pos[2] + 1
  return string.format("%d,%d %3d%% ", row, col, row * 100 / line_ct)
end

function sl.bufnr(bufnr) -- {{{2
  local buflisted = api.nvim_buf_get_option(bufnr, "buflisted")
  return buflisted and "[" .. bufnr .. "]" or ""
end

function sl.vim_mode() -- {{{2
  local mode_key = api.nvim_get_mode().mode
  local curr_mode = sl.mode_map[mode_key] or mode_key
  local mode_out = function()
    if WINWIDTH > vars.med_width then return curr_mode[1] end
    if WINWIDTH > vars.min_width then return curr_mode[2] end
    return curr_mode[3]
  end
  -- TODO: is filename ever going to match special_filetypes?
  -- viml: return get(l:special_modes, &filetype, get(l:special_modes, @%, l:mode_out))
  -- return type(special_filetypes[vim.bo.filetype]) == "string" or mode_out()
  return special_filetypes[vim.bo.filetype] or mode_out()
end

function sl.file_type() -- {{{2
  if sl.is_not_file() or WINWIDTH <= vars.med_width then return "" end
  local ft_glyph = WINWIDTH > vars.med_width and
                     npcall(function()
      return " " .. vim.fn.WebDevIconsGetFileTypeSymbol()
    end) or ""
  local python_venv = function()
    local venv = not vim.g.did_coc_loaded and
                   (vim.bo.ft == "python" and
                     string.basename(vim.env.VIRTUAL_ENV)) or ""
    return venv ~= "" and string.format(" (%s)", venv) or ""
  end

  local venv = WINWIDTH > vars.med_width and python_venv() or ""
  return vim.bo.filetype .. ft_glyph .. venv
end

function sl.file_format() -- {{{2
  local ff = vim.bo.fileformat
  if sl.is_not_file() or ff == "unix" then return "" end
  local ff_glyph = WINWIDTH > vars.med_width and
                     npcall(function()
      return " " .. vim.fn.WebDevIconsGetFileFormatSymbol()
    end) or ""
  return ff .. ff_glyph
end

function sl.file_size() -- {{{2
  local stat = vim.loop.fs_stat(FILENAME)
  local size = stat ~= nil and stat.size or 0
  return size > 0 and util.humanize_bytes(size) or ""
end

function sl.file_name(bufnr) -- {{{2
  local path = vim.fn.fnamemodify(api.nvim_buf_get_name(bufnr), ":~:.")
  if WINWIDTH < vars.min_width then
    return vim.fn.pathshorten(path)
  else
    return path
  end
end

function sl.read_only() -- {{{2
  return vim.api.nvim_buf_get_var() and vars.glyphs.read_only or
           ""
end

function sl.modified() -- {{{2
  return not sl.is_not_file() and vim.bo.modified and vars.glyphs.modified or ""
end

function sl.local_vimrc(bufnr) -- {{{2
  local lrc = npcall(api.nvim_buf_get_var, bufnr, "localrc_loaded")
  return lrc and lrc > 0 and vars.glyphs.lvimrc or ""
end

function sl.file_encoding() -- {{{2
  return vim.bo.fileencoding ~= "utf-8" and vim.bo.fileencoding or ""
end

function sl.tab_name() -- {{{2
  return sl.is_not_file() and "" or sl.file_name()
end

function sl.git_summary() -- {{{2
  -- Look for git hunk summary in this order:
  -- 1. coc-git
  -- 2. gitgutter
  -- 3. signify
  if exists("b:coc_git_status") == 1 then
    return " " .. vim.trim(api.nvim_buf_get_var(0, "coc_git_status"))
  end
  local hunks = (function()
    return npcall(vim.fn.GitGutterGetHunkSummary) or
             npcall(vim.fn["sy#repo#get_stats"]) or {0, 0, 0}
  end)()
  local added = not not hunks[1] and hunks[1] ~= 0 and
                  string.format("+%d ", hunks[1]) or ""
  local changed = not not hunks[2] and hunks[2] ~= 0 and
                    string.format("~%d ", hunks[2]) or ""
  local deleted = not not hunks[3] and hunks[3] ~= 0 and
                    string.format("-%d ", hunks[3]) or ""
  return " " .. added .. changed .. deleted
end

function sl.git_branch() -- {{{2
  if vim.fn.exists("g:coc_git_status") == 1 then
    return string.gsub(vim.g.coc_git_status, "master", "")
  end
  local head = npcall(vim.fn.FugitiveHead)
  -- return not not head and vars.glyphs.branch .. " " .. head or ""
  return head ~= "" and vars.glyphs.branch .. " " .. head or ""
end

function sl.git_status() -- {{{2
  if not sl.is_not_file() and WINWIDTH > vars.min_width then
    local branch = sl.git_branch()
    local hunks = sl.git_summary()
    if branch ~= "" then
      return string.format("%s%s%s", vars.glyphs.vcs, branch:gsub("master", ""),
                           hunks)
    end
  end
  return ""
end

function sl.coc_status() -- {{{2
  if WINWIDTH < vars.min_width then return "" end
  if vim.fn.exists("g:coc_status") == 1 then
    local st = vim.g.coc_status
    return st and st
  end
  return ""
end

function sl.job_status() -- {{{2
  if WINWIDTH < vars.min_width then return "" end
  if vim.fn.exists("g:asyncrun_status") == 1 then
    local st = vim.g.asyncrun_status
    if st ~= "" then return "Job: " .. st end
  end
  return ""
end

function sl.current_tag() -- {{{2
  if WINWIDTH < vars.max_width then return "" end
  local coc_tag = (function()
    return vim.fn.exists("b:coc_current_function") == 1 and
             api.nvim_buf_get_var(0, "coc_current_function") or ""
  end)()
  local tagbar_tag = function()
    if vim.fn.exists("g:loaded_tagbar") ~= 1 then vim.cmd("packadd tagbar") end
    return vim.fn["tagbar#currenttag"]("%s", "", "f")
  end
  -- return coc_tag or tagbar_tag() or ""
  return coc_tag ~= "" and coc_tag or tagbar_tag() or ""
end

function sl.linter_errors() -- {{{2
  local coc_error_ct = function()
    if vim.fn.exists("b:coc_diagnostic_info") ~= 1 then return 0 end
    local info = api.nvim_buf_get_var(0, "coc_diagnostic_info")
    return info.error
  end
  local ale_error_ct = function()
    local counts = npcall(vim.fn["ale#statusline#Count"],
                          api.nvim_win_get_buf(0))
    return not not counts and counts.error + counts.style_error or 0
  end
  -- local error_ct = coc_errors > 0 and coc_errors or ale_error_ct()
  local error_ct = coc_error_ct() + ale_error_ct()
  return error_ct > 0 and
           string.format("%s %d", vars.glyphs.linter_errors, error_ct) or ""
end

function sl.linter_warnings() -- {{{2
  local coc_warning_ct = function()
    if vim.fn.exists("b:coc_diagnostic_info") ~= 1 then return 0 end
    local info = api.nvim_buf_get_var(0, "coc_diagnostic_info")
    return info.warning
  end
  local ale_warning_ct = function()
    local counts = npcall(vim.fn["ale#statusline#Count"],
                          api.nvim_win_get_buf(0))
    return not not counts and counts.warning + counts.style_warning or 0
  end
  local warning_ct = coc_warning_ct() + ale_warning_ct()
  return warning_ct > 0 and
           string.format("%s %d", vars.glyphs.linter_warnings, warning_ct) or ""
end



function sl.statusline(winid) -- {{{2
  local win = winid
  local bufnr = api.nvim_win_get_buf(winid)
  local active = api.nvim_get_current_win() == win
  local default_status = "%<%f %h%m%r%"
  local inactive_status = " %n %<%f %h%m%r%"

  if sl.is_not_file(bufnr) then
    return default_status
  elseif not active then
    return inactive_status
  end

  local left = {
    "%( %{v:lua.sl.bufnr(" .. bufnr .. ")}%)",
    "%( %h%w%)",
    "%( %{v:lua.sl.file_name(" .. bufnr .. ")}%)",
    "%<",
    "%( %m%r%)",
    "%(  %{statusline#linter_errors(" .. bufnr .. ")}%)",
    "%( %{statusline#linter_warnings(" .. bufnr .. ")}%)",
    "%( %{statusline#file_type(" .. win .. ")}%)",
  }
  return table.concat(left)
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

-- Statusline init {{{2
function sl.init()
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
-- sl.init()
-- Tests {{{1
-- Benchmarks {{{2
-- local runs = 1000
-- require'util'.bench(runs, sl.git_status)
-- require'util'.bench(runs, vim.fn.LL_GitStatus)
-- vim:fdm=marker fdl=1:
