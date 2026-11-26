#!/usr/bin/env python3
"""Build PALETTE.md (palette and role documentation) from palette.json.

Usage: python3 build_docs.py <PALETTE.md> [<another/PALETTE.md> ...]
"""
import json
import sys
from pathlib import Path

SRC = Path(__file__).parent
if len(sys.argv) < 2:
    sys.exit("Usage: python3 build_docs.py <PALETTE.md> [<another/PALETTE.md> ...]")

P = json.loads((SRC / "palette.json").read_text())
C, R = P["colors"], P["roles"]


def lum(h):
    """Relative luminance (WCAG 2.x)."""
    h = h.lstrip("#")
    r, g, b = [int(h[i:i + 2], 16) / 255 for i in (0, 2, 4)]
    f = lambda c: c / 12.92 if c <= 0.03928 else ((c + 0.055) / 1.055) ** 2.4
    return 0.2126 * f(r) + 0.7152 * f(g) + 0.0722 * f(b)


def contrast(a, b=C["bg"]):
    """WCAG contrast ratio between two hex colors."""
    la, lb = sorted([lum(a), lum(b)], reverse=True)
    return (la + 0.05) / (lb + 0.05)


GROUPS = {
    "Backgrounds (layers, darkest to lightest)": [
        ("bg_dim", "Shadows; inactive windows with `dim_inactive` (Neovim)"),
        ("bg", "Main background: editor, sidebar, tabs, status bar, terminal"),
        ("bg_1", "Surface: cursor line, inputs, hovers, floating windows, VS Code suggest widget"),
        ("bg_2", "Raised: Neovim completion menu, focused list item, widget titles"),
        ("bg_3", "Hover/selection inside menus, secondary buttons"),
        ("bg_4", "Text selection, float borders, active indent guides, Neovim window separators"),
        ("border", "Dividers between VS Code panels"),
        ("line_nr", "Line numbers"),
    ],
    "Text": [
        ("fg", "Main text, variables"),
        ("fg_1", "Secondary text: menus, general UI"),
        ("fg_2", "Muted text: sidebar, current line number, blockquotes"),
        ("fg_3", "Subtle text: comments, inactive tabs, inlay hints"),
    ],
    "Accents": [
        ("teal", "UI accent (active tab, badges, buttons, matches, normal mode); hints"),
        ("cyan", "Keywords, control flow, operators, punctuation, headings"),
        ("blue", "Functions and methods; info; git modified"),
        ("purple", "Declarations (const, let, fn, class), attributes, decorators"),
        ("pink", "Booleans, language constants (null, nil, None), regex, escapes"),
        ("red", "Properties, keys (JSON/YAML), HTML tags, modules; error; git deleted"),
        ("orange", "Numbers, type parameters, CSS ids; git conflict"),
        ("yellow", "Types, classes, interfaces, components; warning; search"),
        ("green", "Strings; git added; success"),
        ("steel", "self/this, enum members, readonly properties, CSS properties"),
        ("gold", "Cursor"),
    ],
    "Bright variants (terminal ANSI 8-15)": [
        ("bright_red", "ANSI 9"), ("bright_green", "ANSI 10"), ("bright_yellow", "ANSI 11"),
        ("bright_blue", "ANSI 12"), ("bright_purple", "ANSI 13"), ("bright_cyan", "ANSI 14"),
        ("white", "ANSI 15"),
    ],
}

ROLE_DESC = {
    "comment": "Comments", "keyword": "Keywords (`new`, `in`, `typeof`)",
    "control": "Control flow (`if`, `for`, `return`, `import`)",
    "storage": "Declarations (`const`, `let`, `function`, `class`, `def`, `fn`)",
    "operator": "Operators", "punctuation": "Punctuation and delimiters",
    "function": "Functions and methods (definition and call)", "type": "Types, classes, interfaces, structs",
    "property": "Properties / fields", "key": "Object keys, JSON, YAML, TOML",
    "tag": "HTML/XML tags", "module": "Namespaces, modules, packages", "attribute": "HTML attributes",
    "decorator": "Decorators, annotations, macros", "string": "Strings", "number": "Numbers",
    "type_param": "Type parameters / generics", "boolean": "`true` / `false`",
    "constant": "Language constants (`null`, `nil`, `None`)", "regex": "Regular expressions",
    "escape": "Escapes (`\\n`, `&amp;`)", "self": "`self` / `this`", "enum_member": "Enum members, constants",
    "readonly": "Readonly properties", "variable": "Variables", "parameter": "Parameters",
    "heading": "Headings (Markdown)", "link": "Links",
}

