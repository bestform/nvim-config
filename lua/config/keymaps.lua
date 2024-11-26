-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

local map = vim.keymap.set

map("n", "<leader>H", "<cmd>LazyHealth<cr>", { desc = "Lazy Health Check" })
map("n", "<leader>k", "<cmd>Telescope keymaps<cr>", { desc = "Keymap" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous Buffer" })
