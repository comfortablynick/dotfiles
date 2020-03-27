" Execute line/selection
nnoremap <silent><buffer> yxx      <Cmd>execute getline('.')<CR>
xnoremap <silent><buffer> <Enter> :<C-U>keeppatterns '<,'>g/^/exe getline('.')<CR>
