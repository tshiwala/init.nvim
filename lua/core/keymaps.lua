-- ============================================================================
-- Keymaps Configuration
-- All custom keybindings migrated from VimScript
-- ============================================================================

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader key is set in init.lua before loading plugins
-- vim.g.mapleader = ","

-- ============================================================================
-- Essential Mappings
-- ============================================================================

-- Use ; for command mode
keymap("n", ";", ":", { noremap = true })

-- Reload neovim config. Doubled because <leader>r prefixes <leader>rn (rename),
-- and a key that is both a mapping and a prefix stalls for 'timeoutlen'.
keymap("n", "<leader>rr", ":source ~/.config/nvim/init.lua<CR>", opts)

-- Save and quit
keymap("n", "<leader>w", ":w<CR>", opts)
keymap("n", "<leader>q", ":bd<CR>", opts)

-- Format code. Doubled because <leader>s prefixes <leader>sh (search history).
keymap("n", "<leader>ss", ":Format<CR>", opts)

-- Plugin install
keymap("n", "<leader>e", ":Lazy<CR>", opts)

-- Quit all
keymap("n", "<C-q>", ":q<CR>", opts)

-- Buffer navigation
keymap("n", "<Tab>", ":bnext<CR>", opts)
keymap("n", "<S-Tab>", ":bprevious<CR>", opts)

-- ============================================================================
-- New Lines in Normal Mode
-- ============================================================================

keymap("n", "<Enter>", "o<ESC>", opts)
keymap("n", "<S-Enter>", "O<ESC>", opts)

-- ============================================================================
-- Delete and Paste (using different register)
-- ============================================================================

-- Delete without yanking
keymap("n", "d", '"_d', { noremap = true })
keymap("v", "d", '"_d', { noremap = true })
keymap("n", "x", '"_x', { noremap = true })

-- Paste without yanking in visual mode
keymap("v", "p", '"_dP', { noremap = true })

-- ============================================================================
-- Copy/Cut (System Clipboard)
-- ============================================================================

-- Copy on release
keymap("v", "<LeftRelease>", '"+y<LeftRelease>', { noremap = true })

-- Copy and cut
keymap("v", "<C-c>", '"+y<CR>', { noremap = true })
keymap("v", "<C-x>", '"+d<CR>', { noremap = true })

-- ============================================================================
-- Window Navigation
-- ============================================================================

-- Switch between splits (insert mode)
keymap("i", "<C-h>", "<C-\\><C-N><C-w>h", opts)
keymap("i", "<C-j>", "<C-\\><C-N><C-w>j", opts)
keymap("i", "<C-k>", "<C-\\><C-N><C-w>k", opts)
keymap("i", "<C-l>", "<C-\\><C-N><C-w>l", opts)

-- Switch between splits (normal mode)
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- ============================================================================
-- Search
-- ============================================================================

-- Disable highlight with double escape
keymap("n", "<esc>", "<esc>:noh<CR><esc>", opts)

-- ============================================================================
-- Utilities
-- ============================================================================

-- Trim whitespace
keymap("n", "<F2>", ":let _s=@/<Bar>:%s/\\s\\+$//e<Bar>:let @/=_s<Bar><CR>", opts)

-- Open startify/dashboard
keymap("n", "<F6>", ":Dashboard<CR>", opts)

-- ============================================================================
-- Markdown Preview
-- ============================================================================

-- Note: This will be set in ftplugin/markdown.lua or autocmd

-- ============================================================================
-- Telescope/FZF Replacement Mappings
-- ============================================================================
-- These are defined in lua/plugins/telescope.lua with lazy loading

-- ============================================================================
-- CoC.nvim Mappings
-- ============================================================================
-- These will be defined in lua/plugins/coc.lua

-- ============================================================================
-- Git Mappings (Fugitive)
-- ============================================================================
-- These are defined in lua/plugins/git.lua

-- ============================================================================
-- Tmux Navigator
-- ============================================================================
-- Note: vim-tmux-navigator plugin handles these automatically
-- Mappings: <C-h>, <C-j>, <C-k>, <C-l> for seamless vim/tmux navigation
