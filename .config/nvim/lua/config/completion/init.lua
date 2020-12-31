local api = vim.api
local M = {}

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noinsert,noselect"

-- Avoid showing message extra message when using completion
vim.cmd[[set shortmess+=c]]

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

local utf8 = function(cp)
  if cp < 128 then
    return string.char(cp)
  end
  local s = ""
  local prefix_max = 32
  while true do
    local suffix = cp % 64
    s = string.char(128 + suffix)..s
    cp = (cp - suffix) / 64
    if cp < prefix_max then
      return string.char((256 - (2 * prefix_max)) + cp)..s
    end
    prefix_max = prefix_max / 2
  end
end

local customize_lsp_label = {
  Method = utf8(0xf794) .. ' [method]',
  Function = utf8(0xf794) .. ' [function]',
  Variable = utf8(0xf6a6) .. ' [variable]',
  Field = utf8(0xf6a6) .. ' [field]',
  Class = utf8(0xfb44) .. ' [class]',
  Struct = utf8(0xfb44) .. ' [struct]',
  Interface = utf8(0xf836) .. ' [interface]',
  Module = utf8(0xf668) .. ' [module]',
  Property = utf8(0xf0ad) .. ' [property]',
  Value = utf8(0xf77a) .. ' [value]',
  Enum = utf8(0xf77a) .. ' [enum]',
  Operator = utf8(0xf055) .. ' [operator]',
  Reference = utf8(0xf838) .. ' [reference]',
  Keyword = utf8(0xf80a) .. ' [keyword]',
  Color = utf8(0xe22b) .. ' [color]',
  Unit = utf8(0xe3ce) .. ' [unit]',
  ["snippets.nvim"] = utf8(0xf68e) .. ' [nsnip]',
  UltiSnips = utf8(0xf68e) .. ' [UltiSnips]',
  Snippet = utf8(0xf68e) .. ' [snippet]',
  Text = utf8(0xf52b) .. ' [text]',
  Buffers = utf8(0xf64d) .. ' [buffers]',
  TypeParameter = utf8(0xf635) .. ' [type]',
}

local text_complete = {
  {complete_items = {"path"}, triggered_only = {"/"}},
  {complete_items = {"buffers"}},
}

local default_complete = {
  default = {
    {complete_items = {"path"}, triggered_only = {"/"}},
    {complete_items = {"lsp", "snippets.nvim", "UltiSnips"}},
    {complete_items = {"buffers"}},
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

local mapper = function(key, result, opts)
  api.nvim_buf_set_keymap(0, "i", key, result, opts or {silent = true})
end

M.init = function()
  -- Don't load completion-nvim for these buffers
  local complete_exclude_fts = {"clap_input", "qf"}

  if vim.tbl_contains(complete_exclude_fts, vim.bo.filetype) or vim.bo.filetype ==
    "" then return end

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

  completion.on_attach{
    chain_complete_list = complete_chain,
    customize_lsp_label = customize_lsp_label,
    enable_snippet = "snippets.nvim",
    enable_auto_paren = 0,
    enable_auto_hover = 1,
    enable_auto_signature = 1,
    auto_change_source = 1,
    matching_strategy_list = {"exact"},
    -- matching_strategy_list = {"substring"},
    matching_smart_case = 1,
  }

  mapper("<C-h>", "<Plug>(completion_next_source)")
  mapper("<C-k>", "<Plug>(completion_prev_source)")

  if vim.bo.filetype ~= "markdown" then
    mapper("<Tab>", "<Plug>(completion_smart_tab)")
    mapper("<S-Tab>", "<Plug>(completion_smart_s_tab)")
  end
end

return M
