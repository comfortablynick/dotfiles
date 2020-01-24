-- Utility functions, not necessarily integral to vim
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

function M.bench(iters, cb)
    assert(cb, "Must provide callback to benchmark")
    local start_time = M.epoch_ms()
    iters = iters or 100
    for _ = 1, iters do cb() end
    end_time = M.epoch_ms()
    elapsed_time = end_time - start_time
    p("time elapsed for %d runs: %d ms", iters, elapsed_time)
end

---
-- Error handling
---

function M.npcall(fn, ...)
    local ok_or_nil = function(status, ...)
        if not status then return end
        return ...
    end
    return ok_or_nil(pcall(fn, ...))
end

return M
