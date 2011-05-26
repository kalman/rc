"
" Ben's vim color file.
"

hi clear
if exists("syntax_on")
	syntax reset
endif 

set bg=dark

hi SpecialKey     cterm=NONE ctermfg=darkgreen
hi NonText        cterm=bold ctermfg=darkblue
hi Directory      cterm=NONE ctermfg=darkcyan
hi ErrorMsg       cterm=bold ctermfg=grey      ctermbg=darkred
hi IncSearch      cterm=NONE ctermfg=yellow    ctermbg=green
hi Search         cterm=NONE ctermfg=grey      ctermbg=blue
hi MoreMsg        cterm=NONE ctermfg=darkgreen
hi ModeMsg        cterm=NONE ctermfg=brown
hi LineNr         cterm=NONE ctermfg=darkgrey
hi Question       cterm=NONE ctermfg=green
hi StatusLine     cterm=bold,reverse
hi StatusLineNC   cterm=reverse
hi VertSplit      cterm=reverse
hi Title          cterm=NONE ctermfg=darkmagenta
hi Visual         cterm=reverse
hi VisualNOS      cterm=bold,underline
hi WarningMsg     cterm=NONE ctermfg=darkred
hi WildMenu       cterm=NONE ctermfg=black     ctermbg=brown
hi Folded         cterm=NONE ctermfg=darkgrey  ctermbg=NONE
hi FoldColumn     cterm=NONE ctermfg=darkgrey  ctermbg=NONE
hi DiffAdd        cterm=NONE                   ctermbg=darkblue
hi DiffChange     cterm=NONE                   ctermbg=darkmagenta
hi DiffDelete     cterm=bold ctermfg=darkblue  ctermbg=darkcyan
hi DiffText       cterm=bold                   ctermbg=darkred
hi Comment        cterm=NONE ctermfg=cyan
hi Constant       cterm=NONE ctermfg=magenta
hi Special        cterm=NONE ctermfg=blue
hi Identifier     cterm=NONE ctermfg=blue
hi Statement      cterm=NONE ctermfg=yellow
hi PreProc        cterm=NONE ctermfg=yellow
hi Type           cterm=NONE ctermfg=green
hi Underlined     cterm=underline ctermfg=darkmagenta
hi Ignore         cterm=bold ctermfg=grey
hi Error          cterm=bold ctermfg=grey      ctermbg=darkred
