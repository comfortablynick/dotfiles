local M = {}

local text_complete = {
  {complete_items = {"buffers"}},
  {complete_items = {"path"}, triggered_only = {"/"}},
}

local default_complete = {
  default = {
    {complete_items = {"lsp", "snippet", "UltiSnips"}},
    {complete_items = {"buffer", "buffers"}},
    {complete_items = {"path"}, triggered_only = {"/"}},
  },
  string = text_complete,
  comment = text_complete,
}

-- Insert complete_items entry and return copy of table
local add_complete_item = function(item, pos)
  local copy = vim.deepcopy(default_complete)
  table.insert(copy.default, pos or #copy.default + 1, {complete_items = item})
  return copy
end

function M.init()
  require"config.snippets"

  local completion = vim.F.npcall(require, "completion")
  if completion then
    -- Custom sources
    completion.addCompletionSource("fish",
                                   require"config.completion.fish".complete_item)
    -- Build complete chain
    local complete_chain = {
      default = default_complete,
      fish = add_complete_item({"fish"}, 1),
    }
    completion.on_attach{chain_complete_list = complete_chain}
  end
end

return M
