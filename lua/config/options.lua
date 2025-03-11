-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt
opt.scrolloff = 19

-- tabs
opt.tabstop = 4
opt.shiftwidth = 4
--opt.expandtab = true

opt.termguicolors = true

-- disable tab character display
opt.list = false

vim.g.exrc = true

vim.g.lazyvim_php_lsp = "intelephense"

-- ensure that the root is not changing when using subprojects with npm
vim.g.root_spec = { "cwd" }
