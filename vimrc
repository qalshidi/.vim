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
set path=.,,**
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
" use ripgrep
set grepprg=rg\ --vimgrep
" swap files are annoying
set noswapfile

" Env variables
" =============

let $RTP = split(&runtimepath, ',')[0]
let $RC = "$HOME/.vim/vimrc"

" Mappings
" ========
"
nnoremap Y y$
inoremap <nowait> jk <Esc>
if has('nvim')
	tnoremap <nowait> jk <C-\><C-N>
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
	tnoremap <C-h> <C-\><C-N><C-w>h
	tnoremap <C-j> <C-\><C-N><C-w>j
	tnoremap <C-k> <C-\><C-N><C-w>k
	tnoremap <C-l> <C-\><C-N><C-w>l
endif
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" misc
nnoremap <Leader>gt :!ctags -R<CR>
nnoremap <silent> <Leader>h :noh<CR>

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
"install node
if ! (!empty(glob('~/.local/bin/npm')) || !empty(glob('/usr/bin/npm')) || !empty(glob('/usr/local/bin/npm')))
    silent !curl -sL install-node.now.sh/lts | PREFIX=~/.local bash /dev/stdin --yes
end

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
" better date functionality
"
Plug 'tpope/vim-speeddating'
" have . work on plugins
Plug 'tpope/vim-repeat'
" more mappings with ] and [
Plug 'tpope/vim-unimpaired'

" Autocomplete
" ------------
"
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': ':CocInstall coc-marketplace coc-python coc-vimlsp coc-git coc-fish coc-sh coc-html coc-json' }
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
inoremap <silent><expr> <C-Space> coc#refresh()
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
nmap <silent> <Leader>gd <Plug>(coc-definition)
nmap <silent> <Leader>gy <Plug>(coc-type-definition)
nmap <silent> <Leader>gi <Plug>(coc-implementation)
nmap <silent> <Leader>gr <Plug>(coc-references)
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
nmap <Leader>rn <Plug>(coc-rename)
" Formatting selected code.
xmap <Leader>f  <Plug>(coc-format-selected)
nmap <Leader>f  <Plug>(coc-format-selected)
augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
" Applying codeAction to the selected region.
" Example: `<Leader>aap` for current paragraph
xmap <Leader>a  <Plug>(coc-codeaction-selected)
nmap <Leader>a  <Plug>(coc-codeaction-selected)
" Remap keys for applying codeAction to the current buffer.
nmap <Leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <Leader>qf  <Plug>(coc-fix-current)
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
nnoremap <silent><nowait> <Space>a  :<C-u>CocList diagnostics<CR>
" Manage extensions.
nnoremap <silent><nowait> <Space>e  :<C-u>CocList extensions<CR>
" Show commands.
nnoremap <silent><nowait> <Space>c  :<C-u>CocList commands<CR>
" Find symbol of current document.
nnoremap <silent><nowait> <Space>o  :<C-u>CocList outline<CR>
" Search workspace symbols.
nnoremap <silent><nowait> <Space>s  :<C-u>CocList -I symbols<CR>
" Do default action for next item.
nnoremap <silent><nowait> <Space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <Space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <Space>p  :<C-u>CocListResume<CR>

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
au BufNewFile,BufRead *.journal set filetype=journal

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

" Clipboard
" ---------
"
Plug 'svermeulen/vim-yoink'
Plug 'svermeulen/vim-subversive'
Plug 'svermeulen/vim-cutlass'
set clipboard=unnamed,unnamedplus
let g:yoinkSyncSystemClipboardOnFocus=0
let g:yoinkIncludeDeleteOperations=1
nmap <C-n> <Plug>(YoinkPostPasteSwapBack)
nmap <C-p> <Plug>(YoinkPostPasteSwapForward)
nmap p <Plug>(YoinkPaste_p)
nmap P <Plug>(YoinkPaste_P)
nmap [y <Plug>(YoinkRotateBack)
nmap ]y <Plug>(YoinkRotateForward)
nmap y <Plug>(YoinkYankPreserveCursorPosition)
xmap y <Plug>(YoinkYankPreserveCursorPosition)
let g:yoinkIncludeDeleteOperations=1
" s for substitute
nmap s <Plug>(SubversiveSubstitute)
nmap ss <Plug>(SubversiveSubstituteLine)
nmap S <Plug>(SubversiveSubstituteToEndOfLine)
nmap <Leader>S <Plug>(SubversiveSubstituteWordRange)
" x is now cut
nnoremap x d
xnoremap x d
nnoremap xx dd
nnoremap X D

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
