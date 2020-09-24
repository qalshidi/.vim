" vim-bettergrep
" Maintainer: Qusai Al Shidi
if exists('g:bettergrep_loaded')
  finish
endif
let g:bettergrep_loaded = 1

command! -nargs=+ -complete=file_in_path -bar Grep  call bettergrep#Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep call bettergrep#LGrep(<f-args>)

if !exists('g:bettergrep_no_abbrev')
  cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
  cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'
endif

" vim: et sts=2 sw=2 foldmethod=marker
