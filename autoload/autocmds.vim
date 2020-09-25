let g:ColorColumnBufferNameBlacklist = ['fugitive']
let g:ColorColumnFileTypeBlacklist = ['diff', 'fugitiveblame', 'qf', 'nerdtree']

function! autocmds#should_colorcolumn() abort
  if bufname(bufnr('%')) && index(g:ColorColumnBufferNameBlacklist, split(bufname(bufnr('%')), ':')[0]) != -1
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
