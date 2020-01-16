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

function M.epoch_ms()
    local s, ns = vim.loop.gettimeofday()
    return s * 1000 + math.floor(ns / 1000)
end

function M.epoch_ns()
    local s, ns = vim.loop.gettimeofday()
    return s * 1000000 + ns
end

return M
