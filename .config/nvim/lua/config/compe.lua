local api = vim.api

-- Set completeopt to have a better completion experience
vim.opt.completeopt = { "menuone", "noselect" }

-- Avoid showing message extra message when using completion
vim.opt.shortmess:append "c"

local imap = function(key, result, opts)
  local def_opts = { silent = true, expr = true }
  api.nvim_buf_set_keymap(0, "i", key, result, vim.deepcopy(def_opts, opts, "force"))
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

-- local labels = {
--   Buffer = " [buffer]",
--   -- Class = " [class]",
--   -- Color = " [color]",
--   -- Enum = " [enum]",
--   -- Field = "פּ [field]",
--   -- Folder = " [folder]",
--   -- Function = " [function]",
--   -- Interface = " [interface]",
--   -- Keyword = " [keyword]",
--   -- Method = " [method]",
--   -- Module = " [module]",
--   -- Operator = " [operator]",
--   -- Property = " [property]",
--   -- Reference = " [reference]",
--   -- Snippet = " [snippet]",
--   -- Struct = "פּ [struct]",
--   -- Text = " [text]",
--   -- TypeParameter = " [type]",
--   UltiSnips = " [UltiSnips]",
--   -- Unit = " [unit]",
--   -- Value = " [value]",
--   -- Variable = " [variable]",
--   ["snippets.nvim"] = " [nsnip]",
--   Treesitter = "פּ [TS]",
-- }

local init = function()
  local installed, compe = pcall(require, "compe")
  if not installed then
    return
  end
  local bufnr = api.nvim_get_current_buf()
  local complete_exclude_fts = { "clap_input", "qf", "floaterm", "" }

  -- Don't load completion
  if compe == nil or vim.tbl_contains(complete_exclude_fts, vim.bo[bufnr].filetype) then
    return
  end

  -- Load ultisnips if needed
  if vim.g.did_plugin_ultisnips == nil then
    vim.cmd [[packadd ultisnips]]
  end

  -- require "config.snips"

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
      calc = false,
      path = true,
      buffer = true,
      spell = { filetypes = { "markdown", "asciidoctor" } },
      nvim_lsp = true,
      nvim_lua = true,
      tags = false,
      treesitter = false,
      -- snippets
      luasnip = true,
      vsnip = false,
      ultisnips = true,
      snippets_nvim = false,
    },
  }, bufnr)

  imap("<C-Space>", "compe#complete()")
  if vim.bo.filetype ~= "markdown" then
    imap("<Tab>", "v:lua.smart_tab()")
    imap("<S-Tab>", "v:lua.smart_s_tab()")
  end
  imap("<CR>", "compe#confirm('<CR>')")
  imap("<C-e>", "compe#close('<C-e>')")
  imap("<C-f>", "compe#scroll({'delta':  4})")
  imap("<C-b>", "compe#scroll({'delta': -4})")
end

return { init = init }
