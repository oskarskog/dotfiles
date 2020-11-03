call plug#begin('~/.local/share/nvim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'editorconfig/editorconfig-vim'
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
Plug 'sheerun/vim-polyglot'
Plug 'stsewd/fzf-checkout.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'

call plug#end()

set termguicolors
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox

filetype plugin indent on
syntax on

set fileencoding=utf8
set updatetime=300
set wildmenu
set noswapfile
set hidden
set nu
set relativenumber
set mouse=a
set diffopt+=vertical
set cursorline
set shell=zsh

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
nnoremap <silent><leader>gs :Gstatus<cr>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <silent><leader>ff :Files<cr>
nnoremap <silent><leader>fr :Rg<cr>
nnoremap <silent><leader>fs :BLines<cr>
nnoremap <silent><leader>fb :GBranches<cr>
nnoremap <silent><leader>fg :GFiles<cr>

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
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'

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

let g:coc_node_path = '/Users/oskar/.nvm/versions/node/v14.15.0/bin/node'
let g:coc_global_extensions = [
            \ 'coc-actions',
            \ 'coc-highlight',
            \ 'coc-css',
            \ 'coc-ember',
            \ 'coc-highlight',
            \ 'coc-html',
            \ 'coc-json',
            \ 'coc-tsserver',
            \ 'coc-vimlsp',
            \ ]
