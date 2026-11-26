# Nanquim palette

A dark theme inspired by Vira Carbon: charcoal background, sea-green accent and soft pastel syntax colors.

Single source: `palette.json`. The VS Code theme and the Neovim theme are both generated from it, so the same roles use the same colors in both editors.

Contrast is measured against the `bg` background (#0A0A0A), per WCAG (4.5:1 = AA for text).

## Backgrounds (layers, darkest to lightest)

| Name | Hex | Contrast | Used for |
|---|---|---|---|
| `bg_dim` | `#060606` | 1.0:1 | Shadows; inactive windows with `dim_inactive` (Neovim) |
| `bg` | `#0A0A0A` | 1.0:1 | Main background: editor, sidebar, tabs, status bar, terminal |
| `bg_1` | `#111213` | 1.1:1 | Surface: cursor line, inputs, hovers, floating windows, VS Code suggest widget |
| `bg_2` | `#17181A` | 1.1:1 | Raised: Neovim completion menu, focused list item, widget titles |
| `bg_3` | `#1E2023` | 1.2:1 | Hover/selection inside menus, secondary buttons |
| `bg_4` | `#2A2D31` | 1.4:1 | Text selection, float borders, active indent guides, Neovim window separators |
| `border` | `#1C1E21` | 1.2:1 | Dividers between VS Code panels |
| `line_nr` | `#3A3D42` | 1.8:1 | Line numbers |

## Text

| Name | Hex | Contrast | Used for |
|---|---|---|---|
| `fg` | `#D9D9D9` | 14.0:1 | Main text, variables |
| `fg_1` | `#B4B5B8` | 9.7:1 | Secondary text: menus, general UI |
| `fg_2` | `#85868C` | 5.5:1 | Muted text: sidebar, current line number, blockquotes |
| `fg_3` | `#5C5D63` | 3.0:1 | Subtle text: comments, inactive tabs, inlay hints |

## Accents

| Name | Hex | Contrast | Used for |
|---|---|---|---|
| `teal` | `#80CBC4` | 10.6:1 | UI accent (active tab, badges, buttons, matches, normal mode); hints |
| `cyan` | `#6EBAD7` | 9.1:1 | Keywords, control flow, operators, punctuation, headings |
| `blue` | `#6A90D0` | 6.1:1 | Functions and methods; info; git modified |
| `purple` | `#A178C4` | 5.7:1 | Declarations (const, let, fn, class), attributes, decorators |
| `pink` | `#D6808F` | 6.9:1 | Booleans, language constants (null, nil, None), regex, escapes |
| `red` | `#C85E60` | 4.9:1 | Properties, keys (JSON/YAML), HTML tags, modules; error; git deleted |
| `orange` | `#CD775C` | 6.0:1 | Numbers, type parameters, CSS ids; git conflict |
| `yellow` | `#D5B05F` | 9.6:1 | Types, classes, interfaces, components; warning; search |
| `green` | `#A3C679` | 10.3:1 | Strings; git added; success |
| `steel` | `#90A9BC` | 8.1:1 | self/this, enum members, readonly properties, CSS properties |
| `gold` | `#FFCC00` | 13.1:1 | Cursor |

## Bright variants (terminal ANSI 8-15)

| Name | Hex | Contrast | Used for |
|---|---|---|---|
| `bright_red` | `#D97A7C` | 6.6:1 | ANSI 9 |
| `bright_green` | `#B8D696` | 12.3:1 | ANSI 10 |
| `bright_yellow` | `#E2C47F` | 11.7:1 | ANSI 11 |
| `bright_blue` | `#89A9DE` | 8.3:1 | ANSI 12 |
| `bright_purple` | `#B795D4` | 7.8:1 | ANSI 13 |
| `bright_cyan` | `#8CCBE3` | 11.1:1 | ANSI 14 |
| `white` | `#FFFFFF` | 19.8:1 | ANSI 15 |

## Syntax roles

| Role | Color | Hex | Style | What it paints |
|---|---|---|---|---|
| `comment` | `fg_3` | `#5C5D63` | italic | Comments |
| `keyword` | `cyan` | `#6EBAD7` | — | Keywords (`new`, `in`, `typeof`) |
| `control` | `cyan` | `#6EBAD7` | italic | Control flow (`if`, `for`, `return`, `import`) |
| `storage` | `purple` | `#A178C4` | — | Declarations (`const`, `let`, `function`, `class`, `def`, `fn`) |
| `operator` | `cyan` | `#6EBAD7` | — | Operators |
| `punctuation` | `cyan` | `#6EBAD7` | — | Punctuation and delimiters |
| `function` | `blue` | `#6A90D0` | — | Functions and methods (definition and call) |
| `type` | `yellow` | `#D5B05F` | — | Types, classes, interfaces, structs |
| `property` | `red` | `#C85E60` | — | Properties / fields |
| `key` | `red` | `#C85E60` | — | Object keys, JSON, YAML, TOML |
| `tag` | `red` | `#C85E60` | — | HTML/XML tags |
| `module` | `red` | `#C85E60` | italic | Namespaces, modules, packages |
| `attribute` | `purple` | `#A178C4` | — | HTML attributes |
| `decorator` | `purple` | `#A178C4` | italic | Decorators, annotations, macros |
| `string` | `green` | `#A3C679` | — | Strings |
| `number` | `orange` | `#CD775C` | — | Numbers |
| `type_param` | `orange` | `#CD775C` | — | Type parameters / generics |
| `boolean` | `pink` | `#D6808F` | — | `true` / `false` |
| `constant` | `pink` | `#D6808F` | — | Language constants (`null`, `nil`, `None`) |
| `regex` | `pink` | `#D6808F` | — | Regular expressions |
| `escape` | `pink` | `#D6808F` | — | Escapes (`\n`, `&amp;`) |
| `self` | `steel` | `#90A9BC` | italic | `self` / `this` |
| `enum_member` | `steel` | `#90A9BC` | — | Enum members, constants |
| `readonly` | `steel` | `#90A9BC` | — | Readonly properties |
| `variable` | `fg` | `#D9D9D9` | — | Variables |
| `parameter` | `fg` | `#D9D9D9` | italic | Parameters |
| `heading` | `cyan` | `#6EBAD7` | bold | Headings (Markdown) |
| `link` | `red` | `#C85E60` | underline | Links |

## Diagnostics

| Level | Color | Hex |
|---|---|---|
| error | `red` | `#C85E60` |
| warn | `yellow` | `#D5B05F` |
| info | `blue` | `#6A90D0` |
| hint | `teal` | `#80CBC4` |
| ok | `green` | `#A3C679` |

## Git

| State | Color | Hex |
|---|---|---|
| added | `green` | `#A3C679` |
| modified | `blue` | `#6A90D0` |
| deleted | `red` | `#C85E60` |
| untracked | `green` | `#A3C679` |
| ignored | `fg_3` | `#5C5D63` |
| conflict | `orange` | `#CD775C` |

## UI rules

- **One background**: editor, sidebar, tabs, status bar and terminal all use `bg`. Areas are separated by borders, not by blocks of color.
- **Elevation by layers**: the higher an element floats, the lighter its background (`bg_1` → `bg_2` → `bg_3`).
- **One accent**: `teal` is the only highlight color of the UI. Every other color is for syntax or state.
- **Translucent backgrounds**: diff, search and diagnostic backgrounds are the state color mixed into `bg` (alpha in VS Code, `blend()` in Neovim).
- **Bracket pairs**: `yellow` → `purple` → `cyan`, repeating (VS Code). In Neovim, rainbow-delimiters gets the same colors; set its highlight order to `RainbowDelimiterYellow`, `RainbowDelimiterViolet`, `RainbowDelimiterCyan` to match.
- **Modes (Neovim)**: normal `teal`, insert `green`, visual `purple`, replace `red`, command `yellow`, terminal `cyan`.

## Black variant (VS Code: Nanquim Black · Neovim: nanquim-black)

Available in both editors. Same palette and same roles; only the background layers move one step down, so the background is pure black. The distance between layers is kept, so the selection, the cursor line and floating windows remain distinguishable.

| Name | Default | Black | Contrast of `fg_3` (comments) |
|---|---|---|---|
| `bg_dim` | `#060606` | `#0A0A0A` |  |
| `bg` | `#0A0A0A` | `#000000` | 3.2:1 |
| `bg_1` | `#111213` | `#0C0D0E` | 3.0:1 |
| `bg_2` | `#17181A` | `#131416` |  |
| `bg_3` | `#1E2023` | `#1A1C1F` |  |
| `bg_4` | `#2A2D31` | `#26292D` |  |
| `border` | `#1C1E21` | `#17181B` |  |
| `line_nr` | `#3A3D42` | `#34373C` |  |

In Black, `bg_dim` is *lighter* than the background: with `dim_inactive = true`, unfocused windows turn charcoal (`#0A0A0A`) while the focused one stays black.
