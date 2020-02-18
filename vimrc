" ========== DEFAULT VIM OPTIONS =============
"
"" use modern vim
set nocompatible              " required
"" for compatibility
filetype off                  " required
"" include files recursively
set path+=**
"" enable syntax highlighting
syntax enable
"" reqiured options
filetype plugin indent on    " required
"" show relative line numbers on the side
set number relativenumber

" PEP 8
"au BufNewFile,BufRead *.py
"    \ set tabstop=4
"    \ set softtabstop=4
"    \ set shiftwidth=4
"    \ set textwidth=79
"    \ set expandtab
"    \ set autoindent
"    \ set fileformat=unix

" ================= PLUGINS =============================
"" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

"" AUTOCOMPLETE
if (v:version > 7041577) || has('nvim')
	Plugin 'Valloric/YouCompleteMe'
	let g:ycm_autoclose_preview_window_after_completion=1
	map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
	let g:ycm_server_keep_logfiles = 1
endif

" SNIPPETS
" Track the engine.
Plugin 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" COSMETICS
"" color schemes
Plugin 'iCyMind/NeoSolarized'
Plugin 'lifepillar/vim-solarized8'

"" LANGUAGE SPECIFIC
"
"" LaTeX plugin
Plugin 'lervag/vimtex'
"
"" syntax highlighting
Plugin 'scrooloose/syntastic'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"
"" python linter
Plugin 'nvie/vim-flake8'
let python_highlight_all=1

" THE GREAT TPOPE
"
"" sensible vim settings
Plugin 'tpope/vim-sensible'
" 
"" surround command
Plugin 'tpope/vim-surround'
"
"" commentary command
Plugin 'tpope/vim-commentary'
"
"" git functionality
Plugin 'tpope/vim-fugitive'

" FILE STUFF
"
"" Fuzzy file find
Plugin 'kien/ctrlp.vim'

call vundle#end()

"" =========== THEME ================
"" dark background is always best
set background=dark
"" solarized colorscheme is beautiful
if (v:version > 7041577) || has('nvim')
	colorscheme NeoSolarized
	set termguicolors
else
	colorscheme solarized8
endif

" ======== MAPPINGS =================
" Make the tags
command MakeTags !ctags -R .
command MakeTagsCpp !ctags -R *cpp *hpp ./*/*hpp ./*/*cpp

" =========== OTHER =======
"" Make sure modeline is enabled
set modeline
set makeprg=make\ -j
