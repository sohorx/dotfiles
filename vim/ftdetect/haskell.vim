" Haskell Config:
" ***************
" need to install hdevtools on cabal to work. (cabal install hdevtools)

augroup filetypedetect
    function s:Init()
        let &makeprg='hdevtools check %'
        setlocal     tabstop=8
        setlocal     expandtab
        setlocal     softtabstop=4
        setlocal     shiftwidth=4
        setlocal     shiftround

        nmap <buffer> <F1>          :HdevtoolsType<CR>
        nmap <buffer> <silent> <F2> :HdevtoolsClear<CR>
    endfunction

    autocmd FileType haskell call s:Init()
augroup END
