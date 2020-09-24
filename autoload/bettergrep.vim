" vim-bettergrep
" Maintainer: Qusai Al Shidi

" decide on grep program
if executable('rg')
  set grepprg=rg\ --vimgrep
elseif executable('ag')
  set grepprg=ag\ --vimgrep
endif

if exists("*jobstart")

  function! s:OnOut_c(job_id, data, event) dict
    cgetexpr join(a:data, "\n")
  endfunction

  function! s:OnOut_l(job_id, data, event) dict
    lgetexpr join(a:data, "\n")
  endfunction

  function! s:OnError(job_id, data, event) dict
    echo join(a:data, "\n")
  endfunction

  let s:callbacks = {
  \ 'stdout_buffered': 1,
  \ 'on_stderr': function('s:OnError'),
  \ }

  function! bettergrep#Grep(...)
    let s:callbacks.on_stdout = function('s:OnOut_c')
    let s:grepCmd = split(&grepprg) + split(expandcmd(join(a:000, ' ')))
    let grepjob = jobstart(s:grepCmd, s:callbacks)
  endfunction

  function! bettergrep#LGrep(...)
    let s:callbacks.on_stdout = function('s:OnOut_l')
    let s:grepCmd = split(&grepprg) + split(expandcmd(join(a:000, ' ')))
    let grepjob = jobstart(s:grepCmd, s:callbacks)
  endfunction

else
  " Thanks to RomainL's gist
  " https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3

  function! bettergrep#Grep(...)
    cgetexpr system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
  endfunction

  function! bettergrep#LGrep(...)
    lgetexpr system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
  endfunction

endif

" vim: et sts=2 sw=2 foldmethod=marker
