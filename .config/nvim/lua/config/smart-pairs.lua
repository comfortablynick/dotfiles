local installed, pairs = pcall(require, "pairs")

if not installed then
  return
end

local fb = require "pairs.fallback"

pairs:setup {
  default_opts = {
    ["*"] = { ignore_after = [[\S]] },
  },
  enter = {
    enable_mapping = true,
    enable_cond = function()
      return not require("cmp").visible()
    end,
    enable_fallback = fb.enter,
  },
  indent = {
    ["*"] = 4,
  },
}
