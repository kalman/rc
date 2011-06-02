syntax on
filetype indent on
filetype plugin on
"colorscheme ben
colorscheme koehler

set autoindent
set cursorline
set hlsearch
set modeline
set number
set ruler
set tags=tags
set smarttab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set backspace=indent,eol,start

map j gj
map k gk
map ^ g^
map $ g$

" Taken from :help [I
map <F4> [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

"
" Taken from koz
"
function! Tocc(fn)
  return substitute(a:fn, "\.h$", ".cc", "")
endfunction

function! Toh(fn)
  return substitute(a:fn, "\.cc$", ".h", "")
endfunction

function! GetOther(fn)
  if a:fn =~ "\.h$"
    return Tocc(a:fn)
    "if filereadable(Tocc(a:fn))
    "    return Tocc(a:fn)
    "endif
  elseif a:fn =~ "\.cc$"
    return Toh(a:fn)
    "if filereadable(Toh(a:fn))
    "    return Toh(a:fn)
    "endif
  endif
  return 1
endfunction

function! Switch()
  let s:temp = GetOther(expand("%"))
  if s:temp != 1
    exe ":e " . GetOther(expand("%"))
  endif
endfunction

map <F5> :call Switch()<CR>
