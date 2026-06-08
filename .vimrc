set nocompatible              " be iMproved, required
filetype off                  " required
filetype plugin indent on    " required
" Allow saving of files as sudo when I forgot to start vim using sudo.
cnoremap w!! w !sudo tee %
nnoremap Q <Nop>
set number
set autoindent 
syntax on
set backspace=indent,eol,start
set laststatus=2
set showmode  
set tabstop=4                   " a tab is four spaces
set softtabstop=4               " when hitting <BS>, pretend like a tab is removed, even if spaces
set noexpandtab                 " don't expand tabs to spaces by default
set shiftwidth=4                " number of spaces to use for autoindenting
set linebreak					
set directory^=$HOME/.vim/swap//
let mapleader=' '
" set spell spelllang=en_gb
command Wd write|bdelete
" Enable CursorLine
set nocursorline
autocmd InsertEnter * set cursorline
autocmd InsertLeave * set nocursorline

augroup filetypedetect
  " Mail
  autocmd BufRead,BufNewFile *mutt-* setfiletype mail
augroup END

function! FlickrReplace()
  let pattern = '<a data-flickr.*href="\([^"]*\)".*title="\([^"]*\).*img src="\([^"]*\).*$'
  let replacement = '{% ahfowimage "\3" "\2" "\1" %}'
  if search(pattern) != 0
	execute '%s/'.pattern.'/'.replacement.'/g'
  else
	echo "not found"
  endif
endfunction
function! MoonshotReplace()
  let pattern = 'https\?:\/\/\(moonshot\.g85:40[40]0\|www\.fullofwishes\.co\.uk\)'
  let replacement = ''
  if search(pattern) != 0
	execute '%s/'.pattern.'/'.replacement.'/g'
  else
	echo "not found"
  endif
endfunction


function! Surround(s1, s2) range
  exe "normal vgvmboma\<Esc>"
  normal `a
  let lineA = line(".")
  let columnA = col(".")
  normal `b
  let lineB = line(".")
  let columnB = col(".")
  " exchange marks
  if lineA > lineB || lineA <= lineB && columnA > columnB
    " save b in c
    normal mc
    " store a in b
    normal `amb
    " set a to old b
    normal `cma
  endif
  exe "normal `ba" . a:s2 . "\<Esc>`ai" . a:s1 . "\<Esc>"
endfunction

vnoremap <leader>t :call Surround('{% ahfowtrack "', '" %}')<cr>

nnoremap <leader>f :call FlickrReplace()<cr>
nnoremap <leader>m :call MoonshotReplace()<cr>
nnoremap <leader>t ciw{% ahfowtrack "<C-r>" %}<Esc>
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
command! FullUrl %s~\v\]\((\/[^)]*)\)~](https://www.fullofwishes.co.uk\1?utm_source=social\&utm_medium=substack\&utm_campaign=newsletter+yyyymmdd)~g
command! FullUrl2 %s~\(href="\|](\)\(\/[^"|)]*\)~\1https://www.fullofwishes.co.uk\2?utm_source=social\&utm_medium=substack\&utm_campaign=newsletter+yyyymmdd~g

call plug#begin()
" The default plugin directory will be as follows:
" Make sure you use single quotes

" Multiple Plug commands can be written in a single line using | separators
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'mechatroner/rainbow_csv'
Plug 'chrisbra/Recover.vim'
" Initialize plugin system
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting

let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/mysnippets']

