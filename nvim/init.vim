call plug#begin('~/.local/share/nvim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'editorconfig/editorconfig-vim'
Plug 'honza/vim-snippets'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'jlanzarotta/bufexplorer'
Plug 'jpalardy/vim-slime'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-easy-align'
Plug 'mattn/emmet-vim'
Plug 'morhetz/gruvbox'
Plug 'mustache/vim-mustache-handlebars', { 'for': ['mustache', 'handlebars'] }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree' 
Plug 'sheerun/vim-polyglot'
Plug 'stsewd/fzf-checkout.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'eemed/sitruuna.vim'

call plug#end()

set termguicolors
set background=dark
colorscheme sitruuna
let g:sitruuna_fzf = 1

filetype plugin indent on
syntax on

set fileencoding=utf8
set updatetime=300
set wildmenu
set noswapfile
set hidden
set mouse=a
set diffopt+=vertical
set cursorline

packadd cfilter

" lightline show git branch
let g:lightline = {
      \ 'colorscheme': 'sitruuna',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" Terminal
tnoremap <Esc> <C-\><C-n>
augroup term_mode
  au!
  au TermOpen * setlocal nonumber norelativenumber
augroup end

" General bindings
let mapleader=' '
nnoremap <silent><leader>fed :e $HOME/.config/nvim/init.vim<cr>
nnoremap <silent><leader>feR :source $HOME/.config/nvim/init.vim<cr>
nnoremap <silent><leader><tab> :b#<cr>
nnoremap <silent><leader>bd :bd<cr>
nnoremap <silent><leader>e :BufExplorer<cr>
nnoremap <silent><leader>o :only<cr>
nnoremap <silent><leader>gg :Git<cr>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <silent><leader>ff :GFiles<cr>
nnoremap <silent><leader>fr :Rg<cr>
nnoremap <silent><leader>fs :BLines<cr>
nnoremap <silent><leader>fb :GBranches<cr>
nnoremap <silent><leader>fc :Commands<cr>
nnoremap <silent><leader>tt :NERDTreeToggle<cr>
nnoremap <silent><leader>tf :NERDTreeFind<cr>

vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

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
let g:fzf_layout = { 'down': '40%' }
let $FZF_DEFAULT_OPTS='--reverse --bind ctrl-a:select-all'
autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>

let g:fzf_branch_actions = {
      \ 'checkout': {
      \   'prompt': 'Checkout> ',
      \   'execute': 'echo system("{git} checkout {branch}")',
      \   'multiple': v:false,
      \   'keymap': 'enter',
      \   'required': ['branch'],
      \   'confirm': v:false,
      \ },
      \ 'track': {
      \   'prompt': 'Track> ',
      \   'execute': 'echo system("{git} checkout --track {branch}")',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-t',
      \   'required': ['branch'],
      \   'confirm': v:false,
      \ },
      \ 'create': {
      \   'prompt': 'Create> ',
      \   'execute': 'echo system("{git} checkout -b {input}")',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-b',
      \   'required': ['input'],
      \   'confirm': v:false,
      \ },
      \ 'delete': {
      \   'prompt': 'Delete> ',
      \   'execute': 'echo system("{git} branch -D {branch}")',
      \   'multiple': v:true,
      \   'keymap': 'ctrl-d',
      \   'required': ['branch'],
      \   'confirm': v:true,
      \ },
      \}

" Coc
source ~/.config/nvim/coc-init.vim
augroup hbs_ft
  au!
  autocmd BufNewFile,BufRead *.hbs set ft=handlebars
augroup end


highlight CocHighlightText guibg='#5c6366' guifg='white'

let g:coc_node_path = $HOME . '/.nvm/versions/node/v14.15.0/bin/node'
let g:coc_global_extensions = [
      \ 'coc-actions',
      \ 'coc-css',
      \ 'coc-ember',
      \ 'coc-highlight',
      \ 'coc-html',
      \ 'coc-json',
      \ 'coc-snippets',
      \ 'coc-tsserver',
      \ 'coc-vimlsp',
      \ ]

" NERDTree
let g:NERDTreeWinSize=50
