return {
  -- {
  --   "nvim-treesitter/nvim-treesitter-context",
  -- },
  -- {
  --   "mini.surround",
  -- },
  -- {
  --   "ThePrimeagen/vim-be-good",
  -- },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      vim.keymap.set("n", "<leader>A", function()
        harpoon:list():remove()
        harpoon:list():add()
      end, { desc = "Add file to Harpoon" })
      local fzf = require("fzf-lua")
      local fzf_actions = require("fzf-lua.actions")
      local function harpoon_fzf_picker(harpoon_files)
        local entries = {}
        for _, item in ipairs(harpoon_files.items) do
          if item ~= nil then
            table.insert(entries, item.value .. ":" .. item.context.row .. ":" .. item.context.col)
          end
        end

        fzf.fzf_exec(entries, {
          previewer = "builtin",
          prompt = "Harpoon > ",
          actions = {
            ["default"] = function(selected)
              fzf_actions.file_edit(selected, {})
              -- harpoon.ui:nav_file()
            end,
            ["ctrl-x"] = function(selected)
              local value = string.gmatch(selected[1], "([^:]+)")
              local valueToRemove = value()
              local original_list = harpoon:list().items
              harpoon:list():clear()
              for _, item in ipairs(original_list) do
                if item.value ~= valueToRemove then
                  harpoon:list():add(item)
                end
              end

              -- local item = harpoon:list():get_by_value(value())
              -- harpoon:list():remove(item)
              harpoon_fzf_picker(harpoon:list())
            end,
          },
        })
      end

      vim.keymap.set("n", "<C-t>", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)
      vim.keymap.set("n", "<C-e>", function()
        harpoon_fzf_picker(harpoon:list())
      end, { desc = "Harpoon FZF" })
    end,
  },
  {
    "sotte/presenting.nvim",
    opts = {
      options = {
        width = 120,
      },
      separator = {
        markdown = "^---",
      },
      keep_separator = false,
    },
    cmd = { "Presenting" },
  },
  --   {
  --     "zenbones-theme/zenbones.nvim",
  --     -- Optionally install Lush. Allows for more configuration or extending the colorscheme
  --     -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
  --     -- In Vim, compat mode is turned on as Lush only works in Neovim.
  --     dependencies = "rktjmp/lush.nvim",
  --     lazy = false,
  --     priority = 1000,
  --     -- you can set set configuration options here
  --     config = function()
  --       -- vim.g.zenbones_darken_comments = 45
  --       -- vim.cmd.colorscheme("tokyobones")
  --     end,
  --   },
  -- },
  {
    "rebelot/kanagawa.nvim",
    -- config = function()
    --   vim.cmd.colorscheme("kanagawa-wave")
    -- end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    },
  },
  {
    "NMAC427/guess-indent.nvim", -- Detect tabstop and shiftwidth automatically
  },
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },
  { "dmmulroy/ts-error-translator.nvim" },
  {
    "Wansmer/treesj",
    -- keys = { "<space>m", "<space>j", "<space>s" },
    dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
        langs = {
          typescript = {
            array = {
              both = {
                last_separator = true,
              },
            },
            object = {
              both = {
                last_separator = true,
              },
            },
            formal_parameters = {
              split = {
                last_separator = true,
              },
            },
            statement_block = {
              join = {
                force_insert = "", -- avoid adding semicolons
              },
            },
          },
        },
      })
    end,
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "marilari88/neotest-vitest",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-vitest")({
            -- Filter directories when searching for test files. Useful in large projects (see Filter directories notes).
            filter_dir = function(name, rel_path, root)
              print("checking " .. name)
              return name ~= "node_modules"
            end,
          }),
        },
      })
    end,
  },
}
