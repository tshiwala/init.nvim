# Decisions

Append-only log of technical decisions. Newest first.

### Pass USER and HOME into the ACP agent's environment

**Date**: 2026-08-04
**Status**: Accepted

**Context**: With `provider = "claude-code"` configured, every prompt failed with
`-32000 "Authentication required"`, even though `initialize` and `session/new`
both succeeded. Cause: `acp_client.lua:398-415` builds the child environment from
`PATH` plus the provider's `env` table **only** — its "Start with system
environment and override with config env" comment is wrong, nothing else is
inherited. avante's own `codex` default works around this by passing `HOME` and
`PATH` explicitly; the `claude-code` default does not.

**Decision**: Add `USER` and `HOME` to the `acp_providers["claude-code"].env`
override.

**Consequences**: Chat authenticates. Bisected to the minimum: `USER` alone is
sufficient and `HOME` alone still fails, because the macOS keychain lookup for the
Claude Code credential resolves by user. `HOME` is included anyway — it is where
the CLI reads settings, project history, and MCP config. Verified end to end: a
real `session/prompt` returns `stopReason: end_turn` under exactly this env.

### Route avante chat through Claude Code over ACP instead of the Messages API

**Date**: 2026-08-04
**Status**: Accepted

**Context**: The `ANTHROPIC_API_KEY` in `~/.env` pointed at an account reporting
"Credit balance is too low", and merely having it set shadowed the claude.ai
subscription for every `claude` invocation. Proven directly: `claude -p` with the
key returns "Credit balance is too low"; the same command with the key unset
returns normally. This broke the CLI, the remember plugin, and would have broken
avante's `claude` provider.

**Decision**: Comment the key out of `~/.env`, install
`@agentclientprotocol/claude-agent-acp`, and set `provider = "claude-code"` with
an `acp_providers` override. ACP drives the real `claude` binary, so chat
inherits subscription auth. The override exists because avante's upstream default
passes `ANTHROPIC_API_KEY` into the adapter's env, which would re-shadow the
subscription; the default `command` is correct and unchanged.

