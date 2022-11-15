-- Setup nvim-cmp completion plugin
local cmp_installed, cmp = pcall(require, "cmp")

if not cmp_installed then
  return
end

local kind = cmp.lsp.CompletionItemKind
local api = vim.api

local has_words_before = function()
  if vim.bo.buftype == "prompt" then
    return false
  end
  local line, col = unpack(api.nvim_win_get_cursor(0))
  return col ~= 0 and api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

-- Equivalent to viml feedkeys()
local feedkeys = function(key, mode)
  api.nvim_feedkeys(api.nvim_replace_termcodes(key, true, true, true), mode or "m", true)
end

-- stylua: ignore
local lsp_symbols = {
  Text            = "   Text ",
  Method          = "   Method",
  Function        = "   Function",
  Constructor     = "   Constructor",
  Field           = " ﴲ  Field",
  Variable        = "[] Variable",
  Class           = "   Class",
  Interface       = " ﰮ  Interface",
  Module          = "   Module",
  Property        = " 襁 Property",
  Unit            = "   Unit",
  Value           = "   Value",
  Enum            = " 練 Enum",
  Keyword         = "   Keyword",
  Snippet         = "   Snippet",
  Color           = "   Color",
  File            = "   File",
  Reference       = "   Reference",
  Folder          = "   Folder",
  EnumMember      = "   EnumMember",
  Constant        = " ﲀ  Constant",
  Struct          = " ﳤ  Struct",
  Event           = "   Event",
  Operator        = "   Operator",
  TypeParameter   = "   TypeParameter",
}

cmp.setup {
  enabled = function()
    local ok = true
    ok = ok and vim.bo.ft ~= "clap_input"
    ok = ok and vim.bo.bt ~= "prompt"
    return ok
  end,
  sources = {
    { name = "nvim_lsp" },
    { name = "ultisnips", keyword_length = 2 },
    { name = "buffer" },
    { name = "path" },
  },
  mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm { select = false },
    -- ["<CR>"] = cmp.mapping(function()
    --   if cmp.visible() then
    --     cmp.mapping.confirm { select = false }
    --   else
    --     require("pairs.enter").type()
    --   end
    -- end),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
        feedkeys "<Esc>:call UltiSnips#JumpForwards()<CR>"
      elseif has_words_before() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
        return feedkeys "<C-R>=UltiSnips#JumpBackwards()<CR>"
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  },
  formatting = {
    format = function(entry, item)
      item.kind = lsp_symbols[item.kind]
      item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        ultisnips = "[UltiSnips]",
        path = "[Path]",
      })[entry.source.name]

      return item
    end,
  },
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
}

-- cmp.event:on("confirm_done", function(event)
--   local item = event.entry:get_completion_item()
--   local parensDisabled = item.data and item.data.funcParensDisabled or false
--   if not parensDisabled and (item.kind == kind.Method or item.kind == kind.Function) then
--     require("pairs.bracket").type_left("(")
--   end
-- end)

local cmp_lsp_installed, cmp_lsp = pcall(require, "cmp_nvim_lsp")

if not cmp_lsp_installed then
  return
end

return cmp_lsp.default_capabilities()
