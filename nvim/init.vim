call plug#begin('~/.local/share/nvim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'editorconfig/editorconfig-vim'
Plug 'honza/vim-snippets'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'jlanzarotta/bufexplorer'
Plug 'junegunn/vim-easy-align'
Plug 'mattn/emmet-vim'
Plug 'morhetz/gruvbox'
Plug 'mustache/vim-mustache-handlebars', { 'for': ['mustache', 'handlebars'] }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree' 
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'eemed/sitruuna.vim'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

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
set clipboard=unnamedplus

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

nnoremap <silent><leader>ff :Telescope git_files<cr>
nnoremap <silent><leader>fr :Telescope grep_string<cr>
nnoremap <silent><leader>fR :Telescope live_grep<cr>
nnoremap <silent><leader>fs :Telescope current_buffer_fuzzy_find<cr>
nnoremap <silent><leader>fb :Telescope git_branches<cr>
nnoremap <silent><leader>fc :Telescope commands<cr>
nnoremap <silent><leader>gs :Telescope git_stash<cr>

nnoremap <silent><leader>tt :NERDTreeToggle<cr>
nnoremap <silent><leader>tf :NERDTreeFind<cr>

vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" insert date in current buffer
if !exists(":Date")
  command Date :put =strftime('%b %d, %Y')
endif

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

command! Scratch lua require'tools'.makeScratch()
