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
      au TextYankPost * silent! lua vim.highlight.on_yank {timeout=200, on_visual=false}
    endif

    " Highlight background windows
    if exists('+colorcolumn')
      autocmd BufEnter,FocusGained,VimEnter,WinEnter * if autocmds#should_colorcolumn() | let &l:colorcolumn='+1' | endif
      autocmd BufEnter,FocusGained,VimEnter,WinEnter * if autocmds#should_colorcolumn() | let &l:colorcolumn='+1' | endif
      autocmd FocusLost,WinLeave * if autocmds#should_colorcolumn() | let &l:colorcolumn=join(range(1, 255), ',') | endif
    endif

  augroup end
endif
