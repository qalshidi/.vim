if has('autocmd')
  augroup MyAutocmds
    autocmd!

    " Flash highlighted text
    if exists('##TextYankPost') && has('nvim-0.5')
      au TextYankPost * silent! lua vim.highlight.on_yank {timeout=200, on_visual=false}
    endif

    " Highlight background windows
    if exists('+winhighlight')
      autocmd BufEnter,FocusGained,VimEnter,WinEnter * set winhighlight=
      autocmd FocusLost,WinLeave * set winhighlight=CursorLineNr:LineNr,EndOfBuffer:ColorColumn,IncSearch:ColorColumn,Normal:ColorColumn,NormalNC:ColorColumn,SignColumn:ColorColumn
      if exists('+colorcolumn')
        autocmd BufEnter,FocusGained,VimEnter,WinEnter * let &l:colorcolumn='+1'
      endif
    elseif exists('+colorcolumn')
      autocmd BufEnter,FocusGained,VimEnter,WinEnter * let &l:colorcolumn='+' . join(range(0, 254), ',+')
      autocmd FocusLost,WinLeave * if let &l:colorcolumn=join(range(1, 255), ',')
    endif

  " Quick fix window automatically opens up if populated
  autocmd QuickFixCmdPost cgetexpr cwindow
  autocmd QuickFixCmdPost lgetexpr lwindow

  augroup end
endif