**Consequences**: Chat works on the subscription with no API key. **Inline
suggestions do not** — they call the Messages API directly and ACP has no
completion endpoint, so `auto_suggestions` now resolves to `false` via the
existing key-presence gate. Getting ghost text back requires funding an API
account and uncommenting the key. Note `ACP_PERMISSION_MODE = "bypassPermissions"`
(avante's default) is retained: the agent applies edits without prompting.
Verified end to end — the adapter answers an ACP `initialize` handshake with
`authMethods: []`, confirming it needs no client credentials.

### Split unrelated lockfile pin bumps into their own commit

**Date**: 2026-08-04
**Status**: Accepted

**Context**: A `:Lazy update` bumped avante.nvim, coc.nvim, nvim-treesitter, and
rainbow-delimiters.nvim in `lazy-lock.json`. Those bumps landed in the same
working tree as the Copilot removal. A review flagged the mix: reverting the
Copilot change would also roll those four plugins back, and a startup break from
one of them would be misattributed during a bisect.

**Decision**: Split into two commits — `652ab3a` carries only the four pin bumps,
`1dd0464` carries the Copilot removal. Rejected the alternative of reverting the
four rows in the lockfile.

**Consequences**: Reverting the Copilot work is now safe in isolation (verified
with a dry-run revert). Restoring the rows instead would have been wrong: those
plugins are genuinely updated on disk, so the lockfile would have misreported the
real install state.

### Gate avante inline suggestions on ANTHROPIC_API_KEY

**Date**: 2026-08-04
**Status**: Accepted

**Context**: avante's spec is `lazy = false`, so `Suggestion:new()` runs during
startup. With `auto_suggestions = true` that constructor fires the
`AvanteRequestLogin` autocmd, which opens a concealed API-key prompt whenever the
key is unset — stealing focus ~200ms into every launch.

**Decision**: `auto_suggestions = vim.env.ANTHROPIC_API_KEY ~= nil`.

**Consequences**: No startup prompt on a machine without a key. The key is
sourced from `~/.env` by `~/.zshrc:74`, which is **interactive-shell only** — so
nvim launched from a GUI launcher sees no key and suggestions silently stay off.
Moving the export to `~/.zshenv` would make it global if that becomes annoying.

### Port a filetype opt-out by driving avante's suggestion autocmds directly

**Date**: 2026-08-04
**Status**: Accepted

**Context**: avante gates inline suggestions only on `buflisted` and `buftype`
(`suggestion.lua:577-579`) — it has no filetype check at all. The removed
copilot.lua carried one (gitcommit, gitrebase, markdown, yaml, help, …). Without
a replacement, inline AI fires inside git commit messages. avante exposes no
per-buffer switch: `H.api` wraps the toggle so only `__call` survives, with no
`.get`/`.set`, and calling it emits a notification on every transition.

**Decision**: A `BufEnter`/`FileType` autocmd calls `suggestion:setup_autocmds()`
or `:delete_autocmds()` on the instance from `require("avante").get()`, wrapped in
`pcall`.

**Consequences**: Reaches past avante's public API, so an upstream refactor could
break it — hence the `pcall`, which degrades to "suggestions stay as they were"
rather than breaking `BufEnter`. Verified live: augroup present for python, `nil`
for gitcommit/markdown/yaml, re-armed on return to python.

### Enable auto_suggestions_respect_ignore

**Date**: 2026-08-04
**Status**: Accepted

**Context**: avante defaults `auto_suggestions_respect_ignore` to `false`
(`config.lua:856`). With auto-suggestions on, that streams gitignored files —
`.env`, credentials, private keys — to api.anthropic.com on every insert-mode
pause.

**Decision**: Set it to `true` explicitly in the `behaviour` table.

**Consequences**: Gitignored paths are skipped. This is a privacy concern
distinct from the API-cost tradeoff, and it is not the upstream default, so it
must stay pinned in config rather than assumed.

### Move the suggestion accept key from <M-l> to <C-l>

**Date**: 2026-08-04
**Status**: Accepted

**Context**: avante's default accept key is `<M-l>`. iTerm2 sends Option as the
raw character by default rather than as Meta, so the binding may never reach
nvim — leaving suggestions that are billed for but cannot be accepted.

**Decision**: `mappings.suggestion.accept = "<C-l>"`, which is unbound in insert
mode and reachable on every terminal.

**Consequences**: Diverges from avante's documented default. **This was inferred
from iTerm2's default Option handling, not measured against the actual profile**
— if Option is set to "Esc+", `<M-l>` worked and this change was unnecessary.

### Fix coc keymaps that Copilot had been masking

**Date**: 2026-08-04
**Status**: Accepted

**Context**: Two pre-existing bugs in `lua/plugins/coc.lua`, invisible while
copilot.lua owned insert-mode `<Tab>`. (1) The shared `opts` set
`replace_keycodes = false`, so expr callbacks returning `"<C-n>"` / `"<TAB>"`
inserted that notation as literal text. (2) Every completion test used native
`pumvisible()`, which is always `0` against coc's floating pum — so Enter never
confirmed and the pum-visible branches were dead code.

**Decision**: `replace_keycodes = true`, and route all three mappings through
`coc#pum#visible()` / `coc#pum#next()` / `coc#pum#prev()` / `coc#pum#confirm()`.

**Consequences**: Tab and Enter behave correctly for the first time in this
config. Verified functionally — pressing Tab in a real buffer now yields an
actual indent where it previously produced the literal characters `<TAB>`.

### Remove GitHub Copilot entirely

**Date**: 2026-08-04
**Status**: Accepted

**Context**: A `checkout failed` error on copilot.lua turned out to be a 30+
minute lazy blob fetch holding `.git/index.lock` — the plugin vendors the whole
`@github/copilot` SDK, including eight ~30MB per-platform `runtime.node`
prebuilds, for ~1.5GB on disk. The user's verdict: "I never use it."

**Decision**: Delete `lua/plugins/copilot.lua` (both copilot.lua and
CopilotChat.nvim), drop the import and avante's dependency entry, and `:Lazy
clean` the directories. Rebind the seven `<leader>c*` chat prompts onto avante
rather than losing them.

**Consequences**: ~1.5GB reclaimed. avante was unaffected — it was already
configured `provider = "claude"` with `auto_suggestions = false`, so it never
used copilot.lua despite listing it as a dependency. Removing Copilot unmasked
the two coc keymap bugs above.
