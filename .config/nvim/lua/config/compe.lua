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
  -- ["snippets.nvim"] = " [nsnip]",
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
    source = {
      path = true,
      buffer = {menu = labels.Buffer},
      spell = true,
      ultisnips = {menu = labels.UltiSnips},
      nvim_lsp = true,
      nvim_lua = true,
    },
  }, bufnr)

  imap("<C-Space>", "compe#complete()", {expr = true, silent = true})
  if vim.bo.filetype ~= "markdown" then
    imap("<Tab>", "<Cmd>lua nvim.smart_tab()<CR>")
    imap("<S-Tab>", "<Cmd>lua nvim.smart_s_tab()<CR>")
  end
  imap("<CR>", "compe#confirm('<CR>')", {expr = true, silent = true})
  imap("<C-e>", "compe#close('<C-e>')", {expr = true, silent = true})
end

return {init = init}
