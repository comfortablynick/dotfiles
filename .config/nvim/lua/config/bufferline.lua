local bufferline = nvim.packrequire("nvim-bufferline.lua", "bufferline")

if not bufferline then
  return
end

bufferline.setup{}
