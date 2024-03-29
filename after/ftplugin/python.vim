" Python after ftplugin
" Language:         Python
" Maintainer:       Qusai Al Shidi

setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab autoindent
setlocal fileformat=unix
setlocal colorcolumn=80

" :make settings
setlocal makeprg=python3\ -m\ pylint\ --reports=n\ --output-format=parseable\ %:p
setlocal errorformat=%f:%l:\ %m

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

" Snippets
inoremap <buffer> ;def   <Esc>:read ~/.vim/snippets/def.py<CR>wi
inoremap <buffer> ;class <Esc>:read ~/.vim/snippets/class.py<CR>wi
