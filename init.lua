-- ============================================================================
-- Neovim Lua Configuration
-- Modernized setup migrated from VimScript
-- ============================================================================

-- Set leader keys before anything else
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Load plugin manager (lazy.nvim)
-- Must be loaded before other configurations
require("plugins")

-- Load core Lua configuration
require("core")

-- Temporarily source the existing init.vim during migration
-- This ensures everything continues working while we incrementally migrate
-- Note: Some settings may be duplicated between Lua and VimScript during migration
vim.cmd('source ~/.config/nvim/init.vim')
