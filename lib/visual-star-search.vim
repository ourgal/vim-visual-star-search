vim9script
# From http://got-ravings.blogspot.com/2008/07/vim-pr0n-visual-search-mappings.html

type Lines = list<string>

class Vselection
  const line_start: number
  const column_start: number

  const line_end: number
  const column_end: number

  const lines: Lines

  def new()
    [this.line_start, this.column_start] = getpos("'<")[1 : 2]
    [this.line_end, this.column_end] = getpos("'>")[1 : 2]
    this.lines = getline(this.line_start, this.line_end)
  enddef
  
  def WordMode(lines: Lines): Lines
    lines[-1] = lines[-1][: this.column_end - (&selection == 'inclusive' ? 1 : 2)]
    lines[0] = lines[0][this.column_start - 1 :]
    return lines
  enddef

  def BlockMode(lines: Lines): Lines
    var i = 0
    for line in lines
        lines[i] = line[this.column_start - 1 : this.column_end - (&selection == 'inclusive' ? 1 : 2)]
        i += 1
    endfor
    return lines
  enddef

  def String(mode: string): string
    if mode == 'v'
      return this.lines->deepcopy()->this.WordMode()->join('\n')
    elseif mode == 'V'
      return this.lines->join("\n")
    elseif mode == "\<c-v>"
      return this.lines->deepcopy()->this.BlockMode()->join('\n')
    else
      return ''
    endif
  enddef

endclass

# makes * and # work on visual mode too.
export def Search(cmdtype: string)
  normal 
  const selection = Vselection.new()
  const s = '\V' .. visualmode()->selection.String()->escape(cmdtype .. '\')->substitute('\n', '\\n', 'g')
  setreg('/', s)
  if cmdtype == 'v'
    execute 'vimgrep // **'
  endif
enddef

export def Vimgrep()
  const s = '\V' .. expand("<cword>")->escape('\')->substitute('\n', '\\n', 'g')
  execute $"vimgrep /{s}/ **"
enddef 
