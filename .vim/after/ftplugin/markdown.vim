if has('autocmd') && !exists('#SpellCheck')
  augroup SpellCheck
    autocmd!
    autocmd BufRead,BufNewFile,BufWinEnter,BufEnter *.{md,mdown,mkd,mkdn,markdown,mdwn}*
          \ setlocal spell
    autocmd BufRead,BufNewFile,BufWinEnter,BufEnter *.{md,mdown,mkd,mkdn,markdown,mdwn}*
          \ setlocal thesaurus+=~/.vim/thesaurus/mthesaur.txt
  augroup END
endif

" see https://github.com/plasticboy/vim-markdown/issues/232
" and https://github.com/plasticboy/vim-markdown/issues/246
if has('autocmd') && !exists('#AdjustListFormattingContextually')
  augroup AdjustListFormattingContextually
    autocmd!
    autocmd CursorMovedI,CursorMoved *.{md,mdown,mkd,mkdn,markdown,mdwn}*
          \ call <SID>SetFormatOptionsContextually()
  augroup END
endif

" see https://github.com/plasticboy/vim-markdown/issues/232
if has('autocmd') && !exists('#AdjustListPattern')
  augroup AdjustListPattern
    autocmd!
    autocmd FileType markdown
          \ setlocal formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^\\s*\[-*+]\\s\\+
  augroup END
endif

function! s:SetFormatOptionsContextually() abort
  let l:line = getline(line('.'))

  " Disable some automatic formatting if we're in a list or if the line
  " begins with some whitespace.
  if l:line =~? &l:formatlistpat || l:line =~? '^\\s+'
    setlocal formatoptions-=a  " Do not automatically format paragraphs as I type)
    setlocal formatoptions-=c  " Do not automatically wrap comments
    setlocal formatoptions-=o  " Do not automatically insert comment leader after hitting 'o'
    setlocal formatoptions-=q  " Do not automatically format comments with 'gq' or 'gw'
  else
    setlocal formatoptions+=a  " Automatically format paragraphs as I type)
    setlocal formatoptions+=c  " Automatically wrap comments (blockquotes)
    setlocal formatoptions+=o  " Automatically insert comment leader after hitting 'o' (blockquotes)
    setlocal formatoptions+=q  " Automatically format comments (blockquotes) with 'gq' or 'gw'
  endif
endfunction
