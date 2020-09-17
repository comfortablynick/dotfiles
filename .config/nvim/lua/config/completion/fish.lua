local api = vim.api
local M = {}

function M.get_completion_items(prefix)
  local items = api.nvim_call_function("fish#Complete",
                                           {0, prefix})
  return items
end

M.complete_item = {item = M.get_completion_items}

return M
