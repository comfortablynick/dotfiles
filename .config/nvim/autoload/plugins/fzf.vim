if exists('g:loaded_autoload_plugins_fzf') | finish | endif
let g:loaded_autoload_plugins_fzf = 1

function! plugins#fzf#post() abort
    " View maps in any mode
    command! -bang -nargs=1 -complete=customlist,s:map_modes Map call fzf#vim#maps(<q-args>, <bang>0)

    function! s:map_modes(a,l,p) abort
        return [
            \ 'n',
            \ 'i',
            \ 'o',
            \ 'x',
            \ 'v',
            \ 's',
            \ 'c',
            \ 't',
            \ ]
    endfunction

    " Rg with preview window
    "   :Rg  - Start fzf with hidden preview window that can be enabled with "?" key
    "   :Rg! - Start fzf in fullscreen and display the preview window above
    command! -bang -nargs=* Rg call
        \ fzf#vim#grep(
        \ 'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
        \ <bang>0 ? fzf#vim#with_preview('up:60%')
        \         : fzf#vim#with_preview('right:60%:hidden', '?'),
        \ <bang>0
        \ )

    " Ag with preview window
    "   :Ag  - Start fzf with hidden preview window that can be enabled with "?" key
    "   :Ag! - Start fzf in fullscreen and display the preview window above
    command! -bang -nargs=* Ag
        \ call fzf#vim#ag(<q-args>,
        \                 <bang>0 ? fzf#vim#with_preview('up:60%')
        \                         : fzf#vim#with_preview('right:60%:hidden', '?'),
        \                 <bang>0)

    " Files command with preview window
    command! -bang -nargs=* -complete=dir Files
        \ call fzf#vim#files(<q-args>,
        \                    <bang>0 ? fzf#vim#with_preview('up:60%')
        \                            : fzf#vim#with_preview('right:60%', '?'),
        \                    <bang>0)

    let g:fzf_use_floating = get(g:, 'fzf_use_floating', 0)

    if g:fzf_use_floating == 1
        let g:fzf_layout = { 'window': 'lua require"window".create_centered_floating()' }
    else
        let g:fzf_layout = { 'down': '~30%' } " bottom split
    endif

    let g:fzf_colors = {
        \ 'fg':      ['fg', 'Normal'],
        \ 'bg':      ['bg', 'Clear'],
        \ 'hl':      ['fg', 'Comment'],
        \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
        \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
        \ 'hl+':     ['fg', 'Statement'],
        \ 'info':    ['fg', 'PreProc'],
        \ 'prompt':  ['fg', 'Conditional'],
        \ 'pointer': ['fg', 'Exception'],
        \ 'marker':  ['fg', 'Keyword'],
        \ 'spinner': ['fg', 'Label'],
        \ 'header':  ['fg', 'Comment']
        \ }

    if has('nvim') || has('gui_running')
        let $FZF_DEFAULT_OPTS .= ' --inline-info'
    endif

    " Maps
    noremap  <silent> <C-r>      :History:<CR>
    nnoremap <silent> <Leader>gg :Rg<CR>

    let s:mru = {}
    let s:mru.source = luaeval('require("tools").mru_files()')
    let s:mru.sink = 'edit'

    command! -bang -nargs=* Mru
        \ call fzf#run(fzf#wrap({'source': luaeval('require("tools").mru_files()'), 'sink': 'edit'}), <bang>0)

    augroup fzf_config
        autocmd!
        autocmd FileType fzf silent! tunmap <buffer> <Esc>
    augroup END
endfunction
