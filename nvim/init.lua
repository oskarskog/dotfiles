vim.g.mapleader = ' '

local fn = vim.fn
local execute = vim.api.nvim_command

-- Install Packer
local install_path = fn.stdpath('data') ..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end
vim.cmd [[packadd packer.nvim]]
vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile'

-- Install plugins
require('packer').startup(function()

	use {
		'wbthomason/packer.nvim',
		opt = true
	}

	use {
		'fannheyward/telescope-coc.nvim',
		config = function() require('telescope').load_extension('coc') end
	}

	use {
		'famiu/feline.nvim',
		requires = {'kyazdani42/nvim-web-devicons'},
	}

	use {
		'mustache/vim-mustache-handlebars',
		ft = {'html.handlebars'}
	}

	use {
		'neoclide/coc.nvim',
		branch = 'release'
	}

	use {
		'nvim-telescope/telescope.nvim',
		requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'}
	}

	use {
		'lewis6991/gitsigns.nvim',
		requires = {'nvim-lua/plenary.nvim'},
		config = function() require('gitsigns').setup() end
	}

	use {
		"numtostr/FTerm.nvim",
		config = function() require("FTerm").setup() end
	}

	use 'editorconfig/editorconfig-vim'
	use 'jiangmiao/auto-pairs'
	use 'jlanzarotta/bufexplorer'
	use 'junegunn/vim-easy-align'
	use 'mattn/emmet-vim'
	use 'preservim/nerdtree'
	use 'sheerun/vim-polyglot'
	use 'tpope/vim-commentary'
	use 'tpope/vim-fugitive'
	use 'eemed/sitruuna.vim'
	use 'hrsh7th/vim-vsnip'
	use 'hrsh7th/vim-vsnip-integ'
	use 'karb94/neoscroll.nvim'
	use 'christoomey/vim-tmux-navigator'
end)

-- Settings
vim.cmd 'syntax enable'
vim.cmd 'filetype plugin indent on'
vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile'

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
vim.g.NERDTreeWinSize=50

-- Keymaps
local config_dir = '$HOME/.config/nvim/'
local config_file = config_dir .. 'init.lua'
utils.map('n', '<leader>fed', 	':e ' .. config_file .. '<CR>')
utils.map('n', '<leader>feR', 	':luafile ' .. config_file .. '<CR>')
utils.map('n', '<leader><tab>', ':b#<CR>')
utils.map('n', '<leader>e', 		':BufExplorer<CR>')
utils.map('n', '<leader>o', 		':only<CR>')
utils.map('n', '<leader>gg', 		':Git<CR>')

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
utils.map('n', '<leader>fk', ':Telescope keymaps<cr>')
utils.map('n', '<leader>fo', ':Telescope oldfiles<cr>')
utils.map('n', 'gr', 				 ':Telescope coc references<cr>')
utils.map('n', '<leader>ca', ':Telescope coc code_actions<cr>')
utils.map('n', '<leader>cd', ':Telescope coc diagnostics<cr>')

utils.map('n', '<leader>tT', ':NERDTreeToggle<cr>')
utils.map('n', '<leader>tt', ':NERDTreeFind<cr>')
utils.map('v', 'ga', ':EasyAlign')
utils.map('x', 'ga', ':EasyAlign')

utils.map('n', '<leader>\'', '<CMD>lua require("FTerm").toggle()<CR>')
utils.map('t', '<leader>\'', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
utils.map('t', '<Esc>', '<C-\\><C-n>')

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

-- Scrolling
require('neoscroll').setup({
		-- All these keys will be mapped to their corresponding default scrolling animation
		mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
		hide_cursor = true,          -- Hide cursor while scrolling
		stop_eof = true,             -- Stop at <EOF> when scrolling downwards
		use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
		respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
		cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
		easing_function = nil        -- Default easing function
	})

-- Status line
require'nvim-web-devicons'.setup {default = true}
local components = require('feline.presets').default.components
local properties = require('feline.presets').default.properties
table.remove(components.left.active, 4)
table.remove(components.left.active, 4)
table.insert(components.right.active, 1, {provider='position'})

require('feline').setup({
		components = components,
		properties = properties
	})
