local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        -- "tutor",
        "zipPlugin",
      },
    },
  },
})

-- harpoon

local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>a", function()
  harpoon:list():add()
end)
-- vim.keymap.set("n", "<C-e>", function()
--   harpoon.ui:toggle_quick_menu(harpoon:list())
-- end)
--
local fzf = require("fzf-lua")
local fzf_actions = require("fzf-lua.actions")
local function harpoon_fzf_picker(harpoon_files)
  local entries = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(entries, item.value)
  end

  fzf.fzf_exec(entries, {
    previewer = "builtin",
    prompt = "Harpoon > ",
    actions = {
      ["default"] = function(selected)
        fzf_actions.file_edit(selected, {})
      end,
      ["ctrl-x"] = function(selected)
        local files = harpoon:list()
        for _, item in ipairs(files.items) do
          if item.value == selected[1] then
            harpoon:list():remove(item)
            harpoon_fzf_picker(files)
            break
          end
        end
      end,
    },
  })
end

vim.keymap.set("n", "<C-e>", function()
  harpoon_fzf_picker(harpoon:list())
end, { desc = "Harpoon FZF" })

-- vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
-- vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
-- vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
-- vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)
--
-- Toggle previous & next buffers stored within Harpoon list
-- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
-- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

-- require("lspconfig").intelephense.setup({
--   settings = {
--     intelephense = {
--       files = {
--         exclude = {
--           "**/.git", -- Keep ignoring the `.git` folder
--           "**/node_modules", -- Ignore `node_modules`
--           "!app/cache/autoclasses/**", -- Exclude all, but include `custom_folder`
--         },
--       },
--     },
--   },
-- })

--
-- require("telescope").setup({
--   defaults = {
--     vimgrep_arguments = {
--       "rg",
--       "--color=never",
--       "--no-heading",
--       "--with-filename",
--       "--line-number",
--       "--column",
--       "--smart-case",
--       "--hidden",
--       "--no-ignore-vcs",
--     },
--   },
--   pickers = {
--     find_files = {
--       -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
--       find_command = {
--         "rg",
--         "--no-ignore",
--         "--files",
--         "--hidden",
--         "--glob",
--         "!**/.git/*",
--         "--glob",
--         "!**/node_modules/*",
--         "--glob",
--         "!**/.idea/*",
--         "--glob",
--         "!**/var/cache/*",
--       },
--     },
--   },
-- })
