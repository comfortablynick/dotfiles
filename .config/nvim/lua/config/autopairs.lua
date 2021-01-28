local autopairs = nvim.packrequire("nvim-autopairs")

local init = function()
  if not autopairs then return end
  autopairs.setup{disable_filetype = {"clap_input", "qf"}, ignored_line_pattern = "^%s*$"}
end

return {init = init}
