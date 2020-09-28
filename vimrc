" My Vim Configuration
" ====================

" vim settings {{{
set modeline                                " I want some modelines
set path=.,,**                              " include files recursively and not have defaults
syntax enable
filetype plugin indent on
set splitbelow splitright                   " windows split in the intuitive direction
set tabstop=8 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent " tab things
set number relativenumber                   " show relative numbers on the side
set ignorecase smartcase                    " Use smartcase by default
set noswapfile                              " swapfiles are annoying
set dictionary+=/usr/share/dict/words       " add this dictionary
set nowrap                                  " wrapping can be annoying
set hidden                                  " TextEdit might fail if hidden is not set.
set nobackup                                " Some servers have issues with backup files, see coc.nvim#649.
set nowritebackup
set cmdheight=2                             " Give more space for displaying messages.
set updatetime=300                          " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
runtime macros/matchit.vim
set shortmess+=c
set tags=./tags;,tags;
set timeoutlen=500
set formatoptions-=cro                      " stop newline continuation of comments
set clipboard=unnamed,unnamedplus
set scrolloff=2
set colorcolumn=+1

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" UTF stuff
set noemoji                                 " Render emoji better
set encoding=utf-8
set fileencoding=utf-8

if has('folding')
  if has('windows')
    " set fillchars=vert:┃
    set fillchars+=fold:·
  endif
endif

let mapleader = ","
let maplocalleader = "<Space>"

" }}}
" vim cache {{{
let viminfoparams = "<800,'10,/50,:100,h,f0,n"
if has('nvim')
  execute 'set viminfo='.viminfoparams.'~/.cache/nviminfo'
else
  execute 'set viminfo='.viminfoparams.'~/.cache/viminfo'
endif
" }}}
" Env variables {{{
let $RTP = split(&runtimepath, ',')[0]
let $RC = "$HOME/.vim/vimrc"
" }}}
" Plugins {{{

"install node
if !executable('npm')
  silent !curl -sL install-node.now.sh/lts | PREFIX=~/.local bash /dev/stdin --yes
endif

call plug#begin('~/.vim/plugged')
" tpope Basics {{{
Plug 'tpope/vim-sensible'         " sensible vim settings
Plug 'tpope/vim-surround'         " surround command
Plug 'tpope/vim-commentary'       " commentary command
Plug 'tpope/vim-fugitive'         " git functionality
Plug 'tpope/vim-speeddating'      " better date functionality
Plug 'tpope/vim-repeat'           " have . work on plugins
Plug 'tpope/vim-unimpaired'       " more mappings with ] and [
Plug 'tpope/vim-apathy'           " path for C/C++, python, sh, xdg, scheme and others
" }}}
" Writing {{{

Plug 'junegunn/goyo.vim'

function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  set scrolloff=999
  set signcolumn=no
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  set scrolloff=2
  if has("patch-8.1.1564")
    set signcolumn=number
  else
    set signcolumn=yes
  endif
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" }}}
" Firefox neovim {{{

if has('nvim')
  Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
endif

if exists('g:started_by_firenvim')
  set laststatus=0
let g:dont_write = v:false

function! My_Write(timer) abort
      let g:dont_write = v:false
      write
endfunction

function! Delay_My_Write() abort
      if g:dont_write
              return
      end
      let g:dont_write = v:true
      call timer_start(1000, 'My_Write')
endfunction

augroup firenvim
  autocmd!
  au TextChanged * ++nested call Delay_My_Write()
  au TextChangedI * ++nested call Delay_My_Write()
  au BufEnter github.com_*.txt set filetype=markdown
  au BufEnter gitlab.com_*.txt set filetype=markdown
  au BufEnter gitlab.umich.edu_*.txt set filetype=markdown
augroup END
endif

" }}}
" Highlight copying/yanks {{{
if !has("nvim-0.5")
  Plug 'machakann/vim-highlightedyank'
  let g:highlightedyank_highlight_duration = 200
  if !exists('##TextYankPost')
    map y <Plug>(highlightedyank)
  endif
