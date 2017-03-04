set columns=85
"set lines=40

if has('win32')
    set guifont=M+1VM+IPAG_circle:h10:cSHIFTJIS
"   set guifont=ゆたぽん（コーディング）Heavy:h11:cSHIFTJIS
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

"カーソル上の文字色は文字の背景色にする。
"IME が無効なとき Green
"IME が有効なとき Purple
"にする。
"colorscheme zenburn
"colorscheme rdark
colorscheme mycolor

"カラースキーム設定後にしないと駄目
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
