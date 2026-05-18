# Neovim Config

A small, native Neovim configuration built around Neovim's built-in package manager, built-in LSP client, and a handful of focused plugins.

This config is organized to keep core editor settings separate from plugin setup. Plugin installation lives in `lua/config/pack.lua`, while each plugin is configured in its own file under `lua/config/packages/`.

## Requirements

This config expects a recent Neovim version with native `vim.pack` support.

Recommended external tools:

- `git` for plugin installation
- `cmake`, `make`, and a C/C++ compiler for `telescope-fzf-native.nvim`
- `ripgrep` for Telescope live grep
- `fd` for faster file finding
- `catimg` for image previews in Telescope
- language servers installed through Mason

On Arch Linux:

```sh
sudo pacman -S git cmake make gcc ripgrep fd
```

`catimg` may need to come from the AUR depending on your system.

## Structure

```text
~/.config/nvim/
├── init.lua
├── nvim-pack-lock.json
└── lua/
    └── config/
        ├── init.lua
        ├── options.lua
        ├── keymaps.lua
        ├── diagnostics.lua
        ├── autocmds.lua
        ├── pack.lua
        └── packages/
            ├── init.lua
            ├── blink.lua
            ├── colorscheme.lua
            ├── harpoon.lua
            ├── hop.lua
            ├── mason.lua
            ├── oil.lua
            ├── telescope.lua
            └── undotree.lua
```

### `init.lua`

The root entry point. It only loads:

```lua
require("config")
```

### `lua/config/init.lua`

Loads the main config modules in order:

```lua
require("config.options")
require("config.pack")
require("config.keymaps")
require("config.diagnostics")
require("config.autocmds")
require("config.packages")
```

This order matters. Options are loaded first, plugins are installed/registered early, general keymaps and diagnostics come next, then plugin configuration is loaded.

### `lua/config/options.lua`

General editor options:

- Space is the leader key.
- Absolute and relative line numbers are enabled.
- Tabs are configured as 4 spaces.
- Smart indenting is enabled.
- Wrapping is disabled.
- Persistent undo is enabled.
- Swap, backup, and writebackup files are disabled.
- Search uses `ignorecase` and `smartcase`.
- Search highlighting is disabled.
- `termguicolors` is enabled.
- The cursor is vertically centered with a large `scrolloff`.
- Neovim UI2 is enabled with `require("vim._core.ui2").enable({})`.

### `lua/config/pack.lua`

Uses native `vim.pack.add()` to install plugins.

Installed plugins:

- `nvim-treesitter/nvim-treesitter` for syntax-aware highlighting and parsing.
- `ray-x/starry.nvim` for the colorscheme.
- `neovim/nvim-lspconfig` for LSP server definitions.
- `saghen/blink.lib` and `saghen/blink.cmp` for completions.
- `rafamadriz/friendly-snippets` for snippet sources.
- `williamboman/mason.nvim` and `williamboman/mason-lspconfig.nvim` for installing and enabling LSP servers.
- `ThePrimeagen/harpoon` for quick file marks.
- `nvim-lua/plenary.nvim` as a dependency for several plugins.
- `smoka7/hop.nvim` for fast movement.
- `stevearc/oil.nvim` for file browsing/editing as a buffer.
- `echasnovski/mini.icons` for file icons.
- `nvim-telescope/telescope.nvim` for fuzzy finding.
- `nvim-telescope/telescope-fzf-native.nvim` for faster Telescope sorting.
- `nvim-telescope/telescope-ui-select.nvim` for improved `vim.ui.select` UI.
- `mbbill/undotree` for visual undo history.

`telescope-fzf-native.nvim` needs to be compiled. This config uses a `PackChanged` autocmd to build it after install/update, and also provides:

```vim
:BuildTelescopeFzfNative
```

Use that command if the FZF extension fails to load because `libfzf.so` is missing.

### `lua/config/packages/init.lua`

Loads plugin configs:

```lua
require("config.packages.colorscheme")
require("config.packages.blink")
require("config.packages.mason")
require("config.packages.harpoon")
require("config.packages.hop")
require("config.packages.oil")
require("config.packages.telescope")
require("config.packages.undotree")
```

Blink is loaded before Mason so LSP capabilities can be enhanced before Mason enables the language servers.

## Important Plugin Setup

### Colorscheme: Starry

Configured in:

```text
lua/config/packages/colorscheme.lua
```

The config uses `starry.nvim` with:

- `style.name = "deep ocean"`
- transparent background enabled
- italic comments and keywords
- custom transparent highlights for `Normal`, `NormalFloat`, `SignColumn`, `LineNr`, and related groups

The colorscheme is applied with:

```lua
vim.cmd.colorscheme("starry")
```

### Completion: Blink CMP

Configured in:

```text
lua/config/packages/blink.lua
```

