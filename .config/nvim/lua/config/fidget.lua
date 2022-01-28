local installed, fidget = pcall(require, "fidget")

if not installed then
  return
end

fidget.setup {}
