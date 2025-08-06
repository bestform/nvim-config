-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local group_prefix = "bestform_"

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = vim.api.nvim_create_augroup(group_prefix .. "auto-save", { clear = true }),
  callback = function()
    -- acwrite is the filetype of the oil buffer
    if vim.o.buftype ~= "nofile" and vim.o.buftype ~= "acwrite" then
      vim.cmd("!silent write")
      -- print("saved")
    end
  end,
})
