local installed, gruvbox = pcall(require, "gruvbox")

if not installed then
  return
end

return gruvbox.setup {
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "", -- can be "hard", "soft" or empty string
  dim_inactive = false,
  palette_overrides = { dark0_hard = "#0E1018" },
  overrides = {
    -- Comment = { fg = "#736B62", italic = true, bold = false },
    Define = { link = "GruvboxPurple" },
    Macro = { link = "GruvboxPurple" },
    ["@constant.builtin"] = { link = "GruvboxPurple" },
    ["@storageclass.lifetime"] = { link = "GruvboxAqua" },
    ["@text.note"] = { link = "TODO" },
    ["@namespace.latex"] = { link = "Include" },
    ["@namespace.rust"] = { link = "Include" },
    ContextVt = { fg = "#878788" },
    DiagnosticVirtualTextWarn = { fg = "#dfaf87" },
    -- fold
    Folded = { fg = "#fe8019", bg = "#3c3836", italic = true },
    CursorLineNr = { fg = "#fabd2f", bg = "" },
    GruvboxOrangeSign = { fg = "#dfaf87", bg = "" },
    GruvboxAquaSign = { fg = "#8EC07C", bg = "" },
    GruvboxGreenSign = { fg = "#b8bb26", bg = "" },
    GruvboxRedSign = { fg = "#fb4934", bg = "" },
    GruvboxBlueSign = { fg = "#83a598", bg = "" },
    WilderMenu = { fg = "#ebdbb2", bg = "" },
    WilderAccent = { fg = "#f4468f", bg = "" },
  },
}
