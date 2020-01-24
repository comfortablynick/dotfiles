# autoload/plugins directory

If a file in this dir matches a plugin file name, it will automatically execute functions on `SourcePre` and `SourcePost`.

Example:

```vim
function! plugins#tagbar#pre()
    " Executed before plugin is sourced
endfunction

function! plugins#tagbar#post()
    " Executed after plugin is sourced
endfunction
```
