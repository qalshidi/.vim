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
      au TextYankPost * ++nested silent! lua vim.highlight.on_yank {timeout=200, on_visual=false}
    endif

    " Highlight background windows
    if exists('+colorcolumn')
      autocmd BufEnter,FocusGained,VimEnter,WinEnter * if autocmds#should_colorcolumn() | let &l:colorcolumn='+1' | endif
      autocmd BufEnter,FocusGained,VimEnter,WinEnter * if autocmds#should_colorcolumn() | let &l:colorcolumn='+1' | endif
      autocmd FocusLost,WinLeave * if autocmds#should_colorcolumn() | let &l:colorcolumn=join(range(1, 255), ',') | endif
    endif

    " Turn off highlighting after movement
    if exists('##CmdLineEnter')
      autocmd CmdlineEnter /,\? :set hlsearch
    endif
    autocmd CursorMoved * ++nested :set nohlsearch

    " Skeletons
    autocmd BufNewFile  *.py    0r ~/.vim/snippets/file.py | normal Gi
    autocmd BufNewFile  *.fish  0r ~/.vim/snippets/file.fish | normal Gi
    autocmd BufNewFile  *.sh    0r ~/.vim/snippets/file.sh | normal Gi

    " use git grep if in git directory
    autocmd VimEnter * if isdirectory('./.git') | let g:bettergrepprg = 'git grep -n --column' | endif
    if exists('##DirChanged')
      autocmd DirChanged * if isdirectory('./.git') | let g:bettergrepprg = 'git grep -n --column' | endif
    endif

  " Automatically add file marks
  autocmd BufLeave *.{c,cpp} mark C
  autocmd BufLeave *.h       mark H
  autocmd BufLeave *.md      mark M
  autocmd BufLeave *.py      mark P
  autocmd BufLeave *.in      mark I

  " Set cursor line only in normal mode
  autocmd InsertLeave,WinEnter * set cursorline
  autocmd InsertEnter,WinLeave * set nocursorline

  augroup end
endif
