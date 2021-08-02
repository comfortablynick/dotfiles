local api = vim.api

-- Set completeopt to have a better completion experience
vim.opt.completeopt = { "menuone", "noselect" }

-- Avoid showing message extra message when using completion
vim.opt.shortmess:append "c"

local imap = function(key, result, opts)
  api.nvim_buf_set_keymap(0, "i", key, result, opts or { silent = true })
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
  if compe == nil then
    return
  end
  local bufnr = api.nvim_get_current_buf()
  local complete_exclude_fts = { "clap_input", "qf", "floaterm", "" }

  -- Don't load completion
  if compe == nil or vim.tbl_contains(complete_exclude_fts, vim.bo[bufnr].filetype) then
    return
  end

  -- require"config.snippets"
  require "config.snips"

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
      calc = true,
      path = true,
      buffer = { menu = labels.Buffer },
      spell = true,
      nvim_lsp = true,
      nvim_lua = true,
      tags = false,
      treesitter = false, -- {menu = labels.Treesitter},
      -- snippets
      luasnip = true,
      vsnip = false,
      ultisnips = {menu = labels.UltiSnips},
      snippets_nvim = false, -- {menu = labels["snippets.nvim"]},
    },
  }, bufnr)

  imap("<C-Space>", "compe#complete()", { expr = true, silent = true })
  if vim.bo.filetype ~= "markdown" then
    imap("<Tab>", "v:lua.smart_tab()", { expr = true })
    imap("<S-Tab>", "v:lua.smart_s_tab()", { expr = true })
  end
  imap("<CR>", "compe#confirm('<CR>')", { expr = true, silent = true })
  imap("<C-e>", "compe#close('<C-e>')", { expr = true, silent = true })
end

return { init = init }
