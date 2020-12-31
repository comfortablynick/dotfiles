" Minimal vimrc
" Use to debug config
scriptencoding utf-8

" vint: -ProhibitSetNoCompatible
set nocompatible
set runtimepath=$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/vim-test
let s:pack_path = '~/vim-test'
let &packpath = &runtimepath..','..s:pack_path

" luafile $XDG_CONFIG_HOME/nvim/lua/config/completion/init.lua

" Test lsp config
if 1
    let s:opt_dir = s:pack_path..'/pack/test/opt'
    let s:plugins = [
        \ 'neovim/nvim-lspconfig',
        \ 'nvim-lua/completion-nvim',
        \ 'norcalli/snippets.nvim',
        \ 'SirVer/ultisnips',
        \ ]

    for s:plug in s:plugins
        let s:repo = split(s:plug, '/')[-1]
        let s:dir = s:opt_dir ..'/'.. s:repo
        if !isdirectory(expand(s:dir))
            echo 'Downloading' s:dir
            call system(printf('git clone https://github.com/%s %s', s:plug, s:dir))
        endif
    endfor

    lua <<
    local api = vim.api
    vim.cmd[[packadd nvim-lspconfig]]
    vim.cmd[[packadd completion-nvim]]
    vim.cmd[[packadd ultisnips]]
    vim.cmd[[packadd snippets.nvim]]

    local snip = vim.F.npcall(require, "snippets")

    local chain_complete_list = {
      default = {
        {complete_items = {'lsp', 'snippets.nvim'}},
        {complete_items = {'path'}, triggered_only = {'/'}},
        {complete_items = {'buffers'}},
      },
      string = {
        {complete_items = {'path'}, triggered_only = {'/'}},
      },
      comment = {},
    }

    completion_on_attach_cb = function()
      require'completion'.on_attach{
        enable_auto_paren = 0,
        enable_auto_hover = 1,
        enable_auto_signature = 1,
        auto_change_source = 1,
        enable_snippet = "snippets.nvim",
      }

      local imaps = {
        ["<Tab>"] = "<Plug>(completion_smart_tab)",
        ["<S-Tab>"] = "<Plug>(completion_smart_s_tab)",
      }

      for lhs, rhs in pairs(imaps) do
        api.nvim_buf_set_keymap(0, "i", lhs, rhs, {})
      end
    end

    local on_attach_cb = function(client)
      local map_opts = {noremap = true, silent = true}
      local nmaps = {
        [";d"] = "<Cmd>lua vim.lsp.buf.declaration()<CR>",
        ["gd"] = "<Cmd>lua vim.lsp.buf.definition()<CR>",
        ["gh"] = "<Cmd>lua vim.lsp.buf.hover()<CR>",
        ["gi"] = "<Cmd>lua vim.lsp.buf.implementation()<CR>",
        [";s"] = "<Cmd>lua vim.lsp.buf.signature_help()<CR>",
        [";a"] = "<Cmd>lua vim.lsp.buf.code_action()<CR>",
        ["gt"] = "<Cmd>lua vim.lsp.buf.type_definition()<CR>",
        ["gr"] = "<Cmd>lua vim.lsp.buf.references()<CR>",
        ["gld"] = "<Cmd>lua vim.lsp.util.show_line_diagnostics()<CR>",
        ["<F2>"] = "<Cmd>lua vim.lsp.buf.rename()<CR>",
      }

      for lhs, rhs in pairs(nmaps) do
        api.nvim_buf_set_keymap(0, "n", lhs, rhs, map_opts)
      end
    end

    require'lspconfig'.sumneko_lua.setup{on_attach = on_attach_cb}
    require'lspconfig'.vimls.setup{on_attach = on_attach_cb}
    require'lspconfig'.efm.setup{
      on_attach = on_attach_cb,
      filetypes = {
          "lua", "vim", "sh", "python", "javascript", "markdown", "yaml"
      },
      init_options = {documentFormatting = true},
    }
    -- require'lspconfig'.diagnosticls.setup{
    --       on_attach = on_attach_cb,
    --       filetypes = {"lua", "vim", "sh", "python"},
    --       init_options = {
    --         filetypes = {vim = "vint", sh = "shellcheck", python = "pydocstyle"},
    --         linters = {
    --           vint = {
    --             command = "vint",
    --             debounce = 100,
    --             args = {"--enable-neovim", "-"},
    --             offsetLine = 0,
    --             offsetColumn = 0,
    --             sourceName = "vint",
    --             formatLines = 1,
    --             formatPattern = {
    --               "[^:]+:(\\d+):(\\d+):\\s*(.*)(\\r|\\n)*$",
    --               {line = 1, column = 2, message = 3},
    --             },
    --           },
    --         },
    --       },
    --     }
.
endif

augroup minirc
    autocmd!
    autocmd BufEnter * lua completion_on_attach_cb()
augroup END

set completeopt=menuone,noinsert,noselect
set shortmess+=c
"
" filetype plugin indent on
" syntax enable

" Convenience maps
" Remap ; to :
nnoremap ; :
xnoremap ; :
onoremap ; :
nnoremap g: g;
nnoremap @; @:
nnoremap q; q:
xnoremap q; q:
inoremap kj <Esc>`^
