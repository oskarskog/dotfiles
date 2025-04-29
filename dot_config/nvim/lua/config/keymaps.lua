-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<leader>gg", ":Git<cr>")
map("t", "<esc>", [[<C-\><C-n>]])
map("n", "<leader>j", "<cmd>ToggleTerm<cr>", { desc = "Open a horizontal terminal at the Desktop directory" })

map({ "n", "t" }, "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map({ "n", "t" }, "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map({ "n", "t" }, "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map({ "n", "t" }, "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })
