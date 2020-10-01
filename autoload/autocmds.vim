let g:ColorColumnBufferNameBlacklist = ['fugitive']
let g:ColorColumnFileTypeBlacklist = ['dirvish', 'diff', 'fugitiveblame', 'qf']

function! autocmds#should_colorcolumn() abort
  if len(@%) && index(g:ColorColumnBufferNameBlacklist, split(@%, ':')[0]) != -1
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
