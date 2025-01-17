return {
  -- disable indentation markers and speed up scolling
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.indent.enabled = false
      opts.scroll.animate = {
        duration = { step = 15, total = 100 },
        easing = "linear",
      }
      return opts
    end,
  },
  -- display the full path in lualine
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_c[4] = { LazyVim.lualine.pretty_path({ length = 0 }) }
    end,
  },
  -- disable code style checker for php as it is very noicy on existing projects
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        php = {}, -- was { "phpcs" }
      },
    },
  },
}
