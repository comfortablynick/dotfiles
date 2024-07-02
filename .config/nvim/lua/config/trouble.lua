-- luacheck: no max line length
local installed, trouble = pcall(require, "trouble")
if not installed then
  return
end

trouble.setup {
  modes = {
    diagnostics = {
      mode = "diagnostics",
      preview = {
        type = "split",
        relative = "win",
        position = "right",
        size = 0.3,
      },
    },
  },
}

