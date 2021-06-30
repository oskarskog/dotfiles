vim.g.mapleader = ' '

local fn = vim.fn
local execute = vim.api.nvim_command

-- Install Packer
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end
vim.cmd [[packadd packer.nvim]]
vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile'

-- Install plugins
require('packer').startup(function()
use {'wbthomason/packer.nvim', opt = true}  
use {'airblade/vim-gitgutter'}
use {'editorconfig/editorconfig-vim'}
use {'itchyny/lightline.vim'}
use {'jiangmiao/auto-pairs'}
use {'jlanzarotta/bufexplorer'}
use {'junegunn/vim-easy-align'}
use {'mattn/emmet-vim'}
use {'mustache/vim-mustache-handlebars',  ft = {'html.handlebars'}}
use {'preservim/nerdtree'}
use {'sheerun/vim-polyglot'}
use {'tpope/vim-commentary'}
use {'tpope/vim-fugitive'}
use {'eemed/sitruuna.vim'}
use {'hrsh7th/vim-vsnip'}
use {'hrsh7th/vim-vsnip-integ'}
use {
	'neoclide/coc.nvim',
	branch = 'release'
}
use {
	'nvim-telescope/telescope.nvim',
	requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
}
use {'fannheyward/telescope-coc.nvim'}
end)

-- Settings
vim.cmd 'syntax enable'
vim.cmd 'filetype plugin indent on'

local utils = require('utils')
utils.opt('o', 'background', 'dark')
utils.opt('o', 'termguicolors', true)
vim.cmd 'colorscheme sitruuna'

utils.opt('o', 'updatetime', 300)
utils.opt('o', 'wildmenu', true)
utils.opt('o', 'hidden', true)
utils.opt('o', 'mouse', 'a')
utils.opt('o', 'diffopt', vim.o.diffopt .. ',vertical')
utils.opt('o', 'clipboard', vim.o.clipboard .. 'unnamedplus')
utils.opt('w', 'cursorline', true)
utils.opt('w', 'signcolumn', 'yes')
utils.opt('b', 'swapfile', false)
utils.opt('b', 'fileencoding', 'utf8')

-- Keymaps 
local config_dir = '$HOME/.config/nvim/'
local config_file = config_dir .. 'init.lua'
utils.map('n', '<leader>fed', ':e ' .. config_file .. '<CR>')
utils.map('n', '<leader>feR', ':luafile ' .. config_file .. '<CR>')
utils.map('n', '<leader><tab>',  ':b#<CR>')
utils.map('n', '<leader>bd', ':bd<CR>')
utils.map('n', '<leader>e', ':BufExplorer<CR>')
utils.map('n', '<leader>o', ':only<CR>')
utils.map('n', '<leader>gg', ':Git<CR>')

utils.map('n', '<C-h>', '<C-w>h') 
utils.map('n', '<C-j>', '<C-w>j')
utils.map('n', '<C-k>', '<C-w>k')
utils.map('n', '<C-l>', '<C-w>l')

utils.map('n', '<leader>ff', ':Telescope git_files<cr>')
utils.map('n', '<leader>fr', ':Telescope grep_string<cr>')
utils.map('n', '<leader>fR', ':Telescope live_grep<cr>')
utils.map('n', '<leader>fs', ':Telescope current_buffer_fuzzy_find<cr>')
utils.map('n', '<leader>fb', ':Telescope git_branches<cr>')
utils.map('n', '<leader>fc', ':Telescope commands<cr>')
utils.map('n', '<leader>gs', ':Telescope git_stash<cr>')
utils.map('n', '<leader>fv', ':Telescope vim_options<cr>')
utils.map('n', 'gr', ':Telescope coc references<cr>')
utils.map('n', '<leader>ca', ':Telescope coc code_actions<cr>')
utils.map('n', '<leader>cd', ':Telescope coc diagnostics<cr>')

utils.map('n', '<leader>tt', ':NERDTreeToggle<cr>')
utils.map('n', '<leader>tf', ':NERDTreeFind<cr>')
utils.map('t', '<Esc>', '<C-\\><C-n>')

utils.map('v', 'ga', ':EasyAlign')
utils.map('x', 'ga', ':EasyAlign')

-- LSP
vim.g.coc_node_path = fn.expand('~/.nvm/versions/node/v14.15.0/bin/node')
vim.g.coc_global_extensions =  {
	'coc-actions',
	'coc-css',
	'coc-ember',
	'coc-highlight',
	'coc-html',
	'coc-json',
	'coc-snippets',
	'coc-tsserver'
}
vim.cmd('highlight CocHighlightText guibg=\'#5c6366\' guifg=\'white\'')
vim.cmd('source ' .. config_dir .. 'coc-init.vim')

-- Telescope
require('telescope').load_extension('coc')

-- NERDTree
vim.g.NERDTreeWinSize=50

-- Lightline
vim.g.lightline = {
	colorscheme = 'sitruuna',
	active = {
		left = {
			{'mode', 'paste'},
			{'gitbranch', 'readonly', 'filename', 'modified'} 
		}
	},
	component_function = {gitbranch = 'FugitiveHead'}
}
