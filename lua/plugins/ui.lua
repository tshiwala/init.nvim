-- ============================================================================
-- UI Enhancements
-- Modern UI plugins for better visual experience
-- ============================================================================

return {
  -- ==========================================================================
  -- Indent Guides
  -- ==========================================================================
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = {
        char = "▏",
        tab_char = "▏",
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = false,
      },
      exclude = {
        filetypes = {
          "help",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },

  -- ==========================================================================
  -- Rainbow Delimiters (Treesitter-based)
  -- ==========================================================================
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("rainbow-delimiters.setup").setup({
        strategy = {
          [""] = require("rainbow-delimiters").strategy["global"],
          vim = require("rainbow-delimiters").strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      })
    end,
  },

  -- ==========================================================================
  -- Color Highlighter
  -- ==========================================================================
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = true,
        RRGGBBAA = true,
        AARRGGBB = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
        tailwind = true,
        sass = { enable = true, parsers = { "css" } },
        virtualtext = "■",
      },
      buftypes = {},
    },
  },

  -- ==========================================================================
  -- Notification System
  -- ==========================================================================
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      stages = "fade_in_slide_out",
      background_colour = "#000000",
      render = "default",
      minimum_width = 50,
      icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
      },
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify
    end,
  },

  -- ==========================================================================
  -- Better UI for inputs and selects
  -- ==========================================================================
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        enabled = true,
        default_prompt = "➤ ",
        win_options = {
          winblend = 0,
        },
      },
      select = {
        enabled = true,
        backend = { "telescope", "builtin" },
        builtin = {
          win_options = {
            winblend = 0,
          },
        },
      },
    },
  },

  -- ==========================================================================
  -- Web DevIcons
  -- ==========================================================================
  {
    "echasnovski/mini.icons",
    lazy = false,  -- Load immediately so icons are available
    priority = 200,  -- Load before other plugins that need icons
    opts = {},
    config = function(_, opts)
      local icons = require("mini.icons")
      icons.setup(opts)
      MiniIcons.mock_nvim_web_devicons()  -- Provide icons to plugins expecting devicons
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {
      override = {},
      default = true,
    },
  },

  -- ==========================================================================
  -- Smooth Scrolling
  -- ==========================================================================
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = false,
      cursor_scrolls_alone = true,
      easing_function = "sine",
      pre_hook = nil,
      post_hook = nil,
      performance_mode = false,
    },
  },

  -- ==========================================================================
  -- Material Theme (Lua version)
  -- ==========================================================================
  {
    "marko-cerovac/material.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("material").setup({
        contrast = {
          terminal = false,
          sidebars = false,
          floating_windows = false,
          cursor_line = false,
          non_current_windows = false,
          filetypes = {},
        },
        styles = {
          comments = { italic = true },
          strings = {},
          keywords = {},
          functions = {},
          variables = {},
          operators = {},
          types = {},
        },
        plugins = {
          "coc",
          "dashboard",
          "gitsigns",
          "indent-blankline",
          "neo-tree",
          "nvim-cmp",
          "nvim-web-devicons",
          "telescope",
          "trouble",
          "which-key",
        },
        disable = {
          colored_cursor = false,
          borders = false,
          background = false,
          term_colors = false,
          eob_lines = false,
        },
        high_visibility = {
          lighter = false,
          darker = false,
        },
        lualine_style = "default",
        async_loading = true,
        custom_colors = nil,
        custom_highlights = {},
      })

      -- Set material oceanic theme
      vim.g.material_style = "oceanic"
      vim.cmd("colorscheme material")

      -- Custom highlights (from your init.vim)
      vim.cmd([[
        hi Pmenu guibg=#00010a guifg=white
        hi Comment gui=italic cterm=italic
        hi Search guibg=#b16286 guifg=#ebdbb2 gui=NONE
        hi NonText guifg=bg
        hi clear CursorLineNr
        hi CursorLineNr gui=bold
        hi SpellBad guifg=NONE gui=bold,undercurl
        hi DiffAdd guibg=#0f111a guifg=#43a047
        hi DiffChange guibg=#0f111a guifg=#fdd835
        hi DiffRemoved guibg=#0f111a guifg=#e53935
        hi CocCursorRange guibg=#b16286 guifg=#ebdbb2
      ]])
    end,
  },
}
