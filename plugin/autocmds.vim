" My autocmds
if exists('g:loaded_my_autocmds')
  finish
endif
let g:loaded_my_autocmds = 1

if has('autocmd')
  augroup MyAutocmds
    autocmd!

    " Flash highlighted text
    if exists('##TextYankPost') && has('nvim-0.5')
      au TextYankPost * ++nested silent! lua vim.highlight.on_yank {timeout=200, on_visual=true}
    endif

    " Highlight background windows
    if exists('+colorcolumn')
      autocmd BufEnter,FocusGained,VimEnter,WinEnter * if autocmds#should_colorcolumn() | let &l:colorcolumn='+1' | endif
      autocmd BufEnter,FocusGained,VimEnter,WinEnter * if autocmds#should_colorcolumn() | let &l:colorcolumn='+1' | endif
      autocmd FocusLost,WinLeave * if autocmds#should_colorcolumn() | let &l:colorcolumn=join(range(1, 255), ',') | endif
    endif

    " Highlight Line Number
    if exists(':highlight')
      autocmd InsertEnter * highlight! link CursorLineNr Identifier
      autocmd InsertLeave * highlight! link CursorLineNr Statement
    endif

    " Turn off highlighting after movement
    if exists('##CmdLineEnter')
      autocmd CmdlineEnter /,\? :set hlsearch
    endif
    autocmd CursorMoved * ++nested :set nohlsearch

    " Skeletons
    autocmd BufNewFile  *.py    0r ~/.vim/snippets/file.py   | normal Gi
    autocmd BufNewFile  *.fish  0r ~/.vim/snippets/file.fish | normal Gi
    autocmd BufNewFile  *.sh    0r ~/.vim/snippets/file.sh   | normal Gi
    autocmd BufNewFile  *.vim   0r ~/.vim/snippets/file.vim  | normal gg$"%pGi

    " decide on grepprg
    function! s:grepprg() abort
      if isdirectory('./.git')
        if executable('git')
          return 'git grep -n --column'
        else
          return &grepprg
        endif
      else
        return &grepprg
      endif
    endfunction

    " change grepprg on change directory
    autocmd VimEnter * let g:bettergrepprg = <SID>grepprg()
    if exists('##DirChanged')
      autocmd DirChanged * let g:bettergrepprg = <SID>grepprg()
    endif

  " Automatically add file marks
  autocmd BufLeave *.{c,cpp} mark C
  autocmd BufLeave *.h       mark H
  autocmd BufLeave *.md      mark M
  autocmd BufLeave *.txt     mark T
  autocmd BufLeave *.py      mark P
  autocmd BufLeave *.in      mark I
  autocmd BufLeave *.vim     mark V

  " Set cursor line only in normal mode
  autocmd InsertLeave,WinEnter * set cursorline
  autocmd InsertEnter,WinLeave * set nocursorline

  augroup END
endif
