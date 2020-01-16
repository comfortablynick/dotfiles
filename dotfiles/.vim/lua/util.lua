-- Utility functions, not necessarily vim specific
local M = {}

function M.humanize_bytes(size)
    local div = 1024
    if size < div then return tostring(size) end
    for _, unit in ipairs({"", "k", "M", "G", "T", "P", "E", "Z"}) do
        if size < div then return string.format("%.1f%s", size, unit) end
        size = size / div
    end
end

return M
