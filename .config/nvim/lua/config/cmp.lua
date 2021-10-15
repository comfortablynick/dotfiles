-- Setup nvim-cmp completion plugin
local cmp_installed, cmp = pcall(require, "cmp")

if not cmp_installed then
  return
end

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

cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm { select = true },
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
  sources = {
    { name = "nvim_lsp" },
    { name = "ultisnips" },
    { name = "buffer" },
  },
}

local cmp_lsp_installed, cmp_lsp = pcall(require, "cmp_nvim_lsp")

if not cmp_lsp_installed then
  return
end

return cmp_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())