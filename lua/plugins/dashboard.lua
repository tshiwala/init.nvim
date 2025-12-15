-- ============================================================================
-- Dashboard Configuration
-- Modern start screen replacing vim-startify
-- ============================================================================

return {
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("dashboard").setup({
        theme = "doom",
        config = {
          header = {
            "",
            "",
            "                                                    ▟▙            ",
            "                                                    ▝▘            ",
            "            ██▃▅▇█▆▖  ▗▟████▙▖   ▄████▄   ██▄  ▄██  ██  ▗▟█▆▄▄▆█▙▖",
            "            ██▛▔ ▝██  ██▄▄▄▄██  ██▛▔▔▜██  ▝██  ██▘  ██  ██▛▜██▛▜██",
            "            ██    ██  ██▀▀▀▀▀▘  ██▖  ▗██   ▜█▙▟█▛   ██  ██  ██  ██",
            "            ██    ██  ▜█▙▄▄▄▟▊  ▀██▙▟██▀   ▝████▘   ██  ██  ██  ██",
            "            ▀▀    ▀▀   ▝▀▀▀▀▀     ▀▀▀▀       ▀▀     ▀▀  ▀▀  ▀▀  ▀▀",
            "",
            "",
            "",
          },
          center = {
            {
              icon = "  ",
              icon_hl = "Title",
              desc = "Recent Files                    ",
              desc_hl = "String",
              key = "r",
              key_hl = "Number",
              action = "Telescope oldfiles",
            },
            {
              icon = "  ",
              icon_hl = "Title",
              desc = "Find Files                      ",
              desc_hl = "String",
              key = "f",
              key_hl = "Number",
              action = "Telescope find_files",
            },
            {
              icon = "  ",
              icon_hl = "Title",
              desc = "Find Text                       ",
              desc_hl = "String",
              key = "g",
              key_hl = "Number",
              action = "Telescope live_grep",
            },
            {
              icon = "  ",
              icon_hl = "Title",
              desc = "Neovim Config                   ",
              desc_hl = "String",
              key = "v",
              key_hl = "Number",
              action = "edit ~/.config/nvim/",
            },
            {
              icon = "  ",
              icon_hl = "Title",
              desc = "Plugin Manager                  ",
              desc_hl = "String",
              key = "p",
              key_hl = "Number",
              action = "Lazy",
            },
            {
              icon = "  ",
              icon_hl = "Title",
              desc = "Health Check                    ",
              desc_hl = "String",
              key = "h",
              key_hl = "Number",
              action = "checkhealth",
            },
            {
              icon = "  ",
              icon_hl = "Title",
              desc = "Quit                            ",
              desc_hl = "String",
              key = "q",
              key_hl = "Number",
              action = "quit",
            },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return {
              "",
              "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
            }
          end,
        },
        hide = {
          statusline = false,
          tabline = false,
          winbar = false,
        },
      })
    end,
  },
}
