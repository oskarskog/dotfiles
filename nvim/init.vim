call plug#begin('~/.local/share/nvim/plugged')

Plug 'sheerun/vim-polyglot'
Plug 'airblade/vim-gitgutter'
Plug 'jiangmiao/auto-pairs'
Plug 'jlanzarotta/bufexplorer'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'itchyny/lightline.vim'
Plug 'morhetz/gruvbox'
Plug 'jpalardy/vim-slime'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'stsewd/fzf-checkout.vim'

call plug#end()

set termguicolors
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox

filetype plugin indent on
syntax on

set fileencoding=utf8
set updatetime=300
set tabstop=4 shiftwidth=4 expandtab
set wildmenu
set noswapfile
set hidden
set nu
set relativenumber
set mouse=a
set diffopt+=vertical

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

" slime setup
let g:slime_target = "tmux"
let g:slime_paste_file = tempname()
let g:slime_default_config = {
            \"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.1"
            \}

" insert date in current buffer
if !exists(":Date")
  command Date :put =strftime('%b %d, %Y')
endif

" FZF
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'

" Coc
source ~/.config/nvim/coc-init.vim
