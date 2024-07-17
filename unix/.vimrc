" 文字コードをUTF-8に設定
set fenc=utf-8
" バックアップファイルを作成しない
set nobackup
" スワップファイルを作成しない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" 別のファイルを開いてもバッファを破棄しない？
set hidden
" クリップボード連携
set clipboard+=unnamed



" 行番号を表示する
set number
" 現在の行を目立たせる
set cursorline
" コマンドをステータスに表示
set showcmd
" コマンドラインの補完
set wildmenu
" ステータスラインを常に表示
set laststatus=2
" インデントの幅を設定
set shiftwidth=4
" タブ文字の幅を設定
set tabstop=4
" 不可視文字を可視化
set list listchars=tab:»·,trail:·,eol:$



" シンタックスハイライト
syntax enable
" インデントを自動で調整する
set smartindent
" 括弧の対応関係を自動表示
set showmatch



" 検索時に大文字小文字を区別しない
set ignorecase
" 検索時に大文字がある場合は区別する
set smartcase
" 検索文字列が入力されたら即時に検索する
set incsearch
" 検索文字列を入力中にハイライト表示
set hlsearch
" 検索時に最後まで行ったら一番上に戻る
set wrapscan



colorscheme murphy
set background=dark
