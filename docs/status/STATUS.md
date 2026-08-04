# Status

_Last updated: 2026-08-04_

Personal Neovim configuration. Lua, managed by lazy.nvim, 34 plugins.

## Current state

Healthy. Config loads clean, startup produces no errors, `checkhealth lazy`
reports 0 errors and 0 warnings, and the working tree is committed.

## AI assistance

avante.nvim is the sole AI integration, on `provider = "claude"`
(`claude-sonnet-4-5`). GitHub Copilot was removed on 2026-08-04.

- **Chat** — `<leader>cc` toggles the sidebar; `<leader>c{e,r,f,o,d,t}` run
  explain / review / fix / optimize / docs / tests, scoped to the visual
  selection when one is active. `<leader>a{a,r,e}` remain avante's own bindings.
- **Inline suggestions** — enabled, but only when `ANTHROPIC_API_KEY` is set, and
  suppressed in gitcommit, gitrebase, markdown, yaml, and help buffers. Accept
  with `<C-l>`. Gitignored files are never sent.

## Completion

coc.nvim, with `<Tab>` / `<S-Tab>` / `<CR>` routed through `coc#pum#*`. These
mappings were fixed on 2026-08-04 after two long-standing bugs surfaced — see
the decisions log.

## Recently completed

- Removed Copilot end to end; ~1.5GB reclaimed from `~/.local/share/nvim/lazy/`
- Migrated the `<leader>c*` chat prompts from CopilotChat to avante
- Enabled avante inline suggestions with privacy and filetype guards
- Fixed `<Tab>`/`<S-Tab>`/`<CR>` in coc.nvim
- Split unrelated plugin pin bumps into their own commit

## Known issues

- **The remember plugin is not recording.** Every `save-session` fails with
  `Credit balance is too low`, and warns that `ANTHROPIC_API_KEY` takes
  precedence over the claude.ai login. `.remember/` has no buffer file and the
  autonomous logs are empty. See `.remember/logs/memory-2026-08-04.log`.
- **The same key backs avante.** If that API account is out of credit, avante
  inline suggestions and chat will fail too — untested as of this writing.
- **Inline suggestions are shell-dependent.** The key comes from `~/.env` via
  `~/.zshrc:74`, so nvim launched outside an interactive shell sees no key and
  suggestions silently stay off.

## Up next

1. Resolve the credit/auth conflict — either top up the API account or unset
   `ANTHROPIC_API_KEY` so claude.ai auth is used
2. Confirm avante chat and inline suggestions actually work end to end
3. Decide whether `<M-l>` really was unreachable in iTerm2, or revert `<C-l>`
