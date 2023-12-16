-- Install Packer
local install_path = vim.fn.stdpath('data') ..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end

vim.api.nvim_exec(
  [[ 
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua source % | PackerCompile
  augroup end
  ]],
  false
)

-- Install plugins
local use = require('packer').use
require('packer').startup(function()
  use 'stevearc/dressing.nvim'
  use 'folke/lsp-colors.nvim'
  use 'wbthomason/packer.nvim'
  use 'adelarsq/neofsharp.vim'
  use 'jlanzarotta/bufexplorer'
  use 'junegunn/vim-easy-align'
  use 'mattn/emmet-vim'
  use 'neovim/nvim-lspconfig'
  use 'tjdevries/nlua.nvim'
  use 'tpope/vim-commentary'
  use {
    "LhKipp/nvim-nu",
    requires = {'jose-elias-alvarez/null-ls.nvim'},
    run = ":TSInstall nu",
    config = function()
      require("nu").setup{}
    end
  }

  use {
    'williamboman/mason-lspconfig.nvim',
    requires = {'williamboman/mason.nvim'},
  }

  use { 
    'tpope/vim-fugitive', 
    config = function() 
      vim.cmd[[autocmd FileType gitcommit setlocal spell]]
    end
  }
  use 'tpope/vim-rhubarb'
  use 'ray-x/lsp_signature.nvim'
  use "samjwill/nvim-unception"
  use { 'bluz71/vim-moonfly-colors', branch = 'cterm-compat' }

  use {'bfredl/nvim-luadev', ft = 'lua'}
  use {'kchmck/vim-coffee-script', ft='coffee'}
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require'colorizer'.setup {
        '*',
        css = { css = true, css_fn = true },
        scss = { css = true, css_fn = true },
      }
    end
  }

  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  -- use {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   config = function()
  --     require("copilot").setup({
  --       suggestion = { enabled = false },
  --       panel = { enabled = false },
  --     })
  --   end,
  -- }
  -- use {
  --   "zbirenbaum/copilot-cmp",
  --   after = { "copilot.lua" },
  --   config = function ()
  --     require("copilot_cmp").setup()
  --   end
  -- }

  use 'elixir-editors/vim-elixir'

  use { 
    'mrshmllow/document-color.nvim', 
    config = function()
      require("document-color").setup {
        -- Default options
        mode = "background", -- "background" | "foreground" | "single"
      }
    end
  }

  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    config = function() require'nvim-tree'.setup {
      view = {
        width = 45
      }
    } end
  }

  use {
    "akinsho/toggleterm.nvim",
    tag = '*',
    config = function()
      require'toggleterm'.setup({
        size = function(term)
          if term.direction == 'horizontal' then
            return 40
          else
            return vim.o.columns * 0.5
          end
        end,
        on_open = function(term)
          vim.cmd('startinsert!')
        end,
        shade_terminals = false,
      })
    end
  }

  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  use {
    'RRethy/vim-illuminate',
    config = function()
      vim.g.Illuminate_ftblacklist = {'NvimTree'}
    end
  }

  use {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require'cmp'

      local make_select_function = function(is_next)
        local options = {behavior = cmp.SelectBehavior.Insert}
        return function(fallback)
          if cmp.visible() then
            if is_next then
              cmp.select_next_item(options)
            else
              cmp.select_prev_item(options)
            end
          else
            fallback()
          end
        end
      end

      local down_mapping = cmp.mapping(make_select_function(true), {'i', 's'})
      local up_mapping = cmp.mapping(make_select_function(false), {'i', 's'})

      local mapping = cmp.mapping.preset.insert({
        ['<C-n>'] = down_mapping,
        ['<Down>'] = down_mapping,
        ['<C-p>'] = up_mapping,
        ['<Up>'] = up_mapping,
        ['<CR>'] = cmp.mapping.confirm({ 
          behavior = cmp.ConfirmBehavior.Replace,
          select = true 
        }),
      })

      cmp.setup({
        mapping = mapping,
        sources = cmp.config.sources({
          { name = "copilot", group_index = 2 },
          { name = 'nvim_lsp', group_index = 2 },
          { name = 'vsnip', group_index = 2 },
          { name = 'buffer', group_index = 2 },
        })
      })
  end
  }

  use {
    'windwp/nvim-autopairs',
    config = function()
      require'nvim-autopairs'.setup()
    end
  }

  use {
    'mhartington/formatter.nvim',
    config = function()
      local prettier = function()
        return {
          exe = "npx prettier",
          args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))},
          stdin = true
        }
      end

      local rbprettier = function()
        return {
          exe = "ASDF_RUBY_VERSION=3.2.2 npx prettier",
          args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))},
          stdin = true
        }
      end

      local fantomas = function()
        return {
          exe = "fantomas",
          args = {"--stdin", "--stdout", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))},
          stdin = true
        }
      end

      require('formatter').setup({
        filetype = {
          javascript = {prettier},
          typescript = {prettier},
          typescriptreact = {prettier},
          handlebars = {prettier},
          ruby = {rbprettier},
          fsharp = {fantomas}
        }
      })
    end
  }

  use { 'nvim-lualine/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = 'all',
        -- ignore_install = {'elixir'},
        highlight = {
          enable = true
        },
      })
    end
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'},
    config = function()
      local default_picker_theme = "ivy"
      require('telescope').setup({
        pickers = {
          find_files                = { theme = default_picker_theme },
          grep_string               = { theme = default_picker_theme },
          live_grep                 = { theme = default_picker_theme },
          oldfiles                  = { theme = default_picker_theme },
          current_buffer_fuzzy_find = { theme = default_picker_theme },
          commands                  = { theme = default_picker_theme },
          vim_options               = { theme = default_picker_theme },
          keymaps                   = { theme = default_picker_theme },
          lsp_references            = { theme = default_picker_theme },
          git_branches              = { theme = default_picker_theme },
        },
        extensions = {
          project = {
            base_dirs = { '~/d/src' }
          }
        }
      })
    end
  }

  use {
    'nvim-telescope/telescope-project.nvim',
    requires = {'nvim-telescope/telescope.nvim'},
    config = function()
      require('telescope').load_extension('project')
    end
  }

  use {
    'natecraddock/telescope-zf-native.nvim',
    requires = {'nvim-telescope/telescope.nvim'},
    config = function()
      require("telescope").load_extension("zf-native")
    end
  }

  use {
    'lewis6991/gitsigns.nvim',
    tag = "release",
    config = function() require('gitsigns').setup() end
  }

