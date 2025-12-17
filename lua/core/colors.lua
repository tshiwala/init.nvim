-- ============================================================================
-- Color Scheme Configuration
-- Custom highlights and color overrides
-- ============================================================================

-- Material Ocean theme is loaded in lua/plugins/ui.lua
-- This file contains additional custom highlights

-- Wait for colorscheme to load
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- These highlights are already set in ui.lua material setup
    -- Keeping them here for reference and easy modification

    -- Popup menu colors
    vim.cmd([[hi Pmenu guibg=#00010a guifg=white]])

    -- Italic comments
    vim.cmd([[hi Comment gui=italic cterm=italic]])

    -- Search highlight
    vim.cmd([[hi Search guibg=#b16286 guifg=#ebdbb2 gui=NONE]])

    -- Hide tilde for empty lines
    vim.cmd([[hi NonText guifg=bg]])

    -- Cursor line number
    vim.cmd([[hi clear CursorLineNr]])
    vim.cmd([[hi CursorLineNr gui=bold]])

    -- Spell bad
    vim.cmd([[hi SpellBad guifg=NONE gui=bold,undercurl]])

    -- Git diff colors
    vim.cmd([[hi DiffAdd guibg=#0f111a guifg=#43a047]])
    vim.cmd([[hi DiffChange guibg=#0f111a guifg=#fdd835]])
    vim.cmd([[hi DiffRemoved guibg=#0f111a guifg=#e53935]])

    -- CoC cursor range
    vim.cmd([[hi CocCursorRange guibg=#b16286 guifg=#ebdbb2]])
  end,
})
