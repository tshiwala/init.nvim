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

-- Temporarily source the existing init.vim during migration
-- This ensures everything continues working while we incrementally migrate
vim.cmd('source ~/.config/nvim/init.vim')

-- Load core Lua configuration (will be populated during migration)
-- require("core")
