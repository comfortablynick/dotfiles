local api = vim.api

-- Don't load completion-nvim for these buffers
local complete_exclude_fts = {"clap_input"}
if vim.tbl_contains(complete_exclude_fts, vim.bo.filetype) then return end

local text_complete = {
  {complete_items = {"buffers"}},
  {complete_items = {"path"}, triggered_only = {"/"}},
}

local default_complete = {
  default = {
    {complete_items = {"lsp"}},
    {complete_items = {"snippet", "UltiSnips"}},
    {complete_items = {"buffer", "buffers"}},
    -- TODO: Doesn't seem to work
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

local set_maps = function()
  local map_opts = {silent = true}
  api.nvim_set_keymap("i", "<C-h>", "<Plug>(completion_next_source)", map_opts)
  -- api.nvim_set_keymap("i", "<C-k>", "<Plug>(completion_prev_source)", map_opts)
end

local init = function()
  require"config.snippets"

  local completion = vim.F.npcall(require, "completion")
  if not completion then return end
  -- Custom sources
  completion.addCompletionSource("fish",
                                 require"config.completion.fish".complete_item)
  -- Build complete chain
  local complete_chain = {
    default = default_complete,
    fish = add_complete_item({"fish"}, 1),
  }
  completion.on_attach{chain_complete_list = complete_chain}
  set_maps()
end

return init()
