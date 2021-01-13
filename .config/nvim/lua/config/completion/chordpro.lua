local M = {}
local fuzzy_score = require"completion.util".fuzzy_score
local match = require"completion.matching"

local function get_completion_items(prefix)
  local complete_items = {}
  -- define your total completion items
  local items = {"[A]", "[B]", "[C]", "[A7sus4]",}
  -- find matches items and put them into complete_items
  for _, item in ipairs(items) do
    -- score_func is a fuzzy match scoring function
    -- if you're not familiar with complete_items, see `:h complete-items`
    table.insert(complete_items, {
      word = item,
      kind = "m",
      icase = 1,
      dup = 1,
      empty = 1,
      menu = "[Chord]",
    })
  end
  return complete_items
end

-- local get_completion_items = function(prefix)
--   local items = vim.api.nvim_call_function("CompleteChords", {0, prefix})
--   return items
-- end

local getCompletionItems = function(prefix)
  local items = vim.fn.Chords()
  local complete_items = {}
  if prefix == "" then return complete_items end
  for _, word in ipairs(items) do
    if vim.startswith(word:lower(), prefix:lower()) then
      match.matching(complete_items, prefix, {
        word = word,
        kind = "m",
        dup = 1,
        empty = 1,
        icase = 1,
        menu = "[Chord]",
      })
    end
  end
  return complete_items
end

-- M.complete_item = {item = getCompletionItems}
M.complete_item = {item = get_completion_items}

return M
