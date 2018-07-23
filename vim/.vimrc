"## 基本設定#########################################################
set termencoding=utf-8
set encoding=utf-8
""set encoding=japan
"set fileencodings=sjis
set fileencoding=utf-8
set fileencodings=utf-8,ucs-bom,iso-2022-jp-3,euc-jp,euc-jisx0213
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

set modeline

"undoファイル(*.un~)を一箇所にまとめる
set undodir=~/tmp

"swpファイルの出力先
set directory=~/tmp

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
nnoremap <silent> <C-u>b :<C-u>Unite buffer<CR>
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
"au FileType coffee,ruby,javascript,python IndentGuidesEnable
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

" for vim-jsx
let g:jsx_ext_required = 0

" for vim-vue
au BufRead,BufNewFile *.vue setfiletype html

let g:solarized_termcolors=256
set background=dark
" colorscheme solarized
colorscheme mycolor
" colorscheme zenburn

" for ctrlp
let g:ctrlp_custom_ignore = '\v[\/](node_modules|build)$'

"for airline
" let g:airline_powerline_fonts = 1
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" --------------------------------
" tabline setting
" http://qiita.com/wadako111/items/755e753677dd72d8036d
" --------------------------------
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ
map <silent> [Tag]t :Unite tab<CR>
" tp 前のタブ

" --------------------------------
" json formatting by jq
" http://qiita.com/tekkoc/items/324d736f68b0f27680b8
" --------------------------------
command! -nargs=? Jq call s:Jq(<f-args>)
function! s:Jq(...)
    if 0 == a:0
        let l:arg = "."
    else
        let l:arg = a:1
    endif
    execute "%! jq \"" . l:arg . "\""
endfunction

" --------------------------------
" poweryank
" --------------------------------
map <Leader>y <Plug>(operator-poweryank-osc52)

augroup vimrc-incsearch-highlight
  autocmd!
  autocmd CmdlineEnter [/\?] :set hlsearch
  autocmd CmdlineLeave [/\?] :set nohlsearch
augroup END

" --------------------------------
" ruby-formatter/rufo-vim
" --------------------------------
let g:rufo_auto_formatting = 0
