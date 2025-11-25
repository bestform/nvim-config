-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

local map = vim.keymap.set
local wk = require("which-key")

map("n", "<leader>H", "<cmd>LazyHealth<cr>", { desc = "Lazy Health Check" })
map("n", "<leader>k", "<cmd>Fzf keymaps<cr>", { desc = "Keymap" })
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous Buffer" })
map("n", "<leader>cn", "<cmd>cnext<cr>", { desc = "Next quickfix item" })
map("n", "<leader>cp", "<cmd>cprev<cr>", { desc = "Previous quickfix item" })

vim.api.nvim_set_keymap("n", "<Leader>dd", ":lua vim.diagnostic.open_float()<CR>", { noremap = true, silent = true })

-- lua execute commands
wk.add({ "<leader>X", group = "LUA" })
vim.keymap.set("n", "<Leader>Xf", "<cmd>source %<CR>", { desc = "execute LUA file" })
vim.keymap.set("n", "<Leader>Xl", ":.lua<CR>", { desc = "execute LUA line" })
vim.keymap.set("v", "<Leader>Xs", ":lua<CR>", { desc = "execute LUA selection" })

-- treesj
map("n", "<leader>m", require("treesj").toggle, { desc = "Toggle Treesj" })

--- debugger
vim.keymap.set("n", "<F9>", function()
  require("dap").continue()
end)
vim.keymap.set("n", "<F8>", function()
  require("dap").step_over()
end)
vim.keymap.set("n", "<F7>", function()
  require("dap").step_into()
end)
vim.keymap.set("n", "<F12>", function()
  require("dap").step_out()
end)
vim.keymap.set("n", "<Leader>db", function()
  require("dap").toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<Leader>dr", function()
  require("dap").repl.open()
end)
vim.keymap.set("n", "<Leader>dl", function()
  require("dap").run_last()
end)
vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
  require("dap.ui.widgets").hover()
end)
vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
  require("dap.ui.widgets").preview()
end)
vim.keymap.set("n", "<Leader>df", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.frames)
end)
vim.keymap.set("n", "<Leader>ds", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.scopes)
end)

vim.keymap.set("n", "ö", "[")
vim.keymap.set("n", "ä", "]")

-- neotest

wk.add({ "<leader>t", group = "tests" })

map("n", "<leader>tt", function()
  require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Neotest Run File" })

map("n", "<leader>tf", function()
  require("neotest").run.run()
end, { desc = "Neotest Run Nearest" })

map("n", "<leader>ts", "<cmd>Neotest summary<cr>", { desc = "Neotest Summary" })
map("n", "<leader>to", "<cmd>Neotest output-panel<cr>", { desc = "Neotest Output Panel" })

-- surround
vim.keymap.set("v", "(", "c(<ESC>pa)")
vim.keymap.set("v", "'", "c'<ESC>pa'")
vim.keymap.set("v", '"', 'c"<ESC>pa"')
vim.keymap.set("v", "[", "c[<ESC>pa]")
vim.keymap.set("v", "{", "c{<ESC>pa}")