Main behavior:

- Blink completion menu auto-shows while typing.
- Documentation popup auto-shows after a short delay.
- Signature help is enabled.
- Sources include LSP, path, snippets, and buffer completions.
- Lua fuzzy matcher is used instead of native/Rust fuzzy implementation.
- `<Tab>` accepts the selected completion.
- `<S-Tab>` moves to the previous completion item.

Important part:

```lua
sources = {
  default = {
    "lsp",
    "path",
    "snippets",
    "buffer",
  },
}
```

### LSP and Mason

Configured in:

```text
lua/config/packages/mason.lua
```

Mason installs and enables these LSP servers:

- `lua_ls`
- `texlab`
- `jedi_language_server`
- `ast_grep`
- `clangd`
- `jdtls`
- `html`
- `pylsp`

Blink capabilities are passed into all LSP configs:

```lua
local capabilities = vim.lsp.protocol.make_client_capabilities()
local blink = require("blink.cmp")
capabilities = blink.get_lsp_capabilities(capabilities)

vim.lsp.config("*", {
  capabilities = capabilities,
})
```

Mason then enables servers automatically:

```lua
require("mason-lspconfig").setup({
  automatic_enable = true,
})
```

### Native LSP completion disabled

Configured in:

```text
lua/config/autocmds.lua
```

Native Neovim LSP completion is disabled so only Blink handles completion popups:

```lua
vim.lsp.completion.enable(false, client_id, args.buf)
vim.bo[args.buf].omnifunc = nil
vim.bo[args.buf].completefunc = nil
```

### Format on save

Also configured in:

```text
lua/config/autocmds.lua
```

When an LSP server supports formatting, the buffer is formatted before saving:

```lua
vim.lsp.buf.format({
  bufnr = args.buf,
  timeout_ms = 2000,
})
```

### Diagnostics

Configured in:

```text
lua/config/diagnostics.lua
```

Diagnostics are sorted by severity, are not updated during insert mode, and use signs:

- `E` for errors
- `W` for warnings
- `I` for info
- `H` for hints

### Telescope

Configured in:

```text
lua/config/packages/telescope.lua
```

Features:

- Custom borders
- `ui-select` extension
- `fzf` extension
- image preview support through `catimg`

### Oil

Configured in:

```text
lua/config/packages/oil.lua
```

Oil is used as a file explorer that works like editing a normal buffer.

### Harpoon

Configured in:

```text
lua/config/packages/harpoon.lua
```

Harpoon is used to mark files and quickly jump between them.

### Hop

Configured in:

```text
lua/config/packages/hop.lua
```

Hop provides fast jump motions across words or anywhere visible.

### UndoTree

Configured in:

```text
lua/config/packages/undotree.lua
```

Provides a visual tree for persistent undo history.

## Custom Keybinds

Leader key:

```text
<leader> = Space
```

### General

| Key | Mode | Action |
| --- | --- | --- |
| `<Tab>` | Normal | Next buffer |
| `<S-Tab>` | Normal | Previous buffer |
| `<C-h>` | Normal | Move to left window / Harpoon file 1 conflict, see note below |
| `<C-j>` | Normal | Move to lower window |
| `<C-k>` | Normal | Move to upper window |
| `<C-l>` | Normal | Move to right window |
| `p` | Visual | Paste without replacing the unnamed register |

Note: `<C-h>` is mapped both for window navigation and Harpoon file 1. The later-loaded mapping may override the earlier one. If one does not behave as expected, this conflict is why.

### Insert autopairs

| Key | Mode | Inserts |
| --- | --- | --- |
| `` ` `` | Insert | `` `` `` and places cursor inside |
| `"` | Insert | `""` and places cursor inside |
| `(` | Insert | `()` and places cursor inside |
| `[` | Insert | `[]` and places cursor inside |
| `{` | Insert | `{}` and places cursor inside |
| `<` | Insert | `<>` and places cursor inside |

### Blink completion

| Key | Mode | Action |
| --- | --- | --- |
| `<Tab>` | Insert | Accept selected completion, then fallback |
| `<S-Tab>` | Insert | Select previous completion item, then fallback |

With the default Blink preset, additional completion mappings may be available, such as showing/hiding the menu or documentation depending on Blink defaults.

### Telescope

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>ff` | Normal | Find files |
| `<leader>rg` | Normal | Live grep |
| `<leader>fb` | Normal | List buffers |
| `<leader>fh` | Normal | Help tags |

### Oil

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>pv` | Normal | Open Oil file explorer |

### Harpoon

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>a` | Normal | Add current file to Harpoon |
| `<C-e>` | Normal | Toggle Harpoon quick menu |
| `<C-h>` | Normal | Go to Harpoon file 1 |
| `<C-t>` | Normal | Go to Harpoon file 2 |
| `<C-n>` | Normal | Go to Harpoon file 3 |
| `<C-s>` | Normal | Go to Harpoon file 4 |

### Hop

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>hw` | Normal | Hop to word |
| `<leader>ha` | Normal | Hop anywhere |