end)

-- Settings
vim.cmd 'syntax enable'
vim.cmd 'filetype plugin indent on'
vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile'
vim.cmd 'set nowrap'

-- set leader
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--map blankline
vim.g.indent_blankline_char = '┊'
vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
vim.g.indent_blankline_char_highlight = 'LineNr'
vim.g.indent_blankline_show_trailing_blankline_indent = false

local utils = require('utils')
utils.opt('o', 'background', 'dark')
utils.opt('o', 'termguicolors', true)
vim.opt.clipboard:prepend {'unnamedplus'}

utils.opt('o', 'updatetime', 300)
utils.opt('o', 'scrolloff', 12)
utils.opt('o', 'wildmenu', true)
utils.opt('o', 'hidden', true)
utils.opt('o', 'mouse', 'a')
utils.opt('o', 'diffopt', vim.o.diffopt .. ',vertical')
utils.opt('o', 'autochdir', true)
utils.opt('o', 'hlsearch', false)
utils.opt('w', 'cursorline', true)
utils.opt('w', 'signcolumn', 'yes')
utils.opt('b', 'swapfile', false)
utils.opt('b', 'fileencoding', 'utf8')
utils.opt('o', 'completeopt', 'menuone,noselect')

vim.wo.foldlevel = 20
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

require 'colors'
SetColors('dark')

