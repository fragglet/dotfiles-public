set mouse-=a
set bg=dark
colorscheme desert
set gfn=DejaVu\ Sans\ Mono\ 10
syntax on
set scrolloff=5
set hls
set ruler

set smartindent

" Align expressions, align case with switch
set cino=(0,:0

" Dark theme, no toolbar
set guioptions+=d
set guioptions-=T

" doom style
set tabstop=8 softtabstop=4 shiftwidth=4 expandtab
" lhasa style
" set tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab

highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.*/
highlight TailingSpace ctermbg=DarkBlue guibg=#392929
2match TailingSpace /\s\s*$/
highlight tab ctermbg=darkgreen
match tab /\t/

" Jump to last position when reopening file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Remember decision when permitting lvimrc
let g:localvimrc_persistent=2

" open window after running make
au QuickFixCmdPost make cwindow

map <C-k> :make<CR>

" view manpages as a frame
runtime ftplugin/man.vim
set keywordprg=:Man

" fast updates for gitgutter
set updatetime=100
