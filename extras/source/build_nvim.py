#!/usr/bin/env python3
"""Build the Neovim palette (lua/nanquim/palette.lua) and the terminal extras from palette.json.

Usage: python3 build_nvim.py <nanquim.nvim-folder>
Writes <folder>/lua/nanquim/palette.lua and <folder>/extras/* (default and every variant).
"""
import json
import sys
from pathlib import Path

SRC = Path(__file__).parent
if len(sys.argv) != 2:
    sys.exit("Usage: python3 build_nvim.py <nanquim.nvim-folder>")
OUT = Path(sys.argv[1])

P = json.loads((SRC / "palette.json").read_text())
C, R = P["colors"], P["roles"]

LUA_RESERVED = {"and", "break", "do", "else", "elseif", "end", "false", "for", "function", "goto", "if", "in",
                "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while"}


def key(k):
    """Lua table key; reserved words (e.g. `function`) must be written as ["function"]."""
    return f'["{k}"]' if k in LUA_RESERVED else k


# ---------------------------------------------------------------- palette.lua
lines = [
    "-- GENERATED FILE from palette.json (single source shared with the VS Code theme).",
    "-- To customize, use setup({ on_colors = function(c) ... end }) instead of editing this file.",
    "local M = {}",
    "",
    "---@class NanquimColors",
    "M.colors = {",
]
for k, v in C.items():
    lines.append(f'  {k} = "{v}",')
lines += ["}", "", "-- Roles: which palette color each element uses (same as in VS Code).", "M.roles = {", "  syntax = {"]
for k, (col, style) in R["syntax"].items():
    lines.append(f'    {key(k)} = {{ color = "{col}", style = "{style}" }},')
lines.append("  },")
for group in ("diagnostic", "git", "ui"):
    lines.append(f"  {group} = {{")
    for k, v in R[group].items():
        lines.append(f'    {k} = "{v}",')
    lines.append("  },")
lines += ["}", "", "-- Variants: override only the background layers. Accents and roles stay the same.", "M.variants = {"]
for vname, over in P.get("variants", {}).items():
    lines.append(f"  {vname} = {{")
    for k, v in over.items():
        lines.append(f'    {k} = "{v}",')
    lines.append("  },")
lines += ["}", "", "return M", ""]

(OUT / "lua" / "nanquim").mkdir(parents=True, exist_ok=True)
(OUT / "lua" / "nanquim" / "palette.lua").write_text("\n".join(lines))


# ---------------------------------------------------------------- terminal extras
# One folder per terminal; files are named nanquim[-<variant>].<ext> so they never clash with the
# terminal's own config file (kitty.conf, alacritty.toml, wezterm.lua...).
def extras(C, suffix=""):
    """Write the terminal color files for one palette; `suffix` names the variant (e.g. "black")."""
    title = "Nanquim" + (f" {suffix.capitalize()}" if suffix else "")
    base = "nanquim" + (f"-{suffix}" if suffix else "")

    def target(folder, ext=""):
        d = OUT / "extras" / folder
        d.mkdir(parents=True, exist_ok=True)
        return d / f"{base}{ext}"

    ansi = [C["bg_4"], C["red"], C["green"], C["yellow"], C["blue"], C["purple"], C["cyan"], C["fg"],
            C["fg_3"], C["bright_red"], C["bright_green"], C["bright_yellow"], C["bright_blue"],
            C["bright_purple"], C["bright_cyan"], C["white"]]

    kitty = [f"# {title} — kitty",
             f"# Usage: copy to ~/.config/kitty/ and add `include {base}.conf` to kitty.conf",
             f"background {C['bg']}", f"foreground {C['fg']}",
             f"cursor {C['gold']}", f"cursor_text_color {C['bg']}",
             f"selection_background {C['bg_4']}", f"selection_foreground {C['fg']}",
             f"url_color {C['teal']}", f"active_border_color {C['teal']}", f"inactive_border_color {C['bg_3']}",
             f"active_tab_background {C['bg']}", f"active_tab_foreground {C['teal']}",
             f"inactive_tab_background {C['bg']}", f"inactive_tab_foreground {C['fg_3']}",
             f"tab_bar_background {C['bg']}"]
    kitty += [f"color{i} {c}" for i, c in enumerate(ansi)]
    target("kitty", ".conf").write_text("\n".join(kitty) + "\n")

    names = ["black", "red", "green", "yellow", "blue", "magenta", "cyan", "white"]
    ala = [f"# {title} — alacritty",
           f"# Usage: copy to ~/.config/alacritty/ and add to alacritty.toml (Alacritty 0.14+):",
           f'#   [general]',
           f'#   import = ["~/.config/alacritty/{base}.toml"]',
           "[colors.primary]", f'background = "{C["bg"]}"', f'foreground = "{C["fg"]}"', "",
           "[colors.cursor]", f'cursor = "{C["gold"]}"', f'text = "{C["bg"]}"', "",
           "[colors.selection]", f'background = "{C["bg_4"]}"', 'text = "CellForeground"', "", "[colors.normal]"]
    ala += [f'{n} = "{ansi[i]}"' for i, n in enumerate(names)]
    ala += ["", "[colors.bright]"] + [f'{n} = "{ansi[i + 8]}"' for i, n in enumerate(names)]
    target("alacritty", ".toml").write_text("\n".join(ala) + "\n")

    gh = [f"# {title} — ghostty",
          f"# Usage: copy to ~/.config/ghostty/themes/ and set `theme = {base}` in the ghostty config",
          f"background = {C['bg']}", f"foreground = {C['fg']}",
          f"cursor-color = {C['gold']}", f"cursor-text = {C['bg']}",
          f"selection-background = {C['bg_4']}", f"selection-foreground = {C['fg']}"]
    gh += [f"palette = {i}={c}" for i, c in enumerate(ansi)]
    target("ghostty").write_text("\n".join(gh) + "\n")

    wez = [f"-- {title} — wezterm",
           f"-- Usage: copy next to your wezterm.lua and set:",
           f'--   config.colors = dofile(wezterm.config_dir .. "/{base}.lua")',
           "return {",
           f'  background = "{C["bg"]}",', f'  foreground = "{C["fg"]}",',
           f'  cursor_bg = "{C["gold"]}",', f'  cursor_fg = "{C["bg"]}",', f'  cursor_border = "{C["gold"]}",',
           f'  selection_bg = "{C["bg_4"]}",', f'  selection_fg = "{C["fg"]}",',
           "  ansi = { " + ", ".join(f'"{c}"' for c in ansi[:8]) + " },",
           "  brights = { " + ", ".join(f'"{c}"' for c in ansi[8:]) + " },",
           "}"]
    target("wezterm", ".lua").write_text("\n".join(wez) + "\n")

    # Windows Terminal: paste this object into the "schemes" array of settings.json (JSON has no comments),
    # then set "colorScheme": "<name>" in a profile.
    win = {"name": title, "background": C["bg"], "foreground": C["fg"], "cursorColor": C["gold"],
           "selectionBackground": C["bg_4"]}
    for i, n in enumerate(["black", "red", "green", "yellow", "blue", "purple", "cyan", "white"]):
        win[n] = ansi[i]
        win["bright" + n.capitalize()] = ansi[i + 8]
    target("windows-terminal", ".json").write_text(json.dumps(win, indent=2) + "\n")


extras(C)
for vname, over in P.get("variants", {}).items():
    extras({**C, **over}, vname)

print(f"OK -> {OUT}")
