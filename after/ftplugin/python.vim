" Python after ftplugin
" Language:         Python
" Maintainer:       Qusai Al Shidi

setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab autoindent
setlocal fileformat=unix
setlocal colorcolumn=80
if executable('pylint')
    compiler pylint
endif
setlocal encoding=utf-8
setlocal wildignore=*/__pycache__/*,*.pyc
setlocal foldmethod=indent
setlocal define=^\s*\\(def\\\\|class\\)
set path+=test/**
let python_highlight_all=1

setlocal include=^\\s*\\(from\\\|import\\)\\s*\\.*\\zs\\(\\S\\+\\s\\{-}\\)*\\ze\\($\\\|\ as\\)
function! PyInclude(fname) abort
    let parts = split(a:fname, ' import ')
    let l = parts[0]
    if len(parts) > 1
        let r = parts[1]
        let joined = join([l, r], '.')
        let fp = substitute(joined, '\.', '/', 'g') . '.py'
        let found = glob(fp, 1)
        if len(found)
            return found
        endif
    endif
    return substitute(l, '\.', '/', 'g') . '.py'
endfunction
setlocal includeexpr=PyInclude(v:fname)

call g:ApplyLspMappings()
