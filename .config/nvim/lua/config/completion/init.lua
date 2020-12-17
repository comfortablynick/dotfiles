local api = vim.api
local M = {}

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noinsert,noselect"

-- Avoid showing message extra message when using completion
vim.cmd[[set shortmess+=c]]

vim.g.completion_enable_snippet = "snippets.nvim"
vim.g.completion_enable_auto_paren = 1
vim.g.completion_enable_auto_hover = 1
vim.g.completion_enable_auto_signature = 1
vim.g.completion_auto_change_source = 1

local text_complete = {
  {complete_items = {"path"}, triggered_only = {"/"}},
  {complete_items = {"buffer", "buffers"}},
}

local default_complete = {
  default = {
    {complete_items = {"path"}, triggered_only = {"/"}},
    {complete_items = {"lsp"}},
    {complete_items = {"snippet", "UltiSnips"}},
    {complete_items = {"buffer", "buffers"}},
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

local mapper = function(key, result)
  api.nvim_buf_set_keymap(0, "i", key, result, {silent = true})
end

M.init = function()
  -- Don't load completion-nvim for these buffers
  local complete_exclude_fts = {"clap_input"}

  if vim.tbl_contains(complete_exclude_fts, vim.bo.filetype) then return end

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

  mapper("<C-h>", "<Plug>(completion_next_source)")
  mapper("<C-k>", "<Plug>(completion_prev_source)")
  mapper("<Tab>", "<Plug>(completion_smart_tab)")
  mapper("<S-Tab>", "<Plug>(completion_smart_s_tab)")
end

return M
