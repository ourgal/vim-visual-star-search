if !has('vim9script') || v:version < 900
    finish
endif
vim9script
# From http://got-ravings.blogspot.com/2008/07/vim-pr0n-visual-search-mappings.html

import autoload '../lib/visual-star-search.vim' as lib

nnoremap <Plug>VisualStarSearchVimGrep <ScriptCmd>lib.Vimgrep()<CR>
xnoremap <Plug>VisualStarSearch/ <ScriptCmd>lib.Search('/')<CR>
xnoremap <Plug>VisualStarSearch? <ScriptCmd>lib.Search('?')<CR>
vnoremap <Plug>VisualStarSearchv <ScriptCmd>lib.Search('v')<CR>

xnoremap * <Plug>VisualStarSearch/n
xnoremap # <Plug>VisualStarSearch?n

# recursively vimgrep for word under cursor or selection if you hit leader-star
if maparg('<leader>*', 'n') == ''
  nmap <leader>* <Plug>VisualStarSearchVimGrep
endif
if maparg('<leader>*', 'v') == ''
  vmap <leader>* <Plug>VisualStarSearchv
endif
