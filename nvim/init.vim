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
Plug 'morhetz/gruvbox'

Plug 'autozimu/LanguageClient-neovim', {
	\ 'branch': 'next',
	\ 'do': 'bash install.sh',
	\ }

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
Plug 'itchyny/vim-haskell-indent', { 'for': 'haskell' }
Plug 'jpalardy/vim-slime', { 'for': 'haskell' }

call plug#end()

set termguicolors
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox

filetype plugin indent on
syntax on

set fileencoding=utf8
set updatetime=100
set tabstop=4 shiftwidth=4 expandtab
set wildmenu
set noswapfile
set hidden
set nu
set relativenumber
set mouse=a
set diffopt+=vertical

" format json :%!python -m json.tool 

" Language servers
let g:LanguageClient_serverCommands = {
      \ 'cpp': [ 'clangd' ],
      \ 'c': [ 'clangd' ],
      \ 'rust': [ '/usr/bin/rustup', 'run', 'nightly', 'rls' ],
      \ 'javascript': ['javascript-typescript-stdio'],
      \ 'typescript': ['javascript-typescript-stdio'],
      \ }

let g:LanguageClient_rootMarkers = {
      \ 'javascript': ['jsconfig.json'],
      \ 'typescript': ['tsconfig.json'],
      \ }


set formatexpr=LanguageClient_textDocument_rangeFormatting()

" lightline show git branch
let g:lightline = {
            \ 'colorscheme': 'wombat',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
            \ },
            \ 'component_function': {
            \   'gitbranch': 'FugitiveHead'
            \ },
            \ }

" Use deoplete completion engine
let g:deoplete#enable_at_startup = 1
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif

" General bindings
let mapleader=' '
nnoremap <silent><leader>fed :e /home/oskar/.config/nvim/init.vim<cr>
nnoremap <silent><leader>feR :source /home/oskar/.config/nvim/init.vim<cr>
nnoremap <silent><leader><tab> :b#<cr>
nnoremap <silent><leader>bd :bd<cr>
nnoremap <silent><leader>e :BufExplorer<cr>
nnoremap <silent><leader>o :only<cr>
nnoremap <silent><leader>gs :Gstatus<cr>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <silent><leader>ff :Files<cr>
nnoremap <silent><leader>fr :Rg<cr>
nnoremap <silent><leader>fs :BLines<cr>

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

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

" insert date in current buffer
if !exists(":Date")
  command Date :put =strftime('%b %d, %Y')
endif

