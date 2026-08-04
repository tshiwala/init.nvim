# Neovim Configuration

Modern Neovim configuration fully migrated to Lua with contemporary plugins and features.

## Features

- ✨ **Modern Lua Configuration** - Fully migrated from VimScript to Lua
- ⚡ **Fast Startup** - Lazy loading with lazy.nvim plugin manager
- 🎨 **Material Ocean Theme** - Beautiful color scheme with custom highlights
- 🌳 **Treesitter** - Advanced syntax highlighting and code understanding
- 🔍 **Telescope** - Powerful fuzzy finder for files, grep, and more
- 📁 **Neo-tree** - Modern file explorer with git integration
- 💡 **CoC.nvim** - Full LSP support for multiple languages
- 🧠 **Claude AI (Avante)** - Cursor-like AI assistant with Claude Sonnet, including inline suggestions
- 🎯 **Git Integration** - Gitsigns, LazyGit, and Fugitive
- 📊 **Lualine** - Beautiful customizable statusline
- 🚀 **Many More** - See full plugin list below

## Supported Languages

- Python (coc-pyright)
- JavaScript/TypeScript (coc-tsserver)
- HTML/CSS (coc-html, coc-css)
- Ruby
- PHP
- Dart
- C/C++ (coc-clangd)
- And many more via CoC extensions

## Requirements

- **Neovim** >= 0.9.0
- **Git** - For plugin management
- **Node.js** >= 16 - For CoC.nvim
- **Python 3** - For pynvim (`pip3 install pynvim`)
- **Ripgrep** - For Telescope live grep
- **A Nerd Font** - For icons (recommended: FiraCode Nerd Font)

### Optional but Recommended

