-- ============================================================================
-- Plugin Manager Configuration - lazy.nvim
-- Modern plugin manager for Neovim
-- ============================================================================

-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup({
  -- ============================================================================
  -- Plugin Specifications
  -- ============================================================================

  -- Plugins will be added incrementally during migration
  -- For now, lazy.nvim is installed but no plugins are loaded
  -- This allows us to test the plugin manager without conflicts

  -- Future plugins will be organized in separate files and imported here:
  -- { import = "plugins.treesitter" },
  -- { import = "plugins.telescope" },
  -- { import = "plugins.ui" },
  -- etc.

}, {
  -- ============================================================================
  -- Lazy.nvim Options
  -- ============================================================================

  -- UI Configuration
  ui = {
    border = "rounded",
    icons = {
      cmd = " ",
      config = "",
      event = "",
      ft = "",
      init = " ",
      import = "",
      keys = " ",
      lazy = "󰒲 ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      source = " ",
      start = "",
      task = "✔ ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
  },

  -- Automatically check for plugin updates
  checker = {
    enabled = true,
    notify = false,  -- Don't notify about updates (can be noisy)
    frequency = 3600,  -- Check once per hour
  },

  -- Don't notify about config changes
  change_detection = {
    enabled = true,
    notify = false,
  },

  -- Performance optimizations
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      -- Disable some builtin plugins for better performance
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
