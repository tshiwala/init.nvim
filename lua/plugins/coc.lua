-- ============================================================================
-- CoC.nvim Configuration
-- Language Server Protocol (LSP) integration
-- Preserving existing CoC setup with Lua configuration
-- ============================================================================

return {
  {
    "neoclide/coc.nvim",
    branch = "release",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- ========================================================================
      -- CoC Extensions (from init.vim)
      -- ========================================================================
      vim.g.coc_global_extensions = {
        "coc-yank",
        "coc-pairs",
        "coc-json",
        "coc-css",
        "coc-html",
        "coc-tsserver",
        "coc-yaml",
        "coc-lists",
        "coc-snippets",
        "coc-pyright",
        "coc-clangd",
        "coc-prettier",
        "coc-xml",
        "coc-syntax",
        "coc-git",
        "coc-marketplace",
        "coc-highlight",
        "coc-sh",
      }

      -- ========================================================================
      -- Snippet Navigation
      -- ========================================================================
      vim.g.coc_snippet_next = "<Tab>"
      vim.g.coc_snippet_prev = "<S-Tab>"

      -- ========================================================================
      -- Helper Functions
      -- ========================================================================

      -- Check if backspace is pressed
      local function check_back_space()
        local col = vim.fn.col(".") - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
      end

      -- Show documentation
      local function show_docs()
        local cw = vim.fn.expand("<cword>")
        if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
          vim.cmd("h " .. cw)
        elseif vim.api.nvim_eval("coc#rpc#ready()") then
          vim.fn.CocActionAsync("doHover")
        else
          vim.cmd("!" .. vim.o.keywordprg .. " " .. cw)
        end
      end

      -- ========================================================================
      -- Autocommands
      -- ========================================================================

      -- Highlight symbol under cursor
      vim.api.nvim_create_autocmd("CursorHold", {
        pattern = "*",
        callback = function()
          vim.fn.CocActionAsync("highlight")
        end,
        desc = "Highlight symbol under cursor (CoC)",
      })

      -- Setup formatexpr for CoC
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
          vim.opt_local.formatexpr = "v:lua.vim.lsp.formatexpr()"
        end,
        desc = "Setup formatexpr for CoC",
      })

      -- Close preview window after completion
      vim.api.nvim_create_autocmd("CompleteDone", {
        pattern = "*",
        callback = function()
          if vim.fn.pumvisible() == 0 then
            vim.cmd("pclose")
          end
        end,
        desc = "Close preview after completion (CoC)",
      })

      -- ========================================================================
      -- Keymappings
      -- ========================================================================

      -- replace_keycodes must stay on: these callbacks return "<TAB>"-style
      -- notation, which is inserted as literal text without it.
      local opts = { silent = true, noremap = true, expr = true, replace_keycodes = true }
      local keymap = vim.keymap.set

      -- CoC draws its own floating menu, so the native pumvisible() is always 0
      -- here — every test below has to go through coc#pum#visible().
      keymap("i", "<TAB>", function()
        if vim.fn["coc#pum#visible"]() == 1 then
          return vim.fn["coc#pum#next"](1)
        elseif check_back_space() then
          return "<TAB>"
        else
          return vim.fn["coc#refresh"]()
        end
      end, opts)

      keymap("i", "<S-TAB>", function()
        if vim.fn["coc#pum#visible"]() == 1 then
          return vim.fn["coc#pum#prev"](1)
        else
          return "<C-h>"
        end
      end, opts)

      -- Enter to confirm completion
      keymap("i", "<cr>", function()
        if vim.fn["coc#pum#visible"]() == 1 then
          return vim.fn["coc#pum#confirm"]()
        end
        return "<CR>"
      end, opts)

      -- CoC refresh
      keymap("i", "<c-space>", "coc#refresh()", { silent = true, expr = true })

      -- Navigation for diagnostics
      keymap("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
      keymap("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

      -- GoTo code navigation
      keymap("n", "<leader>jd", "<Plug>(coc-definition)", { silent = true, desc = "Go to definition" })
      keymap("n", "<leader>jy", "<Plug>(coc-type-definition)", { silent = true, desc = "Go to type definition" })
      keymap("n", "<leader>ji", "<Plug>(coc-implementation)", { silent = true, desc = "Go to implementation" })
      keymap("n", "<leader>jr", "<Plug>(coc-references)", { silent = true, desc = "Go to references" })

      -- Rename symbol
      keymap("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true, desc = "Rename symbol" })

      -- Code actions
      keymap("n", "<leader>a", "<Plug>(coc-codeaction-line)", { silent = true, desc = "Code action (line)" })
      keymap("x", "<leader>a", "<Plug>(coc-codeaction-selected)", { silent = true, desc = "Code action (selected)" })

      -- Organize imports
      keymap("n", "<leader>o", ":OR<CR>", { silent = true, desc = "Organize imports" })

      -- Show documentation
      keymap("n", "K", show_docs, { silent = true, desc = "Show documentation" })

      -- Multi-cursor
      keymap("n", "<C-a>", "<Plug>(coc-cursors-word)", { silent = true, desc = "Multi-cursor word" })
      keymap("x", "<C-a>", "<Plug>(coc-cursors-range)", { silent = true, desc = "Multi-cursor range" })

      -- ========================================================================
      -- Commands
      -- ========================================================================

      -- Format command
      vim.api.nvim_create_user_command("Format", function()
        vim.fn.CocAction("format")
      end, { nargs = 0, desc = "Format code with CoC" })

      -- Organize imports command
      vim.api.nvim_create_user_command("OR", function()
        vim.fn.CocAction("runCommand", "editor.action.organizeImport")
      end, { nargs = 0, desc = "Organize imports" })

      -- ========================================================================
      -- Status Line Integration
      -- ========================================================================
      -- CoC status is integrated into lualine automatically via diagnostics

      -- ========================================================================
      -- Popup Menu Colors
      -- ========================================================================
      vim.cmd([[
        hi CocMenuSel guibg=#13354A
        hi CocSearch guifg=#89ddff
        hi CocFloating guibg=#0f111a
      ]])
    end,
  },
}