### UndoTree

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>u` | Normal | Toggle UndoTree |

## Native Neovim Cheat Sheet

### Files and buffers

| Command | Action |
| --- | --- |
| `:e path/to/file` | Open file |
| `:w` | Save current file |
| `:wa` | Save all modified buffers |
| `:q` | Quit current window |
| `:qa` | Quit all windows |
| `:wq` | Save and quit |
| `:bd` | Delete current buffer |
| `:ls` | List buffers |
| `:bnext` | Next buffer |
| `:bprevious` | Previous buffer |
| `:buffer N` | Jump to buffer number `N` |

### Window management

| Key | Action |
| --- | --- |
| `<C-w>s` | Horizontal split |
| `<C-w>v` | Vertical split |
| `<C-w>q` | Close current window |
| `<C-w>h` | Move to left split |
| `<C-w>j` | Move to lower split |
| `<C-w>k` | Move to upper split |
| `<C-w>l` | Move to right split |
| `<C-w>=` | Equalize split sizes |
| `<C-w>_` | Maximize height |
| `<C-w>|` | Maximize width |

### Search

| Key / Command | Action |
| --- | --- |
| `/text` | Search forward for `text` |
| `?text` | Search backward for `text` |
| `n` | Next search match |
| `N` | Previous search match |
| `*` | Search word under cursor forward |
| `#` | Search word under cursor backward |
| `:%s/old/new/g` | Replace all `old` with `new` in file |
| `:%s/old/new/gc` | Replace all with confirmation |
| `:s/old/new/g` | Replace on current line only |
| `:'<,'>s/old/new/g` | Replace in visual selection |

Useful examples:

```vim
:%s/foo/bar/g
:%s/foo/bar/gc
:%s/\<foo\>/bar/g
```

The last command replaces only the whole word `foo`.

### Macros

| Key | Action |
| --- | --- |
| `qa` | Start recording macro into register `a` |
| `q` | Stop recording |
| `@a` | Replay macro `a` |
| `@@` | Replay last macro again |
| `5@a` | Replay macro `a` five times |

Example workflow:

```text
qa      start recording into register a
...     do edits
q       stop recording
@a      replay once
10@a    replay ten times
```

### Marks

| Key | Action |
| --- | --- |
| `ma` | Set mark `a` at cursor |
| `'a` | Jump to line of mark `a` |
| `` `a `` | Jump to exact position of mark `a` |
| `''` | Jump back to previous line |
| ``` `` ``` | Jump back to previous exact position |

### Registers and clipboard

| Key / Command | Action |
| --- | --- |
| `"ay` | Yank into register `a` |
| `"ap` | Paste from register `a` |
| `"+y` | Yank to system clipboard |
| `"+p` | Paste from system clipboard |
| `:reg` | Show registers |

### Visual mode

| Key | Action |
| --- | --- |
| `v` | Character visual mode |
| `V` | Line visual mode |
| `<C-v>` | Block visual mode |
| `>` | Indent selection |
| `<` | Unindent selection |
| `y` | Yank selection |
| `d` | Delete selection |

### Undo and redo

| Key / Command | Action |
| --- | --- |
| `u` | Undo |
| `<C-r>` | Redo |
| `:earlier 5m` | Go to file state from 5 minutes ago |
| `:later 5m` | Go forward 5 minutes in undo history |
| `<leader>u` | Toggle UndoTree |

### LSP basics

This config relies on LSP servers installed and enabled by Mason.

Useful built-in LSP commands:

| Command | Action |
| --- | --- |
| `:lua vim.lsp.buf.hover()` | Show hover info |
| `:lua vim.lsp.buf.definition()` | Go to definition |
| `:lua vim.lsp.buf.references()` | Show references |
| `:lua vim.lsp.buf.rename()` | Rename symbol |
| `:lua vim.lsp.buf.code_action()` | Show code actions |
| `:lua vim.lsp.buf.format()` | Format current buffer |
| `:LspInfo` | Show active LSP clients |
| `:Mason` | Open Mason UI |

## Maintenance

### Rebuild Telescope FZF native

```vim
:BuildTelescopeFzfNative
```

### Update plugins

Native `vim.pack` manages plugin installation through the config. If you change the plugin list, restart Neovim and allow `vim.pack.add()` to install missing plugins.

### Check active LSP servers

```vim
:LspInfo
```

### Open Mason

```vim
:Mason
```

### Check mappings

```vim
:map
:nmap
:imap
:verbose nmap <key>
```

Example:

```vim
:verbose nmap <C-h>
```

This is useful for finding mapping conflicts.
