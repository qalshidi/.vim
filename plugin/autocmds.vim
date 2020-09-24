if has('autocmd')
  augroup MyAutocmds
    autocmd!

    if exists('##TextYankPost') && has('nvim-0.5')
      au TextYankPost * silent! lua vim.highlight.on_yank {timeout=200, on_visual=false}
    endif

  " Quick fix window automatically opens up if populated
  autocmd QuickFixCmdPost cgetexpr cwindow
  autocmd QuickFixCmdPost lgetexpr lwindow

  augroup end
endif
