# Status

_Last updated: 2026-08-04_

Personal Neovim configuration. Lua, managed by lazy.nvim, 34 plugins.

## Current state

Healthy. Config loads clean, startup produces no errors, `checkhealth lazy`
reports 0 errors and 0 warnings, and the working tree is committed.

## AI assistance

avante.nvim is the sole AI integration. GitHub Copilot was removed on 2026-08-04.

- **Chat** — runs through Claude Code over ACP (`provider = "claude-code"`), so it
  uses the **claude.ai subscription and needs no API key**. Requires the
  `@agentclientprotocol/claude-agent-acp` npm package (global).
  `<leader>cc` toggles the sidebar; `<leader>c{e,r,f,o,d,t}` run explain / review
  / fix / optimize / docs / tests, scoped to the visual selection when one is
  active. `<leader>a{a,r,e}` remain avante's own bindings.
- **Inline suggestions** — **currently off.** They call the Messages API directly,
  which needs a funded `ANTHROPIC_API_KEY`; ACP has no completion endpoint. The
  config gates on key presence, and the key is commented out in `~/.env`. If
  re-enabled they accept with `<C-l>`, skip gitignored files, and stay suppressed
  in gitcommit, gitrebase, markdown, yaml, and help buffers.

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

- **Inline suggestions are unavailable** until an API account is funded — see the
  AI assistance section above. Chat is unaffected.
- **`ACP_PERMISSION_MODE = "bypassPermissions"`** (avante's upstream default) is
  in effect, so the ACP agent applies edits without prompting.

## Resolved 2026-08-04

- The dead `ANTHROPIC_API_KEY` that shadowed the claude.ai subscription is
  commented out in `~/.env`. The `claude` CLI and the remember plugin work again.

## Up next

1. Smoke-test avante chat in a real session — `<leader>cc`, then ask something
2. Decide whether `<M-l>` really was unreachable in iTerm2, or revert `<C-l>`
3. Optionally fund an API account if inline ghost text is wanted back
