local api = vim.api
local M = {}

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noinsert,noselect"

-- Avoid showing message extra message when using completion
vim.opt.shortmess:append "c"

-- local customize_lsp_label = {
--   Function = " [function]",
--   Method = " [method]",
--   Reference = " [reference]",
--   Enum = " [enum]",
--   Field = "ﰠ [field]",
--   Keyword = " [key]",
--   Variable = " [variable]",
--   Folder = " [folder]",
--   Snippet = " [snippet]",
--   Operator = " [operator]",
--   Module = " [module]",
--   Text = "ﮜ [text]",
--   Class = " [class]",
--   Interface = " [interface]",
-- }
--
local customize_lsp_label = {
  Buffers = " [buffers]",
  Class = " [class]",
  Color = " [color]",
  Enum = " [enum]",
  Field = "פּ [field]",
  Folder = " [folder]",
  Function = " [function]",
  Interface = " [interface]",
  Keyword = " [keyword]",
  Method = " [method]",
  Module = " [module]",
  Operator = " [operator]",
  Property = " [property]",
  Reference = " [reference]",
  Snippet = " [snippet]",
  Struct = "פּ [struct]",
  Text = " [text]",
  TypeParameter = " [type]",
  UltiSnips = " [UltiSnips]",
  Unit = " [unit]",
  Value = " [value]",
  Variable = " [variable]",
  ["snippets.nvim"] = " [nsnip]",
}

-- TODO: how does this work?
local items_priority = {
  Field = 5,
  Function = 7,
  Module = 7,
  Variables = 7,
  Method = 10,
  Interfaces = 5,
  Constant = 5,
  Class = 5,
  Keyword = 4,
  UltiSnips = 2,
  ["snippets.nvim"] = 1,
  Buffers = 1,
  File = 0,
}

local text_complete = {
  { complete_items = { "path" }, triggered_only = { "/" } },
  { complete_items = { "buffers" } },
}

local default_complete = {
  default = {
    { complete_items = { "path" }, triggered_only = { "/" } },
    { complete_items = { "lsp" } },
    { complete_items = { "snippets.nvim", "UltiSnips" } },
    { complete_items = { "buffers" } },
  },
  string = text_complete,
  comment = text_complete,
}

-- Insert complete_items entry and return copy of table
local add_complete_item = function(item, pos)
  local copy = vim.deepcopy(default_complete)
  table.insert(copy.default, pos or #copy.default + 1, { complete_items = item })
  return copy
end

local imap = function(key, result, opts)
  api.nvim_buf_set_keymap(0, "i", key, result, opts or { silent = true })
end

M.lsp_labels = customize_lsp_label
M.init = function()
  -- Don't load completion-nvim for these buffers
  local complete_exclude_fts = { "clap_input", "qf" }

  if vim.tbl_contains(complete_exclude_fts, vim.bo.filetype) or vim.bo.filetype == "" then
    return
  end

  require "config.snippets"

  local completion = vim.F.npcall(require, "completion")
  if not completion then
    return
  end

  -- Custom sources
  completion.addCompletionSource("fish", require("config.completion.fish").complete_item)
  completion.addCompletionSource("chordpro", require("config.completion.chordpro").complete_item)

  -- Build complete chain
  local complete_chain = {
    default = default_complete,
    fish = add_complete_item({ "fish" }, 1),
    -- chordpro = add_complete_item({"chordpro"}, 1),
  }

  completion.on_attach {
    chain_complete_list = complete_chain,
    customize_lsp_label = customize_lsp_label,
    -- items_priority = items_priority,
    enable_snippet = "snippets.nvim",
    -- enable_auto_paren = 1,
    enable_auto_hover = 1,
    enable_auto_signature = 1,
    auto_change_source = 1,
    -- matching_strategy_list = {"exact", "substring"},
    matching_smart_case = 1,
    trigger_keyword_length = 1,
    trigger_on_delete = 1,
    -- timer_cycle = 200,
  }

  imap("<C-h>", "<Plug>(completion_next_source)")
  imap("<C-k>", "<Plug>(completion_prev_source)")

  if vim.bo.filetype ~= "markdown" then
    imap("<Tab>", "<Plug>(completion_smart_tab)")
    imap("<S-Tab>", "<Plug>(completion_smart_s_tab)")
  end
end

return M
