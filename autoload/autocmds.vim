let g:colorcolumn_blocklist_bufname = ['fugitive']
let g:colorcolumn_blocklist_filetype = ['dirvish', 'diff', 'fugitiveblame', 'qf']

function! autocmds#should_colorcolumn() abort
  if len(@%) && index(g:colorcolumn_blocklist_bufname, split(@%, ':')[0]) != -1
    return 0
  endif
  if index(g:colorcolumn_blocklist_bufname, bufname(bufnr('%'))) != -1
    return 0
  endif
  if index(g:colorcolumn_blocklist_filetype, &filetype) != -1
    return 0
  endif
  return &buflisted
endfunction
