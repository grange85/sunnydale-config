set nocompatible              " be iMproved, required
filetype off                  " required
filetype plugin indent on    " required
" Allow saving of files as sudo when I forgot to start vim using sudo.
cnoremap w!! w !sudo tee %
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
let mapleader=' '
" set spell spelllang=en_gb
command Wd write|bdelete

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
  let pattern = 'http:\/\/moonshot\.local:4040'
  let replacement = ''
  if search(pattern) != 0
	execute '%s/'.pattern.'/'.replacement.'/g'
  else
	echo "not found"
  endif
endfunction
nnoremap <leader>f :call FlickrReplace()<cr>
nnoremap <leader>m :call MoonshotReplace()<cr>
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

iabbrev mdash —

call plug#begin()
" The default plugin directory will be as follows:
" Make sure you use single quotes

" Multiple Plug commands can be written in a single line using | separators
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'rickhowe/diffchar.vim'
Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'npm install'}
Plug 'atkenny15/vim-ghosttext'
" Initialize plugin system
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting

let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/mysnippets']