-- Keymaps
local config_dir = vim.fn.stdpath('config')
local config_file = config_dir .. '/init.lua'
local wk = require('which-key')
wk.register({
  ['<tab>'] = { ':b#<CR>', 'Previous buffer' },
  e = { ':BufExplorer<CR>', 'Buffers' },
  o = { ':only<CR>', 'Close others' },
  g = { 
    name = 'Git',
    g = { ':G<CR>', 'Status' },
    s = { ':Telescope git_stash<cr>', 'Stash' },
    b = { ':Telescope git_branches<cr>', 'Branches' },
    B = { ':Gitsigns blame_line<cr>', 'Blame line' },
    c = { ':Telescope git_bcommits<cr>', 'Buffer commits' },
  },
  f = {
    name = 'Find',
    e = {
      name = 'Init',
      d = { ':e ' .. config_file .. '<CR>', 'Edit config' },
      R = { ':luafile ' .. config_file .. '<CR>', 'Source config' },
    },
    f = { ":lua require'telescope.builtin'.find_files({cwd = require'utils'.get_repo_root_or_cwd(), hidden = true})<cr>", 'Files' },
    r = { ":lua require'telescope.builtin'.grep_string({cwd = require'utils'.get_repo_root_or_cwd()})<cr>", 'Grep string' },
    R = { ":lua require'telescope.builtin'.live_grep({cwd = require'utils'.get_repo_root_or_cwd()})<cr>", 'Live grep' },
    l = { ':Telescope resume<cr>', 'Resume' },
    s = { ':Telescope current_buffer_fuzzy_find<cr>', 'Strings' },
    c = { ':Telescope commands<cr>', 'Commands' },
    v = { ':Telescope vim_options<cr>', 'Vim options' },
    k = { ':Telescope keymaps<cr>', 'Keymaps' },
    o = { ':Telescope oldfiles<cr>', 'Oldfiles' },
    p = { ":lua require'telescope'.extensions.project.project{}<cr>", 'Projects' }
  },
  t = {
    name = 'Tree',
    t = { 
      function()
        local repo_root = require'utils'.get_repo_root()
        local change_dir = require'nvim-tree.actions.root.change-dir'.fn
        change_dir(repo_root)
        vim.cmd[[NvimTreeFindFile]]
      end, 
      'Find' 
    },
  },
  s = {
    name = 'Session',
    s = {
      function() 
        local path = require('plenary.path')
        local session_dir = path:new(vim.fn.stdpath('data')):joinpath('sessions')
        local repo_root = path:new(require'utils'.get_repo_root())

        if not repo_root:exists() then
          print('Not in repo won\'t create session')
          return
        end

        if not session_dir:exists() then
          vim.cmd('!mkdir ' .. tostring(session_dir))
        elseif not session_dir:is_dir() then
          print('Session dir path is not a directory')
          return
        end

        local session_file_name = session_dir:joinpath(repo_root.filename:match("[^/]+$")) .. '.vim'
        local session_path = path:new(session_dir:joinpath(repo_root.filename:match("[^/]+$")) .. '.vim')

        if session_path:exists() then
          session_path:rm()
        end

        vim.cmd('mksession ' .. session_file_name)
        print('Session saved!')
      end, 
      'Save'
    },
    r = {
      function()
        local path = require('plenary.path')
        local session_dir = path:new(vim.fn.stdpath('data')):joinpath('sessions')
        local repo_root = path:new(require'utils'.get_repo_root())

        if not repo_root:exists() then
          print('Not in repo cant\'t restore session')
          return
        end

        if not session_dir:exists() then
          print('No session found')
          return
        end

        local session_name = session_dir:joinpath(repo_root.filename:match("[^/]+$")) 
        vim.cmd('source' .. session_name .. '.vim')
        print('Session restored!')
      end,
      'Restore'
    }
  },
  j = { ':1ToggleTerm direction=\'float\'<CR>', 'Toggle terminal' },
}, {prefix = '<leader>'})

wk.register({
  g = {
    a = {  ':EasyAlign<cr>', 'EasyAlign' }
  }
}, { mode = 'v' })

