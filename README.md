# nanquim.nvim

A dark Neovim colorscheme (0.9+, 0.10+ recommended) inspired by **Vira Carbon**: charcoal background `#0A0A0A`,
sea-green accent `#80CBC4` and soft pastel syntax colors. It is generated from the same palette as the
**Nanquim** VS Code theme, so every syntax role has the same color in both editors.

*Nanquim* is Portuguese for India ink.

Supports Treesitter, LSP semantic tokens, diagnostics and: gitsigns, mini.diff, telescope, fzf-lua, snacks, nvim-cmp,
blink.cmp, neo-tree, nvim-tree, oil, indent-blankline, mini.indentscope, rainbow-delimiters, which-key, noice,
nvim-notify, bufferline, flash, leap, hop, trouble, lazy, mason, dap, illuminate, treesitter-context, mini.statusline,
mini.tabline, render-markdown, navic, aerial and lualine.

## Variants

| Variant | Background | How to use |
|---|---|---|
| default | charcoal `#0A0A0A` (same as VS Code "Nanquim") | `:colorscheme nanquim` |
| black | pure black `#000000` (same as VS Code "Nanquim Black") | `:colorscheme nanquim-black` or `setup({ variant = "black" })` |

To switch between them: `:NanquimToggle` or `require("nanquim").toggle()`.

Both variants use exactly the same accents and syntax rules; Black only moves each background layer one step
down. It works well on OLED screens and with a black terminal background (see [Terminal](#terminal)).

## Installation

**lazy.nvim, from GitHub**

```lua
{
  "your-user/nanquim.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("nanquim").setup({})
    vim.cmd.colorscheme("nanquim")
  end,
}
```

**lazy.nvim, local folder**: replace the first line with `dir = "~/path/to/nanquim.nvim", name = "nanquim",`.

**Without a plugin manager**: copy the folder to `~/.local/share/nvim/site/pack/themes/start/nanquim.nvim` and
add `vim.cmd.colorscheme("nanquim")` to your `init.lua`.

## Options

```lua
require("nanquim").setup({
  variant = "default",     -- "default" | "black"
  transparent = false,     -- use the terminal background
  terminal_colors = true,  -- colors for :terminal
  dim_inactive = false,    -- different background shade for unfocused windows
  styles = {
    comments = { italic = true },
    keywords = {},
    control = { italic = true },  -- if, for, return, import...
    functions = {},
    variables = {},
    parameters = { italic = true },
  },
  on_colors = function(c)
    -- c.teal = "#7FD1C7"
  end,
  on_highlights = function(hl, c)
    -- hl.CursorLine = { bg = c.bg_2 }
  end,
})
```

## Consistency with VS Code

In JS/TS, `const`, `let`, `var`, `extends`, `static`, `get`, `set` (and in TS `type`, `implements`, `declare`,
`override`) are purple, as in VS Code. This is done by the queries in `after/queries/`, which only reclassify
those words. If you prefer the nvim-treesitter default (cyan), delete the `after/` folder.

Known difference: in VS Code, JSON keys change color with nesting depth; in Neovim they are all red
(Treesitter does not expose the depth).

## Lualine

```lua
require("lualine").setup({ options = { theme = "nanquim" } })
```

The lualine theme follows the active variant and the `transparent` option.

## Terminal

`extras/` has the same colors (default and `-black`) for kitty, alacritty, ghostty, wezterm and Windows Terminal,
so the terminal background and ANSI colors match Neovim. Each file starts with a comment explaining how to use it.

```
extras/
├── kitty/nanquim.conf              kitty/nanquim-black.conf
├── alacritty/nanquim.toml          alacritty/nanquim-black.toml
├── ghostty/nanquim                 ghostty/nanquim-black
├── wezterm/nanquim.lua             wezterm/nanquim-black.lua
└── windows-terminal/nanquim.json   windows-terminal/nanquim-black.json
```

## Palette

[PALETTE.md](PALETTE.md) lists every color, its contrast and the rules for using it.

`lua/nanquim/palette.lua`, the terminal extras and `PALETTE.md` are generated from `extras/source/palette.json`.
After editing it, run from this folder:

```sh
python3 extras/source/build_nvim.py .
python3 extras/source/build_docs.py PALETTE.md
python3 extras/source/build_vscode.py path/to/nanquim-vscode   # optional: rebuild the VS Code themes too
```
