" Yaml Config:
" ************

augroup filetypedetect
    function s:Init()
        setlocal     tabstop=2
        setlocal     expandtab
        setlocal     softtabstop=2
        setlocal     shiftwidth=2
        setlocal     shiftround
    endfunction

    autocmd FileType yaml call s:Init()
augroup END
