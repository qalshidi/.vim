augroup LedgerCustom
    autocmd!
    autocmd BufWritePost * silent :g/^\s/ LedgerAlign
augroup END

inoremap <silent> <buffer> <Tab> <C-r>=ledger#autocomplete_and_align()<CR>
vnoremap <silent> <buffer> <Tab> :LedgerAlign<CR>
