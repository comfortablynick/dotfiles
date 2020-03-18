if exists('g:loaded_autoload_plugins_fzf') | finish | endif
let g:loaded_autoload_plugins_fzf = 1

function! plugins#fzf#post() abort
    " let g:fzf_use_floating = get(g:, 'fzf_use_floating', 0)
    let g:fzf_use_floating = 1

    if g:fzf_use_floating == 1
        let g:fzf_layout = { 'window': 'lua require"window".create_centered_floating{width=0.9, height=0.6, border=true, hl="Comment"}' }
        " let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
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

    augroup fzf_config
        autocmd!
        autocmd FileType fzf silent! tunmap <buffer> <Esc>
    augroup END
    
    call s:fzf_maps()
    call s:fzf_commands()
endfunction

function! s:fzf_maps() abort
    " Maps
    noremap  <silent> <C-r>      :History:<CR>
    nnoremap <silent> <Leader>gg :RG<CR>
endfunction

function! s:fzf_commands() abort
    " View maps in any mode
    command! -bang -nargs=1 -complete=customlist,s:map_types_completion Map
        \ call fzf#vim#maps(<q-args>, <bang>0)

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

    command! -nargs=* -bang RG call s:rg_passthrough(<q-args>, <bang>0)

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

    " Mru :: most recently used files
    command! -bang -nargs=* Mru call fzf#run(fzf#vim#with_preview(fzf#wrap({
        \ 'source': luaeval('require("tools").mru_files()'),
        \ 'sink':'edit',
        \ 'options': '--prompt="MRU:> "',
        \ 'down': '~40%',
        \ }), 'right:60%', '?'),
        \ <bang>0)
endfunction

" Use `rg` to filter, passing through to fzf as a selector
function! s:rg_passthrough(query, fullscreen)
    let l:command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
    let l:initial_command = printf(l:command_fmt, shellescape(a:query))
    let l:reload_command = printf(l:command_fmt, '{q}')
    let l:spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.l:reload_command]}
    call fzf#vim#grep(l:initial_command, 1, fzf#vim#with_preview(l:spec), a:fullscreen)
endfunction

function! s:map_types_completion(a,l,p) abort
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
