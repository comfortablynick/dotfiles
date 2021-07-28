local installed, autopairs = pcall(require, "nvim-autopairs")

local init = function()
  if not installed then
    return nil
  end
  autopairs.setup { disable_filetype = { "clap_input", "qf" }, ignored_line_pattern = "^%s*$" }
end

return { init = init }
