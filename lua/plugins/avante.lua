-- ============================================================================
-- Avante.nvim - Claude AI Assistant
-- Cursor-like AI coding assistant powered by Claude
-- ============================================================================

-- The <leader>c* prompts formerly served by CopilotChat, rebound onto avante.
-- With a visual selection, avante scopes the question to that selection.
local function prompt(question)
  return function()
    require("avante.api").ask({ question = question })
  end
end

-- Inline suggestions stream buffer contents to the API on every pause, so only
-- arm them once a key is present. Without this, avante's startup init fires a
-- concealed API-key prompt at every launch on machines where the key is unset.
local auto_suggestions = vim.env.ANTHROPIC_API_KEY ~= nil

-- avante gates suggestions on buflisted/buftype only — it has no filetype
-- check at all. Copilot used to carry this opt-out list; without it, inline
-- AI fires inside git commit messages, notes, and config files.
local no_suggestions_ft = {
  gitcommit = true,
  gitrebase = true,
  hgcommit = true,
  svn = true,
  cvs = true,
  markdown = true,
  yaml = true,
  help = true,
}

return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
      -- Chat runs through Claude Code over ACP, which authenticates the way the
      -- `claude` CLI does — i.e. the claude.ai subscription, no API key. The
      -- direct `claude` provider below bills a separate API account and is kept
      -- only for the inline-suggestion path, which has no ACP equivalent.
      provider = "claude-code",
      auto_suggestions_provider = "claude",

      acp_providers = {
        ["claude-code"] = {
          -- avante's default `command` (claude-agent-acp) is correct; only the
          -- env needs overriding. Upstream passes ANTHROPIC_API_KEY through,
          -- which would shadow the subscription and re-break Claude Code auth.
          command = "claude-agent-acp",
          args = {},
          env = {
            NODE_NO_WARNINGS = "1",
            ACP_PATH_TO_CLAUDE_CODE_EXECUTABLE = vim.fn.exepath("claude"),
            -- Upstream default. The agent applies edits without prompting.
            ACP_PERMISSION_MODE = "bypassPermissions",
            -- avante builds the child env from PATH plus this table alone
            -- (acp_client.lua:398-415 — the "start with system environment"
            -- comment there is wrong). USER is what the macOS keychain lookup
            -- needs to resolve the Claude Code credential; without it every
            -- session/prompt fails with -32000 "Authentication required".
            -- HOME is not needed for auth but is what the CLI reads settings,
            -- project history, and MCP config from.
            USER = vim.env.USER,
            HOME = vim.env.HOME,
          },
        },
      },

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
        auto_suggestions = auto_suggestions, -- Uses auto_suggestions_provider on every pause
        auto_suggestions_respect_ignore = true, -- Never send gitignored files (.env, keys)
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
          -- Not <M-l>: iTerm2 sends Option as the raw character by default, so
          -- a Meta binding never reaches nvim and suggestions can't be accepted.
          accept = "<C-l>",
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
          latex = { enabled = false },
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

      if not auto_suggestions then
        return
      end

      -- avante exposes no per-buffer suggestion switch, so drive the instance's
      -- autocmds directly. pcall'd because this reaches past the public API and
      -- must fail soft rather than break BufEnter if avante's internals move.
      vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
        desc = "Disable avante inline suggestions in commit messages, notes, and config",
        callback = function(ev)
          local ok, avante = pcall(require, "avante")
          if not ok then
            return
          end
          local _, _, suggestion = avante.get()
          if not suggestion then
            return
          end
          local ft = vim.bo[ev.buf].filetype
          if ft == "" or no_suggestions_ft[ft] then
            pcall(function()
              suggestion:delete_autocmds()
            end)
          else
            pcall(function()
              suggestion:setup_autocmds()
            end)
          end
        end,
      })
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

      -- Chat prompts inherited from the removed CopilotChat setup
      {
        "<leader>cc",
        function()
          require("avante").toggle_sidebar()
        end,
        desc = "Avante: Toggle chat",
        -- Its six siblings are n+v; without v here the prefix would fall
        -- through to the `c` operator and delete the selection.
        mode = { "n", "v" },
      },
      {
        "<leader>ce",
        prompt("Explain how this code works."),
        desc = "Avante: Explain",
        mode = { "n", "v" },
      },
      {
        "<leader>cr",
        prompt("Review this code and provide concise suggestions."),
        desc = "Avante: Review",
        mode = { "n", "v" },
      },
      {
        "<leader>cf",
        prompt("Fix any bugs or issues in this code."),
        desc = "Avante: Fix",
        mode = { "n", "v" },
      },
      {
        "<leader>co",
        prompt("Optimize this code to improve performance and readability."),
        desc = "Avante: Optimize",
        mode = { "n", "v" },
      },
      {
        "<leader>cd",
        prompt("Add comprehensive documentation comments to this code."),
        desc = "Avante: Docs",
        mode = { "n", "v" },
      },
      {
        "<leader>ct",
        prompt("Generate unit tests for this code."),
        desc = "Avante: Tests",
        mode = { "n", "v" },
      },
    },
  },
}
