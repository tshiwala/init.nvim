# Decisions

Append-only log of technical decisions. Newest first.

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
