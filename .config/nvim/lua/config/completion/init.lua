local util = require"util"
local M = {}

local text_complete = {
  {complete_items = {"buffers"}},
  {complete_items = {"path"}, triggered_only = {"/"}},
}

local complete_chain = {
  default = {
    {complete_items = {"lsp", "snippet", "UltiSnips"}},
    {complete_items = {"buffer", "buffers"}},
    {complete_items = {"fish"}},
    {complete_items = {"path"}, triggered_only = {"/"}},
  },
  string = text_complete,
  comment = text_complete,
}

function M.init()
  require"config.snippets"

  local completion = util.npcall(require, "completion")
  if completion then
    completion.addCompletionSource("fish",
                                   require"config/completion/fish".complete_item)
    completion.on_attach{chain_complete_list = complete_chain}
  end
end

return M
