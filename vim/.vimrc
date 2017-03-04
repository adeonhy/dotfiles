"## 基本設定#########################################################
set termencoding=utf-8
set encoding=utf-8
""set encoding=japan
"set fileencodings=sjis
set fileencoding=utf-8
set fileencodings=utf-8,iso-2022-jp-3,euc-jp,euc-jisx0213
set number
set nocursorline
set tabstop=2 shiftwidth=2 softtabstop=0
"set nowrap
"新しい行のインデントを現在行と同じにする
set autoindent
"ファイル保存ダイアログの初期ディレクトリをバッファファイル位置に設定
set browsedir=buffer 
"クリップボードをWindowsと連携
set clipboard=unnamed
"Vi互換をオフ
set nocompatible
"タブの代わりに空白文字を挿入する
set expandtab
"インクリメンタルサーチを行う
set incsearch
"listで表示される文字のフォーマットを指定する
set listchars=eol:$,tab:>\ ,extends:<
"閉じ括弧が入力されたとき、対応する括弧を表示する
set showmatch
"検索時に大文字を含んでいたら大/小を区別
set smartcase
"新しい行を作ったときに高度な自動インデントを行う
set smartindent
"行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする。
set smarttab
"カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]
"検索をファイルの先頭へループしない
set nowrapscan
set backspace=indent,eol,start
set nobackup
set autoread
set hidden
set vb t_vb=

"undoファイル(*.un~)を一箇所にまとめる
set undodir=~/.vim/undo

set foldmethod=syntax
" set foldcolumn=1
set foldlevelstart=99
syntax on

" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
    set ambiwidth=double
endif


"for taglist.vim
set tags=tags
"for buftabs.vim
let g:buftabs_only_basename=1
let g:buftabs_in_statusline=1

"入力モード時、ステータスラインのカラーを変更
augroup InsertHook
autocmd!
autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
augroup END

"全角スペースを視覚化
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
au BufNewFile,BufRead * match ZenkakuSpace /　/
" set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
"ステータスラインを常に表示
set laststatus=2

if !has('gui-running')
  set t_Co=256
endif

"key mapping
"goto prev buffer
"nmap <silent> <S-Tab> :bp<CR>
nmap <silent> <C-k> :bp<CR>
nnoremap <silent> <C-h> :tabprevious<CR>
nnoremap <silent> <BS> :tabprevious<CR>
"goto next buffer
"nmap <silent> <C-Tab> :bn<CR>
nmap <silent> <C-j> :bn<CR>
nnoremap <silent> <C-l> :tabnext<CR>
"delete current buffer
"map <silent> <F4> <ESC>:bd<CR>

nmap j gj
nmap k gk
vmap j gj
vmap k gk

" インサートモードでEmacsもどきのキーバインドを使う
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-f> <RIGHT>
inoremap <C-b> <LEFT>
" inoremap <C-p> <Up>
" inoremap <C-n> <Down>
inoremap <C-h> <Backspace>
inoremap <C-d> <Del>
inoremap <C-w> <ESC>bcw
inoremap <C-k> <C-o>D


map <silent> <F2> <ESC>:MRU<CR>
map <silent> <F3> <ESC>:NERDTreeToggle<CR>
" map <silent> <F4> <ESC>:TlistToggle<CR>

"inoremap { {}<LEFT>
"inoremap [ []<LEFT>
"inoremap " ""<LEFT>
"vnoremap { "zdi{<C-R>z}<ESC>
"vnoremap [ "zdi[<C-R>z]<ESC>
"vnoremap ( "zdi(<C-R>z)<ESC>
"vnoremap " "zdi"<C-R>z"<ESC>
"vnoremap ' "zdi'<C-R>z'<ESC>
"inoremap <C-Space> <ESC><RIGHT>a

filetype on
filetype plugin on
filetype indent on

"短縮形の登録
"iab re require
"iab cl class
"iab mo module
"iab ret return
"iab res rescue
"iab ens ensure

"-------------------------------------------------
"filetype settings
"-------------------------------------------------
au BufRead,BufNewFile,BufReadPre *.coffee   set filetype=coffee
"インデント設定
autocmd FileType coffee    setlocal sw=2 sts=2 ts=2 et

augroup FtAutocmd
    au!

    au FileType javascript call Javascript_Setting()
    au FileType ruby call Ruby_Setting()
    au FileType scheme call Scheme_Setting()
augroup END
"-------------------------------------------------
"for ruby settings
"-------------------------------------------------
 "preview interpreter's output(Tip #1244)
function! Ruby_eval_vsplit() range
    if &filetype == "ruby"
        let src = tempname()
        let dst = "Ruby_Output"
        " put current buffer's content in a temp file
        silent execute ": " . a:firstline . "," . a:lastline . "w " . src
        " open the preview window
        silent execute ":pedit! " . dst
        " change to preview window
        wincmd P
        " set options
        setlocal buftype=nofile
        setlocal noswapfile
        setlocal syntax=none
        setlocal bufhidden=delete
        " replace current buffer with ruby's output
        silent execute ":%! ruby " . src . " 2>&1 "
        " change back to the source buffer
        wincmd p
    endif
