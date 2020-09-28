let g:ColorColumnBufferNameBlacklist = ['fugitive']
let g:ColorColumnFileTypeBlacklist = ['dirvish', 'diff', 'fugitiveblame', 'qf']

function! autocmds#should_colorcolumn() abort
  " TODO: Fix this block, it doesn't work as intended to find uri buffers
  if index(g:ColorColumnBufferNameBlacklist, split(@%, ':')[0]) != -1
    return 0
  endif
  if index(g:ColorColumnBufferNameBlacklist, bufname(bufnr('%'))) != -1
    return 0
  endif
  if index(g:ColorColumnFileTypeBlacklist, &filetype) != -1
    return 0
  endif
  return &buflisted
endfunction
