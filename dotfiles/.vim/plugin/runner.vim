" Commands for running code
if exists('g:loaded_runner_vim')
    finish
endif
let g:loaded_runner_vim = 1

nnoremap <silent> <Leader>r :call runner#run_cmd('run')<CR>
nnoremap <silent> <Leader>w :w \| :call runner#run_cmd('install')<CR>
nnoremap <silent> <Leader>b :call runner#run_cmd('build')<CR>

" Vim-tmux-runner
nnoremap <silent> <Leader>a :VtrAttachToPane<CR>
nnoremap <silent> <Leader>x :VtrKillRunner<CR>
noremap <silent> <C-b> :VtrSendFile!<CR>