endif
" }}}
" LanguageServer {{{
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': ':CocInstall coc-marketplace coc-texlab coc-bibtex coc-python coc-vimlsp coc-git coc-fish coc-sh coc-html coc-json coc-prettier' }
let g:coc_config_home = "$HOME/.vim"
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
nmap <F2> <Plug>(coc-rename)
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
" }}}
" Cosmetics {{{
Plug 'iCyMind/NeoSolarized' " color scheme
Plug 'skammer/vim-css-color' " css colorscheme
" }}}
" Language Specific {{{

" LaTeX plugin
Plug 'lervag/vimtex', { 'for': 'latex' }
let g:tex_flavor = 'latex'
if has('nvim')
  let g:vimtex_compiler_progname = 'nvr'
end

Plug 'vim-scripts/indentpython.vim', { 'for': 'python' }
Plug 'ledger/vim-ledger', { 'for': 'ledger' } " Ledger
Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' } " Haskell
Plug 'dag/vim-fish', { 'for': 'fish' } " Fish

"}}}
" Clipboard {{{
Plug 'svermeulen/vim-yoink'
Plug 'svermeulen/vim-subversive'
Plug 'svermeulen/vim-cutlass'
let g:yoinkSyncNumberedRegisters = 1
let g:yoinkSwapClampAtEnds = 1
let g:yoinkSyncSystemClipboardOnFocus = 0
let g:yoinkIncludeDeleteOperations = 1
let g:ctrlp_map = ''
nmap <expr> p yoink#canSwap() ? '<plug>(YoinkPostPasteSwapBack)' : '<plug>(YoinkPaste_p)'
nmap <expr> P yoink#canSwap() ? '<plug>(YoinkPostPasteSwapForward)' : '<plug>(YoinkPaste_P)'
nmap [y <Plug>(YoinkRotateBack)
nmap ]y <Plug>(YoinkRotateForward)
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
" }}}
" File Explorer {{{

" Fine netrw does suck
if !exists('g:started_by_firenvim')
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeVCS', 'NERDTreeToggle', 'NERDTree'] }
Plug 'tiagofumo/vim-nerdtree-syntax-highlight', { 'on': ['NERDTreeVCS', 'NERDTreeToggle', 'NERDTree'] }
Plug 'ryanoasis/vim-devicons'
  augroup NerdTreeCustom
    autocmd!
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTreeVCS | endif
    autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
  augroup END
  map <C-N> :NERDTreeToggle<CR>
  let NERDTreeAutoDeleteBuffer = 1
  let NERDTreeMinimalUI = 1
  let NERDTreeDirArrows = 1
  let NERDTreeRespectWildIgnore = 1
  let NERDTreeChDirMode = 1
  let g:plug_window = 'noautocmd vertical topleft new'
endif

" }}}
" Fuzzy File Finder {{{

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
nnoremap <silent> <C-p> :Files<CR>
" Mapping selecting mappings
nmap <Leader><Tab> <Plug>(fzf-maps-n)
xmap <Leader><Tab> <Plug>(fzf-maps-x)
omap <Leader><Tab> <Plug>(fzf-maps-o)
" Insert mode completion
imap <C-x><C-k> <Plug>(fzf-complete-word)
imap <C-x><C-f> <Plug>(fzf-complete-path)
imap <C-x><C-j> <Plug>(fzf-complete-file-ag)
imap <C-x><C-l> <Plug>(fzf-complete-line)
let g:fzf_preview_window = 'right:40%'

" }}}
" Powerline {{{
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" }}}
call plug#end()

" }}}
" Theme {{{

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
" powerline
if !exists('g:started_by_firenvim')      " Don't show in firefox
  let g:airline_theme='solarized_flood'
  let g:airline_section_z = airline#section#create(["\uE0A1" . '%{line(".")}' . " \uE0A3" . '%{col(".")}'])
  let g:airline#extensions#tabline#enabled = 1
endif

" }}}

" vim: foldmethod=marker sts=2 et sw=2
