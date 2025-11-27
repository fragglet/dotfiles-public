set mouse-=a
set bg=dark
colorscheme desert
set gfn=DejaVu\ Sans\ Mono\ 10
syntax on
set scrolloff=5
set hls ruler modeline incsearch

set smartindent

" Align expressions, align case with switch
set cino=(0,:0

" Dark theme, no toolbar or tearoff menus
set guioptions+=d
set guioptions-=T
set guioptions-=t

" doom style
set tabstop=8 softtabstop=4 shiftwidth=4 expandtab
" lhasa style
" set tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab

autocmd FileType make setlocal sw=8 sts=8 ts=8 noexpandtab
autocmd FileType gitcommit setlocal tw=72 expandtab ts=8 sts=2 sw=2
autocmd FileType go setlocal sw=8 sts=8 ts=8 noexpandtab

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

let _ = system("which gmake")
if v:shell_error == 0
    set makeprg=gmake
endif

" view manpages as a frame
runtime ftplugin/man.vim
set keywordprg=:Man

" fast updates for gitgutter
set updatetime=100

" allow cursor move to end of line
set ve+=onemore

if has("gui_running")
  set lines=40 columns=85
  if has("macunix")
    set guifont=FiraCode-Regular:h11
  else
    set guifont=Fira\ Code\ 11
  endif
  let g:airline_powerline_fonts=1
endif

let g:airline_theme='bubblegum'
" let g:airline_powerline_fonts=1

function! AirlineInit()
  let g:airline_section_b = airline#section#create(['hunks'])
  let g:airline_section_x = airline#section#create(['branch'])
  let g:airline_section_y = airline#section#create(['%p%%'])
  let g:airline_section_z = airline#section#create(['linenr', 'colnr'])
  let g:airline_symbols.branch = ''
  let g:airline_symbols.linenr = ''
  let g:airline_symbols.colnr = ':'
endfunction

autocmd User AirlineAfterInit call AirlineInit()

" Assume .tf files are HCL (Terraform) format
silent! autocmd! filetypedetect BufRead,BufNewFile *.tf
autocmd BufRead,BufNewFile *.tf,*.hcl,*.tfbackend set filetype=hcl
autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl
