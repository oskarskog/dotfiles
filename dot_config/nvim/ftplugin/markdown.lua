local tabwidth = 2
vim.bo.tabstop = tabwidth
vim.bo.shiftwidth = tabwidth
vim.bo.softtabstop = tabwidth
vim.bo.expandtab = true
vim.cmd 'set wrap'

--autocmd BufRead,BufNewFile *.md setlocal textwidth=80
--
vim.cmd[[
  autocmd FileType markdown setlocal spell
]]
