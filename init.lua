-- ============================================================================
-- Neovim Lua Configuration
-- Modernized setup migrated from VimScript
-- ============================================================================

-- ============================================================================
-- Neovim Lua Configuration
-- Fully migrated from VimScript to modern Lua setup
-- ============================================================================

-- Set leader keys before anything else
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Load plugin manager (lazy.nvim)
-- Must be loaded before other configurations
require("plugins")

-- Load core Lua configuration
require("core")

-- ============================================================================
-- Migration Complete!
-- ============================================================================
-- All configurations have been migrated from VimScript to Lua
-- - init.vim is no longer sourced (backed up as init.vim.bak)
-- - statusline.vim is no longer needed (replaced by lualine)
-- - All plugins configured via lazy.nvim
-- - All settings, keymaps, and autocmds in Lua
-- ============================================================================
