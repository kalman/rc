syntax on
filetype indent on
filetype plugin on
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
map gr gT
map m :cnext<CR>
map t :tabe 
map gF :tabe <cfile><CR>
map q Gyy<c-o>p
map Q Gyy<c-o>P

" Taken from :help [I
map <F5> [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

"
" For switching between .cc and .h files.
" Taken from koz.
"
fu! SetSuffix(fn, suffix)
    return substitute(a:fn, "\\.[^.]*$", "." . a:suffix, "")
endfunction

fu! GetOther(fn)
    if a:fn =~ "\\.h$"
        let s:cc = SetSuffix(a:fn, "cc")
        let s:cpp = SetSuffix(a:fn, "cpp")
        if filereadable(s:cc)
            return s:cc
        elseif filereadable(s:cpp)
            return s:cpp
        endif
    elseif a:fn =~ "\\.cc$" || a:fn =~ "\\.cpp"
        return SetSuffix(a:fn, "h")
    endif
    return 1
endfunction

fu! Switch()
    let s:temp = GetOther(expand("%"))
    if s:temp != 1
        exe ":e " . s:temp
    endif
endfunction

map _ :call Switch()<CR>
