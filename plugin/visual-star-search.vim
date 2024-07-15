if !has('vim9script') || v:version < 900
    finish
endif
vim9script
# From http://got-ravings.blogspot.com/2008/07/vim-pr0n-visual-search-mappings.html

# https://stackoverflow.com/a/61486601
def GetVisualSelection(mode: string): string
    # call with visualmode() as the argument
    const [line_start, column_start] = getpos("'<")[1 : 2]
    const [line_end, column_end] = getpos("'>")[1 : 2]
    final lines = getline(line_start, line_end)
    if mode == 'v'
        # Must trim the end before the start, the beginning will shift left.
        lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
        lines[0] = lines[0][column_start - 1 :]
    elseif mode == 'V'
        # Line mode no need to trim start or end
    elseif mode == "\<c-v>"
        # Block mode, trim every line
        final new_lines = []
        var i = 0
        for line in lines
            lines[i] = line[column_start - 1 : column_end - (&selection == 'inclusive' ? 1 : 2)]
            i += 1
        endfor
    else
        return ''
    endif
    return join(lines, "\n")
enddef

# makes * and # work on visual mode too.
def VSetSearch(cmdtype: string): string
    return '\V' .. GetVisualSelection(visualmode())->escape(cmdtype .. '\')->substitute('\n', '\\n', 'g')
enddef

def Vimgrep(): string
    return '\V' .. expand("<cword>")->escape('\')->substitute('\n', '\\n', 'g')
enddef 

xnoremap * :<C-u>/<C-R>=<SID>VSetSearch('/')<CR><CR>n
xnoremap # :<C-u>?<C-R>=<SID>VSetSearch('?')<CR><CR>n

# recursively vimgrep for word under cursor or selection if you hit leader-star
if maparg('<leader>*', 'n') == ''
  nmap <leader>* :vimgrep /<c-r>=<SID>Vimgrep()<cr>/ **<cr>
endif
if maparg('<leader>*', 'v') == ''
  vmap <leader>* :<C-u>vimgrep /<c-r>=<SID>VSetSearch('/')<cr>/ **<CR>
endif
