local source = {}

---Return trigger characters for triggering completion (optional).
-- function source:get_trigger_characters()
--   return { "[" }
-- end

---Invoke completion
---@param params cmp.SourceCompletionApiParams
---@param callback fun(response: lsp.CompletionResponse|nil)
source.complete = function(params, callback)
  callback {
    { label = "January" },
    { label = "February" },
    { label = "March" },
    { label = "April" },
    { label = "May" },
    { label = "June" },
    { label = "July" },
    { label = "August" },
    { label = "September" },
    { label = "October" },
    { label = "November" },
    { label = "December" },
  }
end

---Executed after the item was selected.
---@param completion_item lsp.CompletionItem
---@param callback fun(completion_item: lsp.CompletionItem|nil)
source.execute = function(completion_item, callback)
  callback(completion_item)
end

source.new = function()
  return setmetatable({}, { __index = source })
end

return source
