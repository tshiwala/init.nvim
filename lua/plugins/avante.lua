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
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
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
