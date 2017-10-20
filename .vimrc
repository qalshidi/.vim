set nocompatible              " required
filetype off                  " required

syntax enable

" PEP 8
"au BufNewFile,BufRead *.py
"    \ set tabstop=4
"    \ set softtabstop=4
"    \ set shiftwidth=4
"    \ set textwidth=79
"    \ set expandtab
"    \ set autoindent
"    \ set fileformat=unix

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" autocomplete
Plugin 'Valloric/YouCompleteMe'
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
let g:ycm_server_keep_logfiles = 1

" color schemes
Plugin 'altercation/vim-colors-solarized'

" syntax highlighting
Plugin 'scrooloose/syntastic'
Plugin 'nvie/vim-flake8'
let python_highlight_all=1

" surround command
Plugin 'tpope/vim-surround'

" Fuzzy file find
Plugin 'kien/ctrlp.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
" misc options
filetype plugin indent on    " required
set background=dark
colorscheme solarized
highlight Normal ctermfg=grey ctermbg=black
set number relativenumber