endfunction

function! Ruby_Setting()
    setlocal ts=2 sts=2 sw=2
    let ruby_minlines = 50
    let ruby_operators = 1
    "<F10>でバッファのRubyスクリプトを実行し、結果をプレビュー表示
    vmap <silent> <F5> :call Ruby_eval_vsplit()<CR>
    nmap <silent> <F5> mzggVG<F5>`z
    map  <silent> <S-F5> :pc<CR>
endfunction

"---------------------------------------------------
"for scheme settings
"---------------------------------------------------
function! Scheme_eval_vsplit() range
    if &filetype == "scheme"
        let src = tempname()
        let dst = "Scheme_Output"
        " put current buffer's content in a temp file
        silent execute ": " . a:firstline . "," . a:lastline . "w " . src
        " open the preview window
        silent execute ":pedit! " . dst
        " change to preview window
        wincmd P
        " set options
        setlocal buftype=nofile
        setlocal noswapfile
        setlocal syntax=none
        setlocal bufhidden=delete
        " replace current buffer with ruby's output
        silent execute ":%! gosh " . src . " 2>&1 "
        " change back to the source buffer
        wincmd p
    endif
endfunction

function! Scheme_Setting()
    setlocal ts=2 sts=2 sw=2
    vmap <silent> <F5> :call Scheme_eval_vsplit()<CR>
    nmap <silent> <F5> mzggVG<F5>`z
    map  <silent> <S-F5> :pc<CR>
endfunction

function! Javascript_Setting()
    setlocal ts=2 sts=2 sw=2
endfunction

" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

set nocompatible               " be iMproved
filetype off

" dein settings {{{
if &compatible
  set nocompatible
endif
" dein.vimのディレクトリ
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" なければgit clone
if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif
execute 'set runtimepath^=' . s:dein_repo_dir

call dein#begin(s:dein_dir)

" if dein#load_state(s:dein_dir)
  " call dein#begin(s:dein_dir)

  " 管理するプラグインを記述したファイル
  let s:toml = '~/.dein.toml'
  let s:lazy_toml = '~/.dein_lazy.toml'
  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  " call dein#save_state()
" endif

" vimprocだけは最初にインストールしてほしい
if dein#check_install(['vimproc'])
  call dein#install(['vimproc'])
endif
" その他インストールしていないものはこちらに入れる
if dein#check_install()
  call dein#install()
endif
" }}}

filetype plugin indent on     " required!
filetype indent on
syntax on

"--------------------
"for Unite.vim
"-------------------
nnoremap <silent> <C-u>b :<C-u>Unite buffer_tab file_mru<CR>
nnoremap <silent> <C-u>f :<C-u>Unite buffer_tab file<CR>

"--------------------
"for NERD commenter
"-------------------
" コメントした後に挿入するスペースの数
let NERDSpaceDelims = 1
" キーマップの変更。<Leader>=\+cでコメント化と解除を行う。

" コメントされていれば、コメントを外し、コメントされてなければコメント化する。
nmap <Leader>x <Plug>NERDCommenterToggle
vmap <Leader>x <Plug>NERDCommenterToggle

"--------------------
"for vim-indent-guides
"-------------------
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level=2
let g:indent_guides_auto_colors=0
let g:indent_guides_enable_on_vim_startup=0
let g:indent_guides_color_change_percent=20
let g:indent_guides_guide_size=1
let g:indent_guides_space_guides=1

hi IndentGuidesOdd  ctermbg=235
hi IndentGuidesEven ctermbg=237
au FileType coffee,ruby,javascript,python IndentGuidesEnable
nmap <silent><Leader>ig <Plug>IndentGuidesToggle

"--------------------
"for VimClojure
"-------------------
let vimclojure#HighlightBuiltins=1
let vimclojure#HighlightContrib=1
let vimclojure#DynamicHighlighting=1
let vimclojure#ParenRainbow=1

" -------------------------------
" Rsense
" -------------------------------
let g:rsenseHome = '/usr/local/Cellar/rsense/0.3/libexec'
let g:rsenseUseOmniFunc = 1

" --------------------------------
" rubocop
" --------------------------------
" syntastic_mode_mapをactiveにするとバッファ保存時にsyntasticが走る
" active_filetypesに、保存時にsyntasticを走らせるファイルタイプを指定する
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby'] }
let g:syntastic_ruby_checkers = ['rubocop']

" --------------------------------
" neocomplete.vim
" --------------------------------
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 0
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.ruby = '[^.*\t]\.\w*\|\h\w*::'

" Set async completion.
let g:monster#completion#rcodetools#backend = "async_rct_complete"

" With neocomplete.vim
let g:neocomplete#sources#omni#input_patterns = {
\   "ruby" : '[^. *\t]\.\w*\|\h\w*::',
\}

" With deoplete.nvim
let g:monster#completion#rcodetools#backend = "async_rct_complete"
let g:deoplete#sources#omni#input_patterns = {
\   "ruby" : '[^. *\t]\.\w*\|\h\w*::',
\}

let g:solarized_termcolors=256
set background=dark
" colorscheme solarized
colorscheme mycolor
" colorscheme zenburn
