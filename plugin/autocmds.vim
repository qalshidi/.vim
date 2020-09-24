if has('autocmd')
  augroup MyAutocmds

    " if exists('##TextYankPost') && has('nvim')
    "   au TextYankPost * silent! lua vim.highlight.on_yank {timeout=200, on_visual=false}
    " endif

  augroup end
endif
