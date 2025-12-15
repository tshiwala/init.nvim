-- ============================================================================
-- Treesitter Configuration
-- Better syntax highlighting using tree-sitter
-- ============================================================================

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,  -- Load immediately so TS commands are always available
    priority = 100,  -- Load early
    config = function()
      -- Load treesitter configuration (using the main module)
      require("nvim-treesitter").setup({
        -- ========================================================================
        -- Language Parsers
        -- ========================================================================
        ensure_installed = {
          -- Core languages
          "lua",
          "vim",
          "vimdoc",
          "query",

          -- User's primary languages
          "python",
          "javascript",
          "typescript",
          "tsx",
          "jsx",
          "html",
          "css",
          "scss",
          "ruby",
          "php",
          "dart",

          -- Markup and data formats
          "markdown",
          "markdown_inline",
          "json",
          "jsonc",
          "yaml",
          "toml",

          -- Shell and config
          "bash",
          "fish",
          "gitignore",
          "gitcommit",
          "git_config",
          "git_rebase",

          -- Other useful parsers
          "regex",
          "comment",
        },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        auto_install = true,

        -- ========================================================================
        -- Highlighting
        -- ========================================================================
        highlight = {
          enable = true,

          -- Disable for very large files (performance)
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },

        -- ========================================================================
        -- Indentation
        -- ========================================================================
        indent = {
          enable = true,
          disable = { "python", "yaml" },  -- Python and YAML have better indent rules
        },

        -- ========================================================================
        -- Incremental Selection
        -- ========================================================================
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = "<S-CR>",
            node_decremental = "<BS>",
          },
        },

        -- ========================================================================
        -- Text Objects
        -- ========================================================================
        -- Note: Textobjects plugin removed to fix compatibility issues
        -- You can add it back later if needed with the updated plugin
      })

      -- ========================================================================
      -- Folding with Treesitter
      -- ========================================================================
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldenable = false  -- Don't fold by default
    end,
  },
}
