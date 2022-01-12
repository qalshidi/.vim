" My Vim Configuration
" ====================
scriptencoding utf-8

" vim settings {{{
set shell=/bin/bash                         " Avoid using fish for stuff
set exrc secure                             " Project specific vimrc's
set path=.,,src/**,config/**,cfg/**         " include files recursively and not have defaults
syntax enable
filetype plugin indent on
set tabstop=8 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent " tab things
set number relativenumber                   " show relative numbers on the side
set dictionary+=/usr/share/dict/words       " add this dictionary
set textwidth=80

if has('linebreak')
  set wrap
  set breakindent                           " Break after textwidth
  set breakindentopt=sbr                    " Show break character &showbrea
  set breakindentopt+=shift:8               " 8 characters of shift to emphasize
  let &showbreak = '↳'                      " Line break char
  set linebreak                             " wrap around &breakat
endif

set cmdheight=2                             " Give more space for displaying messages.
set updatetime=300                          " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
set shortmess+=c
set shortmess+=I                            " No splash screen
set shortmess+=A                            " Annoying swapfile messages
set timeoutlen=500
set formatoptions-=ro                      " stop newline continuation of comments
set formatoptions+=j                       " J joins comment lines well.

if !exists('$SSH_TTY')                     " Use clipboard if not on ssh
  set clipboard=unnamed,unnamedplus
endif

set colorcolumn=+1
set lazyredraw                              " Don't redraw during macro
set nojoinspaces                            " Don't double space on join with punctuation

if exists('&inccommand')
  set inccommand=nosplit                    " Show modifications of commands
endif

if executable('rg')
  let &grepprg = "rg --vimgrep "
else
  let &grepprg = "grep -n "
endif

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
elseif exists('&signcolumn')
  set signcolumn=yes
endif

if has('virtualedit')
  set virtualedit=block               " allow cursor to move where there is no text in visual block mode
endif

" UTF stuff
if has('&noemoji')
    set noemoji                                 " Render emoji better
endif
set encoding=utf-8
set fileencoding=utf-8

if has('folding')
  set fillchars+=fold:·
  set foldmethod=indent
  set foldlevelstart=99                      " Start unfloded
endif

let mapleader = "\<Space>"
let maplocalleader = "\<Bslash>"

" Global variables

let g:markdown_fenced_languages = [
  \ 'python',
  \ 'vim',
  \ 'c',
  \ 'cpp',
  \ 'sh',
  \ 'html',
  \ 'xml',
  \ 'css',
  \ 'haskell',
  \ 'help',
  \ ]

" backup files
if exists("$SUDO_USER")
  set nobackup
  set noswapfile
  set undodir     =/tmp/vim/sudo
endif

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

call plug#begin('~/.vim/plugged')
" tpope Basics {{{

Plug 'sheerun/vimrc'              " vim-sensible plus extra
Plug 'tpope/vim-surround'         " surround command
Plug 'tpope/vim-commentary'       " commentary command
Plug 'tpope/vim-fugitive'         " git functionality
Plug 'tpope/vim-speeddating'      " better date functionality
Plug 'tpope/vim-repeat'           " have . work on plugins
Plug 'tpope/vim-unimpaired'       " more mappings with ] and [
Plug 'tpope/vim-apathy'           " path for C/C++, python, sh, xdg, scheme and others
Plug 'tpope/vim-eunuch'           " file manipulation

" }}}
" Project stuff {{{

Plug 'airblade/vim-rooter'
let g:rooter_targets = '*'

" Snippets
Plug 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'
let g:UltiSnipsExpandTrigger="<C-s>"
let g:UltiSnipsEditSplit="vertical"
let g:completion_enable_snippet = 'UltiSnips'

" }}}
" My Plugins {{{

Plug 'qalshidi/vim-bettergrep'

" }}}
" tmux helpers {{{

Plug 'christoomey/vim-tmux-navigator'

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

" NeoVim 0.5 {{{
if has('nvim-0.5')
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/completion-nvim'
  Plug 'alexaandru/nvim-lspupdate'
  let g:lspupdate_commands = {'pip': 'pip install --user -U %s'}
  Plug 'airblade/vim-gitgutter'
  let g:diagnostic_enable_virtual_text = 1
  " Set completeopt to have a better completion experience
  set completeopt=menuone,noinsert,noselect
  " Avoid showing message extra message when using completion
  set shortmess+=c
  nnoremap ]d <cmd>NextDiagnostic<CR>
  nnoremap [d <cmd>PrevDiagnostic<CR>
  " Tree-sitter
  Plug 'nvim-treesitter/nvim-treesitter'

" }}}
" {{{ Conqueror of Completion
elseif v:version >= 800

  let g:coc_disable_startup_warning = 1
  "install node
  if !executable('npm')
    silent !curl -sL install-node.now.sh/lts | PREFIX=~/.local bash /dev/stdin --yes
  endif

  Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': ':CocInstall coc-marketplace coc-texlab coc-bibtex coc-python coc-vimlsp coc-git coc-fish coc-sh coc-html coc-json coc-snippets coc-prettier' }
  let g:coc_config_home = "$HOME/.vim"
  inoremap <silent><expr> <Tab>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<Tab>" :
    \ coc#refresh()
  inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"

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
  " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
  nmap <silent> [d <Plug>(coc-diagnostic-prev)
  nmap <silent> ]d <Plug>(coc-diagnostic-next)
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
  nmap <F2>       <Plug>(coc-rename)
  " Formatting selected code.
  xmap <Leader>f  <Plug>(coc-format-selected)
  nmap <Leader>f  <Plug>(coc-format-selected)
  augroup MyCocGroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup END
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

endif
" }}}


" }}}
" Cosmetics {{{

if has('nvim') || v:version >= 800
  Plug 'lifepillar/vim-solarized8'
  let g:solarized_extra_hi_groups = 1
else
  Plug 'overcache/NeoSolarized' " color scheme
endif
Plug 'ap/vim-css-color' " css colorscheme
Plug 'rafi/awesome-vim-colorschemes', {'on': 'colorscheme'}
if has('signs')
  Plug 'kshenoy/vim-signature' " show marks on signcolumn
endif

" }}}
" Language Specific {{{

" LaTeX plugin
let g:tex_flavor = 'latex'
Plug 'lervag/vimtex', { 'for': ['latex', 'tex', 'plaintex'] }
if has('nvim')
  let g:vimtex_compiler_progname = 'nvr'
end

Plug 'ledger/vim-ledger'
Plug 'dbeniamine/todo.txt-vim'
Plug 'sheerun/vim-polyglot'             " Syntax enhancements
let g:Todo_txt_prefix_creation_date=1

"}}}
" Clipboard {{{

if has('nvim') || v:version >= 800
  Plug 'svermeulen/vim-yoink'
  let g:yoinkSyncNumberedRegisters = 1
  let g:yoinkSwapClampAtEnds = 1
  let g:yoinkSyncSystemClipboardOnFocus = 0
  let g:yoinkIncludeDeleteOperations = 1
  let g:ctrlp_map = ''
  nmap <expr> p yoink#canSwap() ? '<plug>(YoinkPostPasteSwapBack)' : '<plug>(YoinkPaste_p)'
  nmap <expr> P yoink#canSwap() ? '<plug>(YoinkPostPasteSwapForward)' : '<plug>(YoinkPaste_P)'
  nmap [y <Plug>(YoinkRotateBack)
  nmap ]y <Plug>(YoinkRotateForward)
endif

Plug 'svermeulen/vim-subversive'
Plug 'svermeulen/vim-cutlass'
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

Plug 'justinmk/vim-dirvish'

augroup mydirvish
  autocmd!
  " behave like netrw
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | Dirvish | endif
  autocmd BufEnter * if isdirectory(bufname(bufnr('%'))) | Dirvish % | endif
augroup end

  let g:dirvish_mode = ':sort ,^.*[\/],'   " Folders on top

if has('conceal')
  Plug 'kristijanhusak/vim-dirvish-git'
endif

" }}}
" Fuzzy File Finder {{{

if has('patch-8.1.2114') || has('nvim-0.4.2')
  Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }
  nnoremap <C-p>     <Cmd>Clap files<CR>
  nnoremap <Leader>h <Cmd>Clap help_tags<CR>
endif


" }}}
" Editing {{{

Plug 'wellle/targets.vim'      " Extra text objects
Plug 'rhysd/clever-f.vim'      " Better f key behavior

" }}}
" Powerline {{{

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"}}}
" Buffer stuff {{{

Plug 'qpkorr/vim-bufkill'

" }}}
" Devicons (must be last {{{

Plug 'ryanoasis/vim-devicons'

" }}}
call plug#end()

" }}}
" Theme {{{

"tmux stuff
set t_8f=[38;2;%lu;%lu;%lum
set t_8b=[48;2;%lu;%lu;%lum

" solarized colorscheme is beautiful
if has('termguicolors')
  set termguicolors " Enable true color support.
else
  set t_Co=16
endif

set background=dark

if has('nvim') || v:version >= 704
  colorscheme solarized8_flat
else
  colorscheme NeoSolarized
endif

" Initial settings
highlight! link CursorLineNr Statement

" podid_vimrcwerline
let g:airline_theme='base16_solarized'
let g:airline_section_z = airline#section#create(["\uE0A1" . '%{line(".")}' . " \uE0A3" . '%{col(".")}'])
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" }}}
" {{{ Lua

if has('nvim-0.5')
  lua local lsp_config = require('lsp-config')
  lua local treesitter_config = require('treesitter-config')
endif

" }}}"

if strlen(glob("$HOME/.vim/vimrc-extend")) | source ~/.vim/vimrc-extend | endif

" vim: foldmethod=marker sts=2 et sw=2 foldnestmax=0
