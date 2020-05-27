" My Vim Configuration
" ====================
"
" use modern vim
set nocompatible              " required
" vim cache
let viminfoparams = "%,<800,'10,/50,:100,h,f0,n"
if has('nvim')
	execute 'set viminfo='.viminfoparams.'~/.cache/nviminfo'
else
	execute 'set viminfo='.viminfoparams.'~/.cache/viminfo'
endif
" for compatibility
set modeline
" include files recursively
set path+=**
" enable syntax highlighting
syntax enable
" reqiured options
filetype plugin indent on
" windows go the intuitive direction
set splitbelow splitright
" tab things
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent
" show relative line numbers on the side
set number relativenumber

" Mappings
" ========
"
nnoremap Y y$
inoremap jk <Esc>
if has('nvim')
	tnoremap jk <C-\><C-N>
endif
" resize with ctrl
noremap <silent> <C-Up> :resize +3<CR>
noremap <silent> <C-Down> :resize -3<CR>
noremap <silent> <C-Left> :vertical resize -3<CR>
noremap <silent> <C-Right> :vertical resize +3<CR>
" write with sudo
cmap w!! w !sudo -A tee > /dev/null %

" Leader Mappings
" ---------------
"
let mapleader = "\<Space>"
" easily navigate windows
if has('nvim')
	tnoremap <Leader>hh <C-\><C-N><C-w>h
	tnoremap <Leader>jj <C-\><C-N><C-w>j
	tnoremap <Leader>kk <C-\><C-N><C-w>k
	tnoremap <Leader>ll <C-\><C-N><C-w>l
else
	tnoremap <Leader>hh <C-w>h
	tnoremap <Leader>jj <C-w>j
	tnoremap <Leader>kk <C-w>k
	tnoremap <Leader>ll <C-w>l
endif
nnoremap <Leader>hh <C-w>h
nnoremap <Leader>jj <C-w>j
nnoremap <Leader>kk <C-w>k
nnoremap <Leader>ll <C-w>l
" misc
nnoremap <Leader>mktags :!ctags -R .<CR>
nnoremap <Leader>p :CtrlPTag<CR>
nnoremap <Leader>h :noh<CR>

" Snippets
" --------
"
nnoremap <Leader>spyfile :-1read /home/qusai/.vim/snippets/file.py<CR>GddggjA
nnoremap <Leader>spydef :-1read /home/qusai/.vim/snippets/def.py<CR>wi
nnoremap <Leader>spyclass :-1read /home/qusai/.vim/snippets/class.py<CR>wi
nnoremap <Leader>sshebang O#!/usr/bin/env bash<CR># 

" File Explorer
" =============
"
let g:netrw_liststyle=3
let g:netrw_list_hide=netrw_gitignore#Hide()
augroup VimStartup
    au!
    au VimEnter * if expand('%') == '' | e . | endif
augroup END
let g:netrw_altv=1

" Filetype
" ========
"
" PEP 8
au BufNewFile,BufRead *.py set tabstop=4
au BufNewFile,BufRead *.py set softtabstop=4
au BufNewFile,BufRead *.py set shiftwidth=4
au BufNewFile,BufRead *.py set textwidth=79
au BufNewFile,BufRead *.py set expandtab
au BufNewFile,BufRead *.py set autoindent
au BufNewFile,BufRead *.py set fileformat=unix
au BufNewFile,BufRead *.py set colorcolumn=80
au BufNewFile,BufRead *.py set makeprg=python\ %
" HTML, XML (w3c standard)
au BufNewFile,BufRead *.{xml,html,xhtml} set tabstop=2
au BufNewFile,BufRead *.{xml,html,xhtml} set softtabstop=2
au BufNewFile,BufRead *.{xml,html,xhtml} set shiftwidth=2
au BufNewFile,BufRead *.{xml,html,xhtml} set expandtab
au BufNewFile,BufRead *.{xml,html,xhtml} set autoindent
au BufNewFile,BufRead *.{xml,html,xhtml} set makeprg=xdg-open\ %


" Plugins
" =======
"
" set the runtime path to include Vundle and initialize
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim')) && has('nvim')
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
elseif empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')

" tpope Basics
" ------------
"
" sensible vim settings
Plug 'tpope/vim-sensible'
" surround command
Plug 'tpope/vim-surround'
" commentary command
Plug 'tpope/vim-commentary'
" git functionality
Plug 'tpope/vim-fugitive'

" Autocomplete
" ------------
"
if (v:version > 704) || has('nvim')
	Plug 'Valloric/YouCompleteMe'
	let g:ycm_autoclose_preview_window_after_completion=1
	map <Leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
	let g:ycm_server_keep_logfiles = 1
	let g:ycm_confirm_extra_conf = 0
	Plug 'rdnetto/YCM-Generator', {'branch': 'stable'}
endif
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" Cosmetics
" ---------
"
" color scheme
Plug 'iCyMind/NeoSolarized'

" Language Specific
" -----------------
"
" LaTeX plugin
Plug 'lervag/vimtex'
" python linter
Plug 'nvie/vim-flake8'
let python_highlight_all=1
" syntax highlighting
Plug 'scrooloose/syntastic'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" File Stuff
" ----------
"
" Fuzzy file find
Plug 'kien/ctrlp.vim'

" Powerline
" ---------
"
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" testing rounded separators (extra-powerline-symbols):
let g:airline_left_sep = "\uE0B4"
let g:airline_right_sep = "\uE0BA"

call plug#end()

" Theme
" =====
"
" dark background is always best
set background=dark
" solarized colorscheme is beautiful
if (v:version > 704) || has('nvim')
	set termguicolors " Enable true color support.
endif
colorscheme NeoSolarized
let g:airline_theme='solarized_flood'
