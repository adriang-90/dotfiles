syntax enable
filetype plugin indent on

set number
# change working directory to the directory of your working file
set autochdir

set rules

"disable arrow keys"
noremap <up> :echoerr "Umm, use k instead"<CR>
noremap <down> :echoerr "Umm, use j instead"<CR>
noremap <left> :echoerr "Umm, use h instead"<CR>
noremap <right> :echoerr "Umm, use l instead"<CR>
inoremap <up> <NOP>
inoremap <down> <NOP>
inoremap <left> <NOP>
inoremap <right> <NOP>

# auto command for c language
augroup filetype_c
    autocmd!
    :autocmd FileType c setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
    :autocmd FileType c nnoremap <buffer> <localleader>c I/*<space><esc><s-a><space>*/<esc>
augroup end
