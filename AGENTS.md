# Repository Guidelines

This repository contains a Lua-first Neovim configuration managed by lazy.nvim and CoC. Keep changes focused, minimal, and consistent with the existing module layout.

## Project Structure & Module Organization
- `init.lua` is the entry point and loads `lua/core` modules (options, keymaps, autocmds, colors).
- `lua/plugins/` holds lazy.nvim specs, one file per area (treesitter, telescope, neo-tree, git, avante, coc, etc.) combined via `lua/plugins/init.lua`.
- `lua/utils/` contains shared helpers; `coc-settings.json` captures LSP/completion preferences; `lazy-lock.json` pins plugin versions—only change when intentionally updating.
- Legacy VimScript backups (`init.vim.bak`, `statusline.vim.bak`) and `plugged/` are reference only; avoid adding new code there.

## Build, Test, and Development Commands
- `nvim` — normal startup; ensure there are no errors on launch.
- `nvim --headless "+Lazy! sync" +qa` — install/update plugins and validate lazy config loads.
- `nvim --headless "+checkhealth" +qa` — verify dependencies (ripgrep, node, python, fonts, clipboard).
- `nvim --headless "+luafile init.lua" +qa` — quick syntax/sanity check after editing Lua modules.

## Coding Style & Naming Conventions
- Use 4-space indentation in Lua; keep table keys snake_case and align with existing comment separators (`-- ===`) for sections.
- Keep module names tied to paths (`core.options`, `plugins.telescope`); prefer one responsibility per file and import via `require`.
- Favor Neovim Lua APIs (`vim.opt`, `vim.keymap.set`, `vim.api.*`) over VimScript; keep leader mappings consistent with leader `,`.
- For lazy.nvim specs, prefer explicit `opts`/`config` tables and descriptive names over inline one-offs when logic grows.

## Testing Guidelines
- After plugin changes, run `:checkhealth` and any plugin-specific checks (`:TSInstall`, `:CocInfo`, etc.) in a relevant buffer.
- Avoid committing `lazy-lock.json` churn unless you intend to bump versions; rerun `--headless "+Lazy! sync"` to ensure the lockfile stabilizes.

## Commit & Pull Request Guidelines
- Git history favors short imperative messages with optional scopes/prefixes (`Fix: ...`, `feat: ...`, `chore: ...`); keep them under ~72 characters.
- PRs should explain user-visible effects (keymaps, theme tweaks, new plugins), list new dependencies or required fonts, and include screenshots/GIFs for UI-facing changes (dashboard, statusline, colors).
- Link related issues or TODOs and note any follow-up steps (e.g., parser installs or extra health checks) so others can reproduce your setup.
