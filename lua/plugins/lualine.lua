-- ============================================================================
-- Lualine Configuration
-- Modern statusline replacing custom statusline.vim
-- Material Ocean theme with mode-aware colors
-- ============================================================================

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      -- Material Ocean colors (matching your theme)
      local colors = {
        bg = "#0f111a",
        fg = "#eeffff",
        yellow = "#ffcb6b",
        cyan = "#89ddff",
        darkblue = "#82aaff",
        green = "#c3e88d",
        orange = "#f78c6c",
        violet = "#c792ea",
        magenta = "#c792ea",
        blue = "#82aaff",
        red = "#f07178",
        pink = "#ff5370",
      }

      -- Mode-specific colors (matching your custom statusline)
      local mode_colors = {
        n = colors.pink,      -- Normal: Pink/red
        i = colors.green,     -- Insert: Green
        v = colors.blue,      -- Visual: Blue
        V = colors.blue,      -- Visual Line: Blue
        [""] = colors.blue, -- Visual Block: Blue
        c = colors.orange,    -- Command: Red-orange
        no = colors.pink,     -- Operator-pending: Pink
        s = colors.violet,    -- Select: Violet
        S = colors.violet,    -- Select Line: Violet
        [""] = colors.violet,-- Select Block: Violet
        ic = colors.yellow,   -- Insert completion: Yellow
        R = colors.violet,    -- Replace: Purple-ish
        Rv = colors.violet,   -- Virtual Replace: Purple-ish
        cv = colors.orange,   -- Command-line Ex: Orange
        ce = colors.orange,   -- Ex: Orange
        r = colors.cyan,      -- Hit-enter prompt: Cyan
        rm = colors.cyan,     -- More prompt: Cyan
        ["r?"] = colors.cyan, -- Confirm: Cyan
        ["!"] = colors.orange,-- Shell: Orange
        t = colors.yellow,    -- Terminal: Yellow
      }

      -- Custom theme with mode-aware colors
      local custom_theme = {
        normal = {
          a = { fg = colors.bg, bg = mode_colors.n, gui = "bold" },
          b = { fg = colors.fg, bg = "#1a1c2a" },
          c = { fg = colors.fg, bg = colors.bg },
        },
        insert = {
          a = { fg = colors.bg, bg = mode_colors.i, gui = "bold" },
        },
        visual = {
          a = { fg = colors.bg, bg = mode_colors.v, gui = "bold" },
        },
        replace = {
          a = { fg = colors.bg, bg = mode_colors.R, gui = "bold" },
        },
        command = {
          a = { fg = colors.bg, bg = mode_colors.c, gui = "bold" },
        },
        inactive = {
          a = { fg = colors.fg, bg = colors.bg, gui = "bold" },
          b = { fg = colors.fg, bg = colors.bg },
          c = { fg = colors.fg, bg = colors.bg },
        },
      }

      require("lualine").setup({
        options = {
          theme = custom_theme,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "dashboard", "alpha", "starter" },
          },
          globalstatus = true,
          refresh = {
            statusline = 100,
          },
        },
        sections = {
          -- Left side
          lualine_a = {
            {
              "mode",
              fmt = function(str)
                -- Mode icons (matching your custom statusline)
                local mode_icons = {
                  ["NORMAL"] = " ",
                  ["INSERT"] = " ",
                  ["VISUAL"] = " ",
                  ["V-LINE"] = " ",
                  ["V-BLOCK"] = " ",
                  ["COMMAND"] = " ",
                  ["REPLACE"] = " ",
                  ["TERMINAL"] = " ",
                }
                return mode_icons[str] or str:sub(1, 1)
              end,
            },
          },
          lualine_b = {
            {
              "branch",
              icon = "",
              color = { fg = colors.violet },
            },
          },
          lualine_c = {
            {
              "filename",
              path = 1, -- Relative path
              symbols = {
                modified = "●",
                readonly = "",
                unnamed = "[No Name]",
              },
              color = { fg = colors.fg },
            },
          },

          -- Right side
          lualine_x = {
            {
              "diagnostics",
              sources = { "coc" },
              symbols = { error = " ", warn = " ", info = " ", hint = " " },
              colored = true,
            },
            {
              "diff",
              symbols = { added = " ", modified = " ", removed = " " },
              colored = true,
            },
          },
          lualine_y = {
            {
              "filetype",
              colored = true,
              icon_only = false,
            },
          },
          lualine_z = {
            {
              function()
                local current_line = vim.fn.line(".")
                local total_lines = vim.fn.line("$")
                return string.format("%d/%d", current_line, total_lines)
              end,
              icon = "",
            },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "fugitive", "fzf", "toggleterm" },
      })
    end,
  },
}
