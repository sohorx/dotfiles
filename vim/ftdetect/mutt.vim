" Mutt Mail Message Filetype:
"****************************

augroup filetypedetect
    function s:Init()
        setfiletype mail
        set textwidth=80
    endfunction

    autocmd BufRead,BufNewFile *mutt-*  call s:Init()
augroup END
