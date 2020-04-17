call plug#begin('~/.local/share/nvim/plugged')

Plug 'sheerun/vim-polyglot'
Plug 'airblade/vim-gitgutter'
Plug 'jiangmiao/auto-pairs'
Plug 'jlanzarotta/bufexplorer'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'itchyny/lightline.vim'
Plug 'ayu-theme/ayu-vim'

Plug 'autozimu/LanguageClient-neovim', {
	\ 'branch': 'next',
	\ 'do': 'bash install.sh',
	\ }

Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
Plug 'itchyny/vim-haskell-indent', { 'for': 'haskell' }
Plug 'jpalardy/vim-slime', { 'for': 'haskell' }

call plug#end()

set termguicolors
let ayucolor="dark"
colorscheme ayu

filetype plugin indent on
syntax on

set fileencoding=utf8
set updatetime=100
set tabstop=2 shiftwidth=2 expandtab
set wildmenu
set noswapfile
set hidden
set nu
set relativenumber
set cino=(0
set mouse=a

" format json :%!python -m json.tool 

" Language servers
let g:LanguageClient_serverCommands = {
	\ 'rust': [ '~/.cargo/bin/rustup', 'run', 'nightly', 'rls' ],
	\ 'cpp': [ 'clangd' ],
	\ 'c': [ 'clangd' ],
	\ }

set formatexpr=LanguageClient_textDocument_rangeFormatting()

" Use deoplete completion engine
let g:deoplete#enable_at_startup = 1
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif

" General bindings
let mapleader=' '
inoremap fd <esc>
nnoremap <silent><leader>fed :e /home/oskar/.config/nvim/init.vim<cr>
nnoremap <silent><leader>feR :source /home/oskar/.config/nvim/init.vim<cr>
nnoremap <silent><leader><tab> :b#<cr>
nnoremap <silent><leader>bd :bd<cr>
nnoremap <silent><leader>e :BufExplorer<cr>
nnoremap <silent><leader>o :only<cr>
nnoremap <silent><leader>gs :Gstatus<cr>

" Lang server bindings
function LC_maps()
	if has_key(g:LanguageClient_serverCommands, &filetype)
		nnoremap <buffer> <silent><leader>m :call LanguageClient_contextMenu()<cr>
		nnoremap <buffer> <silent><leader>d :call LanguageClient#textDocument_definition()<cr>
		nnoremap <buffer> <silent><leader>r :call LanguageClient#textDocument_rename()<cr>
		nnoremap <buffer> <silent>K :call LanguageClient#textDocument_hover()<cr>
	endif
endfunction

autocmd FileType * call LC_maps()

" slime setup
let g:slime_target = "tmux"
let g:slime_paste_file = tempname()
let g:slime_default_config = {
            \"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.2"
            \}
