if !has('vim9script') || v:version < 900
    finish
endif
vim9script
# From http://got-ravings.blogspot.com/2008/07/vim-pr0n-visual-search-mappings.html

import autoload '../lib/visual-star-search.vim' as lib

command VisualStarSearchVimGrep lib.Vimgrep()

xnoremap * :<C-u>/<C-R>=<SID>lib.SearchString('/')<CR><CR>n
xnoremap # :<C-u>?<C-R>=<SID>lib.SearchString('?')<CR><CR>n

# recursively vimgrep for word under cursor or selection if you hit leader-star
if maparg('<leader>*', 'n') == ''
  nmap <leader>* <ScriptCmd>VisualStarSearchVimGrep<cr>
endif
if maparg('<leader>*', 'v') == ''
  vmap <leader>* :<C-u>vimgrep /<c-r>=<SID>lib.SearchString('/')<cr>/ **<CR>
endif