utils.map('n', 'Y', 'y$')
utils.map('n', '<C-h>', '<C-w>h')
utils.map('n', '<C-j>', '<C-w>j')
utils.map('n', '<C-k>', '<C-w>k')
utils.map('n', '<C-l>', '<C-w>l')
utils.map('v', '>', '>gv')
utils.map('v', '<', '<gv')
utils.map('t', '<Esc>', '<C-\\><C-n>')

-- LSP

-- Document highlight
vim.cmd [[ let g:Illuminate_delay = 300 ]]
vim.api.nvim_command [[ hi LspReferenceText  guibg='#5c6366' guifg='white' gui=NONE ]]
vim.api.nvim_command [[ hi LspReferenceWrite guibg='#5c6366' guifg='white' gui=NONE ]]
vim.api.nvim_command [[ hi LspReferenceRead  guibg='#5c6366' guifg='white' gui=NONE ]]
vim.api.nvim_command [[ hi illuminatedWord   guibg='#5c6366' guifg='white' gui=NONE ]]

vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#000000]]
vim.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]


local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  local border = {
    {"🭽", "FloatBorder"},
    {"▔", "FloatBorder"},
    {"🭾", "FloatBorder"},
    {"▕", "FloatBorder"},
    {"🭿", "FloatBorder"},
    {"▁", "FloatBorder"},
    {"🭼", "FloatBorder"},
    {"▏", "FloatBorder"},
  }

  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- On attach
local default_settings = { flags = {debounce_text_changes = 150} }

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers {
  function (server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup(default_settings)
  end,
  ["elixirls"] = function ()
    require("lspconfig").elixirls.setup(
      vim.tbl_extend('error', default_settings, {
        settings = {
          elixirLS = {
            dialyzerEnabled = false
          }
        }
      }
    ))
  end,
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    require'illuminate'.on_attach(client)
    require'lsp_signature'.on_attach({
      bind = true,
      handler_opts = {
        border = 'single'
      }
    }, bufnr)

    if client.server_capabilities.colorProvider then
      -- Attach document colour support
      require("document-color").buf_attach(bufnr)
    end

    local wk = require('which-key')
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    --Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.

    wk.register({
      K = { "<cmd>lua vim.lsp.buf.hover()<CR>", 'Hover doc' },
      g = {
        name = 'Goto',
        D = { '<cmd>lua vim.lsp.buf.declaration()<CR>', 'Declaration' },
        i = { '<cmd>lua vim.lsp.buf.implementation()<CR>', 'Implementation' },
        d = { '<cmd>Telescope lsp_definitions<CR>', 'Definition' },
        r = { '<cmd>Telescope lsp_references<CR>', 'References' },
      },
    }, { buffer = bufnr })

    wk.register({
      w = {
        name = 'Workspace',
        a = { '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', 'Add' },
        r = { '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', 'Remove' },
        l = { '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', 'List' }
      },
      m = {
        name = 'Lsp Actions',
        e = { '<cmd>lua vim.diagnostic.open_float()<CR>', 'Diagnostics' },
        a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", 'Actions' },
        r = { "<cmd>lua vim.lsp.buf.rename()<CR>", 'Rename' },
      }

    }, { 
      prefix = '<leader>', 
      buffer = bufnr
    })
  end
})

-- setup virtual text
vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
  },
  severity_sort = true,
  float = {
    source = "always",
  },
})

-- severity signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Formatter
vim.api.nvim_exec(
  [[ 
  augroup AutoFormat  
    autocmd!
    autocmd BufWritePost *.ts,*.tsx,*.hbs,*.fs,*.fsx FormatWrite
  augroup end
  ]],
  true
)
-- *.js,*.hbs,*.rb,*.rake,


vim.api.nvim_exec(
  [[ 
  augroup ElixirAutoFormat  
    autocmd!
    autocmd BufWritePost *.ex :lua vim.lsp.buf.format()
  augroup end
  ]],
  true
)

vim.api.nvim_exec(
  [[ 
  augroup Terminal
    autocmd!
    autocmd TermOpen * setlocal signcolumn=no
  augroup end
  ]],
  true
)

-- devel
--

vim.cmd [[command! -nargs=0 ReloadProject :lua require('plenary.reload').reload_module('project')]]
