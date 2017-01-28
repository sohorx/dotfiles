" C Config:
" *********

autocmd BufRead,BufNewFile *.h set filetype=c

function s:Init()
    setlocal tabstop=4
    setlocal noexpandtab
    setlocal softtabstop=4
    setlocal shiftwidth=4
    setlocal cinoptions=>s,e0,n0,f0,{0,}0,^0,L0,:s,=s
    setlocal cinoptions+=,l1,gs,h0,ps,t0,+s,(s,u0,w1,Ws
    setlocal cinoptions+=,m1,)70,*300
    setlocal list
    setlocal cc=81
endfunction

augroup filetypedetect
    autocmd FileType c call s:Init()
augroup END
