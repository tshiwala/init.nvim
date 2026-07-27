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
      -- ========================================================================
      -- Install Parsers (New API)
      -- ========================================================================
      local parsers = {
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
        "latex",
        "json",
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
      }

      -- Install parsers asynchronously
      require('nvim-treesitter').install(parsers)

      -- ========================================================================
      -- Enable Highlighting (New API)
      -- ========================================================================
      vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function()
          local buf = vim.api.nvim_get_current_buf()
          
          -- Disable for very large files (performance)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return
          end

          -- Enable treesitter highlighting
          pcall(vim.treesitter.start, buf)
        end,
      })

      -- ========================================================================
      -- Folding with Treesitter (New API)
      -- ========================================================================
      vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function()
          vim.wo[0][0].foldmethod = 'expr'
          vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo[0][0].foldenable = false  -- Don't fold by default
        end,
      })
    end,
  },
}
