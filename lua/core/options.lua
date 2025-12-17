-- ============================================================================
-- Neovim Options and Settings
-- Migrated from init.vim to Lua
-- ============================================================================

local opt = vim.opt
local g = vim.g

-- ============================================================================
-- General Settings
-- ============================================================================

opt.termguicolors = true              -- Enable 24-bit RGB colors
opt.mouse = "a"                       -- Enable mouse support
opt.clipboard = "unnamedplus"         -- Use system clipboard
opt.encoding = "utf-8"                -- Text encoding

-- ============================================================================
-- Tabs and Indentation
-- ============================================================================

opt.tabstop = 4                       -- Number of spaces tabs count for
opt.softtabstop = 4                   -- Number of spaces tabs count for in insert mode
opt.shiftwidth = 4                    -- Size of indent
opt.expandtab = true                  -- Use spaces instead of tabs
opt.smarttab = true                   -- Smart tab behavior
opt.autoindent = true                 -- Auto indentation
opt.breakindent = true                -- Wrapped lines continue visually indented

-- ============================================================================
-- Search Settings
-- ============================================================================

opt.incsearch = true                  -- Incremental search
opt.ignorecase = true                 -- Ignore case in search
opt.smartcase = true                  -- Smart case search (override ignorecase if uppercase used)
opt.hlsearch = true                   -- Highlight search results

-- ============================================================================
-- UI Configuration
-- ============================================================================

opt.number = true                     -- Show line numbers
opt.relativenumber = true             -- Show relative line numbers
opt.signcolumn = "yes"                -- Always show sign column
opt.wrap = true                       -- Enable line wrap
opt.tw = 90                           -- Text width for auto-wrapping
opt.list = true                       -- Show whitespace characters
opt.listchars = {                     -- Whitespace characters to show
  trail = "»",
  tab = "»-",
}
opt.fillchars = { vert = "▏" }        -- Vertical split character
opt.title = true                      -- Set window title to filename
opt.conceallevel = 2                  -- Conceal level for certain syntax
opt.splitright = true                 -- Vertical splits open to the right
opt.splitbelow = true                 -- Horizontal splits open below
opt.showmode = false                  -- Don't show mode (statusline shows it)
opt.showcmd = false                   -- Don't show last command
opt.showtabline = 0                   -- Never show tabline
opt.emoji = true                      -- Enable emoji support

-- ============================================================================
-- Performance Optimizations
-- ============================================================================

opt.cursorline = false                -- Disable cursor line (performance)
opt.cursorcolumn = false              -- Disable cursor column (performance)
opt.scrolljump = 5                    -- Lines to scroll when cursor leaves screen
opt.lazyredraw = true                 -- Don't redraw during macros (performance)
opt.redrawtime = 10000                -- Time in ms for redrawing screen
opt.synmaxcol = 180                   -- Max column for syntax highlight
opt.re = 1                            -- Regex engine (0=auto, 1=old, 2=NFA)

-- ============================================================================
-- File Handling
-- ============================================================================

opt.history = 1000                    -- Command history limit
opt.undofile = true                   -- Enable persistent undo
opt.undodir = "/tmp"                  -- Undo file directory
opt.backspace = { "indent", "eol", "start" }  -- Sensible backspacing

-- ============================================================================
-- CoC.nvim Required Settings
-- ============================================================================

opt.hidden = true                     -- Allow hidden buffers
opt.backup = false                    -- Disable backup files
opt.writebackup = false               -- Disable backup before writing
opt.updatetime = 300                  -- Faster completion (default 4000ms)
opt.cmdheight = 1                     -- Command line height
opt.shortmess:append("c")             -- Don't pass messages to ins-completion-menu

-- ============================================================================
-- Grep Program
-- ============================================================================

opt.grepprg = "rg --vimgrep"          -- Use ripgrep as grep program

-- ============================================================================
-- Folding
-- ============================================================================

opt.foldlevel = 0                     -- Start with all folds open

-- ============================================================================
-- Incremental Command Preview
-- ============================================================================

opt.inccommand = "nosplit"            -- Show effects of command incrementally

-- ============================================================================
-- Disable Built-in Plugins
-- ============================================================================

-- Disable netrw (we'll use a modern file explorer)
g.loaded_netrwPlugin = 1

-- Disable SQL omni completion
g.omni_sql_no_default_maps = 1

-- Disable unused providers (performance)
g.loaded_python_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- Python 3 provider (use dedicated neovim environment)
if vim.fn.glob(vim.fn.expand("~/.python3")) ~= "" then
  g.python3_host_prog = vim.fn.expand("~/.python3/bin/python")
else
  g.python3_host_prog = vim.fn.systemlist("which python3")[1]
end
