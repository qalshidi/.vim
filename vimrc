" SUCKLESS
" ========
"
"" use modern vim
set nocompatible              " required
"" vim cache
let viminfoparams = "%,<800,'10,/50,:100,h,f0,n"
if has('nvim')
	execute "set viminfo=".viminfoparams."~/.cache/nviminfo"
else
	execute "set viminfo=".viminfoparams."~/.cache/viminfo"
endif
"" for compatibility
filetype off                  " required
"" include files recursively
set path+=**
"" enable syntax highlighting
syntax enable
"" reqiured options
filetype plugin indent on    " required
"" windows go the intuitive direction
set splitbelow splitright
"" tab things
set tabstop=4
set softtabstop=4
set shiftwidth=4
"" show relative line numbers on the side
set number relativenumber
"" mappings
let mapleader = ","
inoremap jj <ESC>
if has('nvim')
	tnoremap jj <C-\><C-N>
	tnoremap <A-h> <C-\><C-N><C-w>h
	tnoremap <A-j> <C-\><C-N><C-w>j
	tnoremap <A-k> <C-\><C-N><C-w>k
	tnoremap <A-l> <C-\><C-N><C-w>l
	inoremap <A-h> <C-\><C-N><C-w>h
	inoremap <A-j> <C-\><C-N><C-w>j
	inoremap <A-k> <C-\><C-N><C-w>k
	inoremap <A-l> <C-\><C-N><C-w>l
else
	tnoremap <A-h> <C-w>h
	tnoremap <A-j> <C-w>j
	tnoremap <A-k> <C-w>k
	tnoremap <A-l> <C-w>l
	inoremap <A-h> <C-w>h
	inoremap <A-j> <C-w>j
	inoremap <A-k> <C-w>k
	inoremap <A-l> <C-w>l
endif
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
noremap <silent> <C-Up> :resize +3<CR>
noremap <silent> <C-Down> :resize -3<CR>
noremap <silent> <C-Left> :vertical resize -3<CR>
noremap <silent> <C-Right> :vertical resize +3<CR>
"" browser window vert splits right
let g:netrw_altv=1
"" write with sudo
cmap w!! w !sudo -A tee > /dev/null %

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

" HTML, XML
au BufNewFile,BufRead *.{xml,html,xhtml} set tabstop=2
au BufNewFile,BufRead *.{xml,html,xhtml} set softtabstop=2
au BufNewFile,BufRead *.{xml,html,xhtml} set shiftwidth=2
au BufNewFile,BufRead *.{xml,html,xhtml} set expandtab
au BufNewFile,BufRead *.{xml,html,xhtml} set autoindent
au BufNewFile,BufRead *.{xml,html,xhtml} set makeprg=xdg-open\ %


" PLUGINS
" =======
"
"" set the runtime path to include Vundle and initialize
if empty(glob($XDG_DATA_HOME.'/nvim/site/autoload/plug.vim')) && has('nvim')
  silent !curl -fLo $XDG_DATA_HOME/nvim/site/autoload/plug.vim --create-dirs
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
elseif empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" THE GREAT TPOPE
" ---------------
"" sensible vim settings
Plug 'tpope/vim-sensible'
"" surround command
Plug 'tpope/vim-surround'
"" commentary command
Plug 'tpope/vim-commentary'
"" git functionality
Plug 'tpope/vim-fugitive'

" AUTOCOMPLETE
" ------------
if (v:version > 704) || has('nvim')
	Plug 'Valloric/YouCompleteMe'
	let g:ycm_autoclose_preview_window_after_completion=1
	map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
	let g:ycm_server_keep_logfiles = 1
	let g:ycm_confirm_extra_conf = 0
	Plug 'rdnetto/YCM-Generator'
endif
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" COSMETICS
" ---------
"" color scheme
Plug 'iCyMind/NeoSolarized'

" LANGUAGE SPECIFIC
" -----------------
" LaTeX plugin
Plug 'lervag/vimtex'
" syntax highlighting
Plug 'scrooloose/syntastic'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" python linter
Plug 'nvie/vim-flake8'
let python_highlight_all=1

" FILE STUFF
" ----------
"" Fuzzy file find
Plug 'kien/ctrlp.vim'

call plug#end()

" THEME
" =====
"
" dark background is always best
set background=dark
" solarized colorscheme is beautiful
if (v:version > 704) || has('nvim')
	set termguicolors " Enable true color support.
endif
if (&term == 'st-256color')
	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
colorscheme NeoSolarized

" SNIPPETS
" ========
"
nnoremap <Leader>pyfile :-1read /home/qusai/.vim/snippets/file.py<CR>GddggjA
nnoremap <Leader>pydef :-1read /home/qusai/.vim/snippets/def.py<CR>3Wi
nnoremap <Leader>pyclass :-1read /home/qusai/.vim/snippets/class.py<CR>3Wi

"
" MISC
" ====
"
set modeline
set makeprg=make\ -j