- **tmux** - For seamless terminal integration
- **LazyGit** - For git TUI (Leader+gg)
- **Claude API** - For Avante AI assistant (get key from https://console.anthropic.com/). Export `ANTHROPIC_API_KEY`; inline suggestions stay off unless it is set.
- **bat** - For better file previews in Telescope
- **prettier** - For code formatting
- **black** - For Python formatting

## Installation

```bash
# Backup existing config if you have one
mv ~/.config/nvim ~/.config/nvim.backup

# Clone this configuration
git clone https://github.com/yourusername/nvim-config ~/.config/nvim

# Start Neovim - plugins will install automatically
nvim
```

### API Keys Setup

For AI features to work, you need to set up API keys in `~/.env`:

```bash
# Edit ~/.env and add your API keys
export ANTHROPIC_API_KEY="your-anthropic-api-key-here"  # For Claude/Avante
export OPEN_API_KEY="your-openai-api-key-here"         # For OpenAI (if needed)
```

**Get your API keys:**
- Claude: https://console.anthropic.com/
- OpenAI: https://platform.openai.com/api-keys

Then source your shell config:
```bash
source ~/.zshrc  # or ~/.bashrc
```

## Directory Structure

```
~/.config/nvim/
├── init.lua                 # Main entry point
├── lua/
│   ├── core/
│   │   ├── init.lua        # Core module loader
│   │   ├── options.lua     # Vim options
│   │   ├── keymaps.lua     # Key mappings
│   │   ├── autocmds.lua    # Autocommands
│   │   └── colors.lua      # Color customizations
│   ├── plugins/
│   │   ├── init.lua        # Plugin manager (lazy.nvim)
│   │   ├── treesitter.lua  # Syntax highlighting
│   │   ├── telescope.lua   # Fuzzy finder
│   │   ├── neo-tree.lua    # File explorer
│   │   ├── lualine.lua     # Statusline
│   │   ├── coc.lua         # LSP configuration
│   │   ├── git.lua         # Git integration
│   │   ├── avante.lua      # Claude AI assistant
│   │   ├── ui.lua          # UI enhancements
│   │   ├── dashboard.lua   # Start screen
│   │   └── extras.lua      # Additional plugins
│   └── utils/
│       └── init.lua        # Utility functions
└── coc-settings.json       # CoC LSP settings
```

## Plugin List

### Core Functionality
- **lazy.nvim** - Modern plugin manager
- **nvim-treesitter** - Advanced syntax highlighting
- **telescope.nvim** - Fuzzy finder and picker
- **neo-tree.nvim** - File explorer
- **coc.nvim** - LSP and completion

### UI & Appearance
- **lualine.nvim** - Statusline
- **material.nvim** - Color scheme
- **dashboard-nvim** - Start screen
- **indent-blankline.nvim** - Indent guides
- **rainbow-delimiters.nvim** - Rainbow parentheses
- **nvim-colorizer.lua** - Color preview
- **nvim-notify** - Notifications
- **dressing.nvim** - Better UI inputs
- **neoscroll.nvim** - Smooth scrolling

### Git Integration
- **gitsigns.nvim** - Git decorations
- **lazygit.nvim** - LazyGit integration
- **vim-fugitive** - Git commands

### Editing & Navigation
- **Comment.nvim** - Smart commenting
- **nvim-surround** - Surround operations
- **nvim-autopairs** - Auto pairs
- **which-key.nvim** - Keybinding hints
- **trouble.nvim** - Diagnostics list
- **todo-comments.nvim** - TODO highlighting

### AI & Productivity
- **avante.nvim** - Claude AI assistant (Cursor-like experience)
  - Powered by Claude Sonnet 4.5
  - Inline code suggestions and explanations
  - Side-by-side diff view
  - Context-aware assistance

### Other
- **toggleterm.nvim** - Terminal management
- **vim-tmux-navigator** - Tmux integration
- **markdown-preview.nvim** - Markdown preview

## Keyboard Shortcuts

Leader key: `,` (comma)

### Essential
| Mapping | Functionality |
|---------|---------------|
| `;` | Command mode |
| `Leader+rr` | Reload config |
| `Leader+w` | Save file |
| `Leader+q` | Close buffer |
| `Leader+ss` | Format file |
| `Tab` / `Shift+Tab` | Next/previous buffer |

### Navigation
| Mapping | Functionality |
|---------|---------------|
| `Ctrl+h/j/k/l` | Navigate splits/tmux panes |
| `Leader+e` | Toggle file explorer |
| `Leader+o` | Focus file explorer |

### Telescope (Fuzzy Finder)
| Mapping | Functionality |
|---------|---------------|
| `Leader+ff` | Find files |
| `Leader+b` | Buffers |
| `Leader+/` | Live grep |
| `Leader+fr` | Recent files |
| `Leader+fh` | Help tags |
| `Leader+fc` | Commands |
| `Leader+fs` | Treesitter symbols |

### Neo-tree (File Explorer)
| Action | Command/Mapping |
|--------|-----------------|
| Toggle tree | `:Neotree toggle` or `Leader+e` |
| Focus tree | `:Neotree focus` or `Leader+o` |
| Hide dotfiles by default | Configured (dotfiles start hidden) |
| Toggle hidden/dotfiles | `H` inside Neo-tree |
| Set root to current dir | `.` |
| Go up one level | `<BS>` |
| `Leader+fk` | Keymaps |

### LSP (CoC.nvim)
| Mapping | Functionality |
|---------|---------------|
| `Leader+jd` | Go to definition |
| `Leader+jy` | Type definition |
| `Leader+ji` | Implementation |
| `Leader+jr` | References |
| `Leader+rn` | Rename symbol |
| `Leader+ca` | Code actions |
| `Leader+o` | Organize imports |
| `K` | Show documentation |
| `[g` / `]g` | Previous/next diagnostic |
| `Ctrl+a` | Multi-cursor selection |

### Git
| Mapping | Functionality |
|---------|---------------|
| `Leader+gg` | LazyGit |
| `Leader+gd` | Git diff |
| `Leader+gb` | Git blame |
| `Leader+gc` | Git commits (Telescope) |
| `Leader+gs` | Git status (Telescope) |
| `]h` / `[h` | Next/previous hunk |
| `Leader+hp` | Preview hunk |
| `Leader+hb` | Blame line |

### Claude AI - inline suggestions
Off unless `ANTHROPIC_API_KEY` is set, and suppressed in commit messages, markdown, and YAML.

| Mapping | Functionality |
|---------|---------------|
| `Ctrl+l` | Accept suggestion |
| `Alt+]` | Next suggestion |
| `Alt+[` | Previous suggestion |
| `Ctrl+]` | Dismiss suggestion |

### Claude AI - chat prompts
| Mapping | Functionality |
|---------|---------------|
| `Leader+cc` | Toggle chat sidebar |
| `Leader+ce` | Explain code |
| `Leader+cr` | Review code |
| `Leader+cf` | Fix code |
| `Leader+co` | Optimize code |
| `Leader+cd` | Document code |
| `Leader+ct` | Generate tests |

All except `Leader+cc` scope to the visual selection when one is active.

### Claude AI (Avante)
| Mapping | Functionality |
|---------|---------------|
| `Leader+aa` | Ask Claude (normal/visual) |
| `Leader+ar` | Refresh Claude response |
| `Leader+ae` | Edit with Claude (visual) |
| `]]` / `[[` | Jump to next/previous diff |
| `]x` / `[x` | Next/previous conflict |
| **In Avante sidebar:** | |
| `<CR>` | Apply suggestion (normal) |
| `Ctrl+s` | Apply suggestion (insert) |
| `a` | Apply at cursor |
| `A` | Apply all |
| `Tab` / `Shift+Tab` | Switch windows |

### Other
| Mapping | Functionality |
|---------|---------------|
| `gcc` | Toggle comment (line) |
| `gc` | Toggle comment (motion) |
| `Leader+xx` | Toggle Trouble diagnostics |
| `Leader+tt` | Toggle terminal |
| `F2` | Trim whitespace |
| `F6` | Open dashboard |

## Commands

| Command | Functionality |
|---------|---------------|
| `:Lazy` | Plugin manager UI |
| `:Format` | Format file (CoC) |
| `:OR` | Organize imports |
| `:Telescope` | Open Telescope |
| `:Neotree` | File explorer |
| `:LazyGit` | Open LazyGit |
| `:AvanteAsk` | Ask Claude AI |
| `:checkhealth` | Check Neovim health |

## Customization

### Adding Plugins

Edit `lua/plugins/extras.lua` or create a new file in `lua/plugins/`:

```lua
return {
  {
    "author/plugin-name",
    config = function()
      -- Plugin configuration
    end,
  },
}
```

### Modifying Keymaps

Edit `lua/core/keymaps.lua`:

```lua
keymap("n", "<leader>x", ":YourCommand<CR>", opts)
```

### Changing Options

Edit `lua/core/options.lua`:

```lua
opt.number = true
opt.relativenumber = true
```

### CoC Extensions

Edit `lua/plugins/coc.lua` to add/remove CoC extensions in `coc_global_extensions`.

## Migration from VimScript

This configuration was fully migrated from VimScript to Lua. Old files are backed up as:
- `init.vim.bak`
- `statusline.vim.bak`

## Troubleshooting

### Plugins not loading
```bash
# Open Neovim and run
:Lazy sync
```

### LSP not working
```bash
# Check CoC status
:CocInfo

# Install/update CoC extensions
:CocUpdate
```

### TreeSitter issues
```bash
:TSUpdate
:TSInstall <language>
```

### Claude/Avante not working
1. Check that your API key is set in `~/.env`:
   ```bash
   echo $ANTHROPIC_API_KEY
   ```
2. Make sure you sourced your shell config:
   ```bash
   source ~/.zshrc
   ```
3. Restart Neovim completely
4. Check for errors: `:messages`

## Performance

- Startup time: ~30-50ms (with lazy loading)
- All plugins are lazy-loaded based on events, commands, or file types
- Treesitter for fast syntax highlighting
- Optimized CoC settings for quick responses

## Credits

- Based on [Blacksuan19's init.nvim](https://github.com/Blacksuan19/init.nvim)
- Fully modernized with Lua and contemporary plugins
- Thanks to all plugin authors and the Neovim community

## License

MIT License - Feel free to use and modify!
