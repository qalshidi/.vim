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
" copy to system clipboard
set clipboard=unnamedplus

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
let mapleader = ","
" easily navigate windows
if has('nvim')
	tnoremap <Leader>wh <C-\><C-N><C-w>h
	tnoremap <Leader>wj <C-\><C-N><C-w>j
	tnoremap <Leader>wk <C-\><C-N><C-w>k
	tnoremap <Leader>wl <C-\><C-N><C-w>l
endif
nnoremap <Leader>wh <C-w>h
nnoremap <Leader>wj <C-w>j
nnoremap <Leader>wk <C-w>k
nnoremap <Leader>wl <C-w>l
" misc
nnoremap <Leader>mktags :!ctags -R<CR>
nnoremap <Leader>h :noh<CR>

" Snippets
" --------
"
nnoremap <Leader>spyfile :-1read ~/.vim/snippets/file.py<CR>GddggjA
nnoremap <Leader>spydef :-1read ~/.vim/snippets/def.py<CR>wi
nnoremap <Leader>spyclass :-1read ~/.vim/snippets/class.py<CR>wi
nnoremap <Leader>sshebang O#!/usr/bin/env bash<CR># 

" File Explorer
" =============
"
let g:netrw_liststyle=3
if exists("*netrw_gitignore#Hide")
    let g:netrw_list_hide=netrw_gitignore#Hide()
end
augroup VimStartup
    au!
    au VimEnter * if expand('%') == '' | e . | endif
augroup END
let g:netrw_altv=1

" Filetype
" ========
"
" Python
au BufNewFile,BufRead *.py set tabstop=4
au BufNewFile,BufRead *.py set softtabstop=4
au BufNewFile,BufRead *.py set shiftwidth=4
au BufNewFile,BufRead *.py set textwidth=79
au BufNewFile,BufRead *.py set expandtab
au BufNewFile,BufRead *.py set autoindent
au BufNewFile,BufRead *.py set fileformat=unix
au BufNewFile,BufRead *.py set colorcolumn=80
au BufNewFile,BufRead *.py set makeprg=python\ %
au BufNewFile,BufRead *.py set encoding=utf-8
let python_highlight_all=1
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
Plug 'neoclide/coc.nvim', {'branch': 'release',
                          \ 'do': ':CocInstall coc-marketplace coc-python coc-vimlsp coc-git coc-sh coc-html coc-json'
                          \}
" TextEdit might fail if hidden is not set.
set hidden
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
" Give more space for displaying messages.
set cmdheight=2
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" Use <CR> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <CR> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <CR> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)
" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)
" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<CR>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<CR>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<CR>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<CR>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<CR>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" Cosmetics
" ---------
"
" color scheme
Plug 'iCyMind/NeoSolarized'

" Language Specific
" -----------------

" LaTeX plugin
Plug 'lervag/vimtex'
let g:tex_flavor = 'latex'
Plug 'vim-scripts/indentpython.vim'

" Ledger
Plug 'ledger/vim-ledger'

" " syntax checking
" Plug 'scrooloose/syntastic'
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
" let g:syntastic_python_checkers = ['flake8', 'pylint', 'python']

" Haskell
au BufEnter *.hs compiler ghc
Plug 'neovimhaskell/haskell-vim'
Plug 'lukerandall/haskellmode-vim'
let g:haddock_browser = "/usr/bin/firefox"
let g:haddock_browser_callformat = '%s "%s"'
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

" Fish
Plug 'dag/vim-fish'

" File Stuff
" ----------

" Fuzzy file find
Plug 'kien/ctrlp.vim'

" Powerline
" ---------
"
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

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
let g:neosolarized_italic = 1
"tmux stuff
set t_8f=[38;2;%lu;%lu;%lum
set t_8b=[48;2;%lu;%lu;%lum
colorscheme NeoSolarized
let g:airline_theme='solarized_flood'
let g:airline_section_z = airline#section#create(["\uE0A1" . '%{line(".")}' . " \uE0A3" . '%{col(".")}'])
