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

  -- Plugins are organized in separate files and imported here
  { import = "plugins.treesitter" },
  { import = "plugins.lualine" },
  { import = "plugins.dashboard" },
  { import = "plugins.ui" },
  { import = "plugins.telescope" },
  { import = "plugins.neo-tree" },
  { import = "plugins.git" },
  { import = "plugins.copilot" },
  { import = "plugins.avante" },
  { import = "plugins.coc" },
  { import = "plugins.extras" },

}, {
  -- ============================================================================
  -- Lazy.nvim Options
  -- ============================================================================

  -- Disable luarocks support (we don't need it)
  rocks = {
    enabled = false,
  },

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
