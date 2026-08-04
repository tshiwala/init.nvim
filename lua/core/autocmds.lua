-- ============================================================================
-- Autocommands Configuration
-- All autocommands migrated from VimScript
-- ============================================================================

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- ============================================================================
-- General Autocommands
-- ============================================================================

-- Stop auto commenting on new lines
autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Disable auto commenting on new lines",
})

-- Open help in vertical split
autocmd("FileType", {
  pattern = "help",
  command = "wincmd L",
  desc = "Open help in vertical split",
})

-- Remove trailing whitespaces before saving
autocmd("BufWritePre", {
  pattern = "*",
  command = [[:%s/\s\+$//e]],
  desc = "Remove trailing whitespaces before saving",
})

-- Highlight on cursor hold (CoC)
-- Note: This is also configured in lua/plugins/coc.lua
-- Keeping it here for reference but it may be redundant
autocmd("CursorHold", {
  pattern = "*",
  callback = function()
    -- Check if CoC is loaded and ready
    if vim.g.coc_service_initialized == 1 then
      vim.fn.CocActionAsync("highlight")
    end
  end,
  desc = "Highlight match on cursor hold (CoC)",
})

-- ============================================================================
-- Spell Checking
-- ============================================================================

-- Where `zg` (add word) and `zw` (mark bad) write. Set explicitly rather than
-- relying on the first writable spell/ dir in 'runtimepath', so the word list
-- lands somewhere predictable and version-controlled.
vim.opt.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"

-- Enable spell only for specific file types
local spellable = { "markdown", "gitcommit", "txt", "text", "liquid", "rst" }

autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    local ft = vim.bo.filetype
    local is_spellable = false
    for _, v in ipairs(spellable) do
      if ft == v then
        is_spellable = true
        break
      end
    end
    vim.opt_local.spell = is_spellable
  end,
  desc = "Enable spell checking for specific file types",
})

-- ============================================================================
-- Completion Popup
-- ============================================================================

-- Close preview window after completion
autocmd("CompleteDone", {
  pattern = "*",
  callback = function()
    if vim.fn.pumvisible() == 0 then
      vim.cmd("pclose")
    end
  end,
  desc = "Close completion preview after done",
})

-- ============================================================================
-- Startify/Dashboard
-- ============================================================================

local startify_group = augroup("startify", { clear = true })

-- Open dashboard when last buffer is closed
autocmd("BufDelete", {
  group = startify_group,
  pattern = "*",
  callback = function()
    local bufs = vim.fn.tabpagebuflist()
    local listed = {}
    for _, buf in ipairs(bufs) do
      if vim.fn.buflisted(buf) == 1 then
        table.insert(listed, buf)
      end
    end
    if #listed == 0 then
      vim.cmd("Dashboard")
    end
  end,
  desc = "Open dashboard when no buffers left",
})

-- Open dashboard on startup if no arguments
autocmd("VimEnter", {
  group = startify_group,
  pattern = "*",
  callback = function()
    if vim.fn.argc() == 0 then
      vim.cmd("Dashboard")
    end
  end,
  desc = "Open dashboard on startup if no files",
})

-- ============================================================================
-- Directory Arguments
-- ============================================================================

local folder_group = augroup("folderarg", { clear = true })

-- Change to directory if passed as argument
autocmd("VimEnter", {
  group = folder_group,
  pattern = "*",
  callback = function()
    if vim.fn.argc() ~= 0 and vim.fn.isdirectory(vim.fn.argv()[1]) == 1 then
      vim.cmd("cd " .. vim.fn.fnameescape(vim.fn.argv()[1]))
    end
  end,
  desc = "Change to directory argument",
})

-- Open Dashboard as fallback for directory argument
autocmd("VimEnter", {
  group = folder_group,
  pattern = "*",
  callback = function()
    if vim.fn.argc() ~= 0 and vim.fn.isdirectory(vim.fn.argv()[1]) == 1 then
      vim.cmd("Dashboard")
    end
  end,
  desc = "Open dashboard for directory argument",
})

-- Open Telescope files for directory argument
autocmd("VimEnter", {
  group = folder_group,
  pattern = "*",
  callback = function()
    if vim.fn.argc() ~= 0 and vim.fn.isdirectory(vim.fn.argv()[1]) == 1 then
      vim.schedule(function()
        require("telescope.builtin").find_files({ cwd = vim.fn.argv()[1] })
      end)
    end
  end,
  desc = "Open Telescope for directory argument",
})

-- ============================================================================
-- Restore Cursor Position
-- ============================================================================

-- Return to last edit position when opening files
autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Restore cursor position",
})

-- ============================================================================
-- Python Specific
-- ============================================================================

local python_group = augroup("python", { clear = true })

-- Python renaming (using CoC LSP, not Semshi anymore since we have Treesitter)
autocmd("FileType", {
  group = python_group,
  pattern = "python",
  callback = function()
    -- CoC rename is already mapped globally in lua/plugins/coc.lua
    -- This is just a note that <leader>rn works for Python via CoC
  end,
  desc = "Python file type setup",
})

-- Python folding
autocmd("FileType", {
  group = python_group,
  pattern = "python",
  callback = function()
    vim.opt_local.foldmethod = "syntax"
  end,
  desc = "Python syntax folding",
})

-- Python syntax sync
autocmd("FileType", {
  group = python_group,
  pattern = "python",
  command = "syn sync fromstart",
  desc = "Python syntax sync",
})

-- ============================================================================
-- Markdown
-- ============================================================================

-- Markdown preview mapping
autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set("n", "<leader>m", ":MarkdownPreview<CR>", { buffer = true, desc = "Markdown Preview" })
  end,
  desc = "Markdown preview mapping",
})

-- ============================================================================
-- Terminal
-- ============================================================================

-- Disable line numbers in terminal
autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
  desc = "Disable line numbers in terminal",
})
