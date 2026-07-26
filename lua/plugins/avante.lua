-- ============================================================================
-- Avante.nvim - Claude AI Assistant
-- Cursor-like AI coding assistant powered by Claude
-- ============================================================================

return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
      -- Provider configuration
      provider = "claude",
      auto_suggestions_provider = "claude",

      providers = {
        claude = {
          endpoint = "https://api.anthropic.com/v1/messages",
          model = "claude-sonnet-4-5-20250929",
          api_key_name = "ANTHROPIC_API_KEY",
          extra_request_body = {
            temperature = 0,
            max_tokens = 4096,
          },
        },
      },

      -- Behavior settings
      behaviour = {
        auto_suggestions = false, -- Don't auto-trigger suggestions (conflicts with Copilot)
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
      },

      -- UI configuration
      mappings = {
        --- @class AvanteConflictMappings
        diff = {
          ours = "co",
          theirs = "ct",
          all_theirs = "ca",
          both = "cb",
          cursor = "cc",
          next = "]x",
          prev = "[x",
        },
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        sidebar = {
          apply_all = "A",
          apply_cursor = "a",
          switch_windows = "<Tab>",
          reverse_switch_windows = "<S-Tab>",
        },
      },

      -- Window configuration
      windows = {
        ---@type "right" | "left" | "top" | "bottom"
        position = "right",
        wrap = true,
        width = 30, -- % based on available width
        sidebar_header = {
          align = "center",
          rounded = true,
        },
      },

      -- Highlights
      highlights = {
        diff = {
          current = "DiffText",
          incoming = "DiffAdd",
        },
      },

      -- File handling
      diff = {
        autojump = true,
        ---@type string | fun(): any
        list_opener = "copen",
      },
    },

    -- Build step for dependencies
    build = "make",

    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- Optional dependencies
      "echasnovski/mini.icons",
      "zbirenbaum/copilot.lua", -- for auto-suggestions
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "Avante" },
        opts = {
          file_types = { "markdown", "Avante" },
          heading = {
            -- Thin accent bar instead of the default numeric-box icons.
            icons = { "▎ ", "▎ ", "▎ ", "▎ ", "▎ ", "▎ " },
            -- Tint hugs the heading text rather than spanning the window.
            width = "block",
            left_pad = 0,
            right_pad = 1,
          },
        },
        config = function(_, opts)
          -- Stock backgrounds link to DiffText, which is `reverse` in this
          -- colorscheme — that turns every heading into a solid inverted band
          -- that reads as an error. Derive a subtle tint from each level's own
          -- heading colour instead, so it tracks whatever theme is loaded.
          local function blend(fg, bg, alpha)
            local function channels(c)
              return math.floor(c / 65536) % 256, math.floor(c / 256) % 256, c % 256
            end
            local fr, fg_, fb = channels(fg)
            local br, bg_, bb = channels(bg)
            local mix = function(a, b)
              return math.floor(a * alpha + b * (1 - alpha) + 0.5)
            end
            return string.format("#%02x%02x%02x", mix(fr, br), mix(fg_, bg_), mix(fb, bb))
          end

          -- Every @markup.heading.N shares one colour in most themes, so levels
          -- would be indistinguishable once the numeric icons are gone. Borrow
          -- six accents that any colourscheme defines distinctly instead.
          local accents = { "Function", "String", "Constant", "Type", "Special", "Identifier" }

          local function style_headings()
            local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
            if not normal.bg then
              return -- transparent background; a tint would be meaningless
            end
            for i = 1, 6 do
              local src = vim.api.nvim_get_hl(0, { name = accents[i], link = false })
              local fg = src and src.fg
              if not fg then
                local fallback = vim.api.nvim_get_hl(0, {
                  name = "@markup.heading." .. i .. ".markdown",
                  link = false,
                })
                fg = fallback and fallback.fg
              end
              if fg then
                vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i, { fg = fg, bold = true })
                vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i .. "Bg", {
                  fg = fg,
                  bg = blend(fg, normal.bg, 0.12),
                })
              end
            end
          end

          style_headings()
          vim.api.nvim_create_autocmd("ColorScheme", {
            desc = "Re-derive render-markdown heading tints after a theme change",
            callback = style_headings,
          })

          require("render-markdown").setup(opts)
        end,
      },
    },

    config = function(_, opts)
      require("avante").setup(opts)
    end,

    -- Keybindings
    keys = {
      {
        "<leader>aa",
        function()
          require("avante.api").ask()
        end,
        desc = "Avante: Ask",
        mode = { "n", "v" },
      },
      {
        "<leader>ar",
        function()
          require("avante.api").refresh()
        end,
        desc = "Avante: Refresh",
      },
      {
        "<leader>ae",
        function()
          require("avante.api").edit()
        end,
        desc = "Avante: Edit",
        mode = "v",
      },
    },
  },
}
