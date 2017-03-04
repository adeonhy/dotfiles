set columns=85
"set lines=40

if has('win32')
    set guifont=M+1VM+IPAG_circle:h10:cSHIFTJIS
"   set guifont=$B$f$?$]$s!J%3!<%G%#%s%0!K(BHeavy:h11:cSHIFTJIS
elseif has("gui_gtk2")
    " set guifont=M+1VM+IPAG\ circle\ 16
    " set guifont=Ricty\ 14
    set guifont=Rictythick\ 14
elseif has("gui_macvim")
"    set guifont=M+1VM+IPAG\ circle\ Regular:h16
    " set guifont=Monaco:h14
    set guifont=Ricty\ thick\ Regular:h14
    set noimdisableactivate
    set transparency=10
else
    " set guifont=Ricty
    " set guifont=Ricty\ thick\ Regular:h18
endif

"$B%+!<%=%k>e$NJ8;z?'$OJ8;z$NGX7J?'$K$9$k!#(B
"IME $B$,L58z$J$H$-(B Green
"IME $B$,M-8z$J$H$-(B Purple
"$B$K$9$k!#(B
"colorscheme zenburn
"colorscheme rdark
colorscheme mycolor

"$B%+%i!<%9%-!<%`@_Dj8e$K$7$J$$$HBLL\(B
if has('multi_byte_ime')
  hi Cursor guifg=bg guibg=Green gui=NONE
  hi CursorIM guifg=NONE guibg=Red gui=NONE
endif

"remove toolbar
set guioptions-=t
set guioptions-=L
set guioptions-=T
"remove menu
set guioptions-=m
gui
set vb t_vb=
"set transparency=245
