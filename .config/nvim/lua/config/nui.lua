local Popup = nvim.packrequire("nui.nvim", "nui.popup")

local popup = Popup {
  border = {
    style = "rounded",
    highlight = "FloatBorder",
  },
  position = "50%",
  size = {
    width = "80%",
    height = "60%",
  },
  opacity = 1,
}

return { popup = popup }
