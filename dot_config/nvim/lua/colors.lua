
vim.g.modus_dim_inactive_window = 0

SetColors = function(theme)

  local modus_vivendi_colors = {
    blue   = '#80a0ff',
    cyan   = '#79dac8',
    black  = '#080808',
    white  = '#c6c6c6',
    red    = '#ff5189',
    violet = '#d183e8',
    grey   = '#303030',
  }

  local modus_vivendi_line = {
    normal = {
      a = { fg = modus_vivendi_colors.black, bg = modus_vivendi_colors.blue },
      b = { fg = modus_vivendi_colors.white, bg = modus_vivendi_colors.grey },
      c = { fg = modus_vivendi_colors.black, bg = modus_vivendi_colors.black },
    },

    insert = { a = { fg = modus_vivendi_colors.black, bg = modus_vivendi_colors.violet } },
    visual = { a = { fg = modus_vivendi_colors.black, bg = modus_vivendi_colors.cyan } },
    replace = { a = { fg = modus_vivendi_colors.black, bg = modus_vivendi_colors.red } },

    inactive = {
      a = { fg = modus_vivendi_colors.white, bg = modus_vivendi_colors.black },
      b = { fg = modus_vivendi_colors.white, bg = modus_vivendi_colors.black },
      c = { fg = modus_vivendi_colors.black, bg = modus_vivendi_colors.black },
    },
  }

  local modus_operandi_colors = {
    blue   = '#015174',
    flow   = '#87657d',
    sway   = '#dfbec2',
    beam   = '#f8c276',
    lava   = '#434342',
    pearl  = '#f7f4f3',
    pebble = '#e9e4e0',
  }

  local modus_operandi_line = {
    normal = {
      a = { fg = modus_operandi_colors.pearl, bg = modus_operandi_colors.blue },
      b = { fg = modus_operandi_colors.lava, bg = modus_operandi_colors.pebble },
      c = { fg = modus_operandi_colors.pearl, bg = modus_operandi_colors.pearl },
    },

    insert = { a = { fg = modus_operandi_colors.pearl, bg = modus_operandi_colors.flow } },
    visual = { a = { fg = modus_operandi_colors.lava, bg = modus_operandi_colors.beam } },
    replace = { a = { fg = modus_operandi_colors.lava, bg = modus_operandi_colors.sway } },

    inactive = {
      a = { fg = modus_operandi_colors.lava, bg = modus_operandi_colors.pearl },
      b = { fg = modus_operandi_colors.lava, bg = modus_operandi_colors.pearl },
      c = { fg = modus_operandi_colors.pearl, bg = modus_operandi_colors.pearl },
    }
  }

  local lua_line = nil
  if theme == 'dark' then
    vim.cmd[[colorscheme moonfly]]
    -- vim.cmd[[colorscheme modus-vivendi]]
    -- lua_line = modus_vivendi_line
  else
    vim.cmd[[colorscheme modus-operandi]]
    lua_line = modus_operandi_line
  end

  require('lualine').setup {
    options = {
      theme = 'moonfly',
      component_separators = '|',
      section_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = {
        { 'mode', separator = { left = ' ' }, right_padding = 2 },
      },
      lualine_b = { 'filename', 'branch' },
      lualine_c = { 'fileformat' },
      lualine_x = {},
      lualine_y = { 'filetype', 'progress' },
      lualine_z = {
        { 'location', separator = { right = ' ' }, left_padding = 2 },
      },
    },
    inactive_sections = {
      lualine_a = { 'filename' },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = { 'location' },
    },
    tabline = {},
    extensions = {},
  }

end