out = [f"# {P['name']} palette", "", P["description"], "",
       "Single source: `palette.json`. The VS Code theme and the Neovim theme are both generated from it, "
       "so the same roles use the same colors in both editors.", "",
       f"Contrast is measured against the `bg` background ({C['bg']}), per WCAG (4.5:1 = AA for text).", ""]
for title, items in GROUPS.items():
    out += [f"## {title}", "", "| Name | Hex | Contrast | Used for |", "|---|---|---|---|"]
    for name, use in items:
        out.append(f"| `{name}` | `{C[name]}` | {contrast(C[name]):.1f}:1 | {use} |")
    out.append("")

out += ["## Syntax roles", "", "| Role | Color | Hex | Style | What it paints |", "|---|---|---|---|---|"]
for role, (col, style) in R["syntax"].items():
    out.append(f"| `{role}` | `{col}` | `{C[col]}` | {style or '—'} | {ROLE_DESC.get(role, '')} |")
out += ["", "## Diagnostics", "", "| Level | Color | Hex |", "|---|---|---|"]
out += [f"| {k} | `{v}` | `{C[v]}` |" for k, v in R["diagnostic"].items()]
out += ["", "## Git", "", "| State | Color | Hex |", "|---|---|---|"]
out += [f"| {k} | `{v}` | `{C[v]}` |" for k, v in R["git"].items()]
out += ["", "## UI rules", "",
        "- **One background**: editor, sidebar, tabs, status bar and terminal all use `bg`. "
        "Areas are separated by borders, not by blocks of color.",
        "- **Elevation by layers**: the higher an element floats, the lighter its background (`bg_1` → `bg_2` → `bg_3`).",
        "- **One accent**: `teal` is the only highlight color of the UI. Every other color is for syntax or state.",
        "- **Translucent backgrounds**: diff, search and diagnostic backgrounds are the state color mixed into `bg` "
        "(alpha in VS Code, `blend()` in Neovim).",
        "- **Bracket pairs**: `yellow` → `purple` → `cyan`, repeating (VS Code). In Neovim, rainbow-delimiters gets "
        "the same colors; set its highlight order to `RainbowDelimiterYellow`, `RainbowDelimiterViolet`, "
        "`RainbowDelimiterCyan` to match.",
        "- **Modes (Neovim)**: normal `teal`, insert `green`, visual `purple`, replace `red`, command `yellow`, terminal `cyan`.",
        ""]

V = P.get("variants", {})
if "black" in V:
    out += ["## Black variant (VS Code: Nanquim Black · Neovim: nanquim-black)", "",
            "Available in both editors. Same palette and same roles; only the background layers move one step down, "
            "so the background is pure black. The distance between layers is kept, so the selection, the cursor line "
            "and floating windows remain distinguishable.", "",
            "| Name | Default | Black | Contrast of `fg_3` (comments) |", "|---|---|---|---|"]
    for k, v in V["black"].items():
        extra = f"{contrast(C['fg_3'], v):.1f}:1" if k in ("bg", "bg_1") else ""
        out.append(f"| `{k}` | `{C[k]}` | `{v}` | {extra} |")
    out += ["", "In Black, `bg_dim` is *lighter* than the background: with `dim_inactive = true`, "
            "unfocused windows turn charcoal (`#0A0A0A`) while the focused one stays black.", ""]

for target in sys.argv[1:]:
    Path(target).write_text("\n".join(out))
print("OK", sys.argv[1:])
