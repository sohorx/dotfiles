" Ocaml Config:
" *************

augroup filetypedetect
    function s:OcamlInit()
        setlocal commentstring=(*%s*)
    endfunction

    autocmd BufEnter *.ml  compiler ocaml
    autocmd Filetype ocaml call s:OcamlInit()
augroup END

