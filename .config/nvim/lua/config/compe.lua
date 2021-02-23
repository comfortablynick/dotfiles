local api = vim.api

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- Avoid showing message extra message when using completion
vim.cmd[[set shortmess+=c]]

local imap = function(key, result, opts)
  api.nvim_buf_set_keymap(0, "i", key, result, opts or {silent = true})
end

vim.lsp.protocol.CompletionItemKind = {
  " [text]",
  " [method]",
  " [function]",
  " [constructor]",
  "ﰠ [field]",
  " [variable]",
  " [class]",
  " [interface]",
  " [module]",
  " [property]",
  " [unit]",
  " [value]",
  " [enum]",
  " [key]",
  "﬌ [snippet]",
  " [color]",
  " [file]",
  " [reference]",
  " [folder]",
  " [enum member]",
  " [constant]",
  " [struct]",
  "⌘ [event]",
  " [operator]",
  "⌂ [type]",
}

local labels = {
  Buffer = " [buffer]",
  -- Class = " [class]",
  -- Color = " [color]",
  -- Enum = " [enum]",
  -- Field = "פּ [field]",
  -- Folder = " [folder]",
  -- Function = " [function]",
  -- Interface = " [interface]",
  -- Keyword = " [keyword]",
  -- Method = " [method]",
  -- Module = " [module]",
  -- Operator = " [operator]",
  -- Property = " [property]",
  -- Reference = " [reference]",
  -- Snippet = " [snippet]",
  -- Struct = "פּ [struct]",
  -- Text = " [text]",
  -- TypeParameter = " [type]",
  UltiSnips = " [UltiSnips]",
  -- Unit = " [unit]",
  -- Value = " [value]",
  -- Variable = " [variable]",
  ["snippets.nvim"] = " [nsnip]",
  Treesitter = "פּ [TS]",
}

local init = function()
  local compe = vim.F.npcall(require, "compe")
  if compe == nil then return end
  local bufnr = api.nvim_get_current_buf()
  local complete_exclude_fts = {"clap_input", "qf", "floaterm", ""}

  -- Don't load completion
  if compe == nil or
    vim.tbl_contains(complete_exclude_fts, vim.bo[bufnr].filetype) then return end

  require"config.snippets"

  compe.setup({
    enabled = true,
    debug = false,
    min_length = 1,
    preselect = "disable", -- 'enable' || 'disable' || 'always',
    source_timeout = 200,
    -- throttle_time = 80,
    -- incomplete_delay = 400,
    allow_prefix_unmatch = false,
    documentation = true,
    source = {
      path = true,
      buffer = {menu = labels.Buffer},
      spell = true,
      ultisnips = {menu = labels.UltiSnips},
      snippets_nvim = {menu = labels["snippets.nvim"]},
      nvim_lsp = true,
      nvim_lua = true,
      treesitter = {menu = labels.Treesitter},
    },
  }, bufnr)

  imap("<C-Space>", "compe#complete()", {expr = true, silent = true})
  if vim.bo.filetype ~= "markdown" then
    imap("<Tab>", "v:lua.smart_tab()", {expr = true})
    imap("<S-Tab>", "v:lua.smart_s_tab()", {expr = true})
  end
  imap("<CR>", "compe#confirm('<CR>')", {expr = true, silent = true})
  imap("<C-e>", "compe#close('<C-e>')", {expr = true, silent = true})
end

local t = function(str)
  return api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col(".") - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
    return true
  else
    return false
  end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.smart_tab = function()
  if vim.fn.pumvisible() == 1 then
    return t"<C-n>"
    -- elseif vim.fn.call("vsnip#available", {1}) == 1 then
    --   return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t"<Tab>"
  else
    return vim.fn["compe#complete"]()
  end
end
_G.smart_s_tab = function()
  if vim.fn.pumvisible() == 1 then
    return t"<C-p>"
    -- elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    --   return t "<Plug>(vsnip-jump-prev)"
  else
    return t"<S-Tab>"
  end
end

return {init = init}
