local tabwidth = 2
vim.bo.tabstop = tabwidth
vim.bo.shiftwidth = tabwidth
vim.bo.softtabstop = tabwidth
vim.bo.expandtab = true

vim.cmd [[vnoremap <buffer> <leader>E :lua require'luadev'.exec(require'utils'.get_selection())<CR>]]
