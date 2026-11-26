-- GENERATED FILE from palette.json (single source shared with the VS Code theme).
-- To customize, use setup({ on_colors = function(c) ... end }) instead of editing this file.
local M = {}

---@class NanquimColors
M.colors = {
  bg_dim = "#060606",
  bg = "#0A0A0A",
  bg_1 = "#111213",
  bg_2 = "#17181A",
  bg_3 = "#1E2023",
  bg_4 = "#2A2D31",
  border = "#1C1E21",
  line_nr = "#3A3D42",
  fg = "#D9D9D9",
  fg_1 = "#B4B5B8",
  fg_2 = "#85868C",
  fg_3 = "#5C5D63",
  teal = "#80CBC4",
  cyan = "#6EBAD7",
  blue = "#6A90D0",
  purple = "#A178C4",
  pink = "#D6808F",
  red = "#C85E60",
  orange = "#CD775C",
  yellow = "#D5B05F",
  green = "#A3C679",
  steel = "#90A9BC",
  gold = "#FFCC00",
  bright_red = "#D97A7C",
  bright_green = "#B8D696",
  bright_yellow = "#E2C47F",
  bright_blue = "#89A9DE",
  bright_purple = "#B795D4",
  bright_cyan = "#8CCBE3",
  white = "#FFFFFF",
}

-- Roles: which palette color each element uses (same as in VS Code).
M.roles = {
  syntax = {
    comment = { color = "fg_3", style = "italic" },
    keyword = { color = "cyan", style = "" },
    control = { color = "cyan", style = "italic" },
    storage = { color = "purple", style = "" },
    operator = { color = "cyan", style = "" },
    punctuation = { color = "cyan", style = "" },
    ["function"] = { color = "blue", style = "" },
    type = { color = "yellow", style = "" },
    property = { color = "red", style = "" },
    key = { color = "red", style = "" },
    tag = { color = "red", style = "" },
    module = { color = "red", style = "italic" },
    attribute = { color = "purple", style = "" },
    decorator = { color = "purple", style = "italic" },
    string = { color = "green", style = "" },
    number = { color = "orange", style = "" },
    type_param = { color = "orange", style = "" },
    boolean = { color = "pink", style = "" },
    constant = { color = "pink", style = "" },
    regex = { color = "pink", style = "" },
    escape = { color = "pink", style = "" },
    self = { color = "steel", style = "italic" },
    enum_member = { color = "steel", style = "" },
    readonly = { color = "steel", style = "" },
    variable = { color = "fg", style = "" },
    parameter = { color = "fg", style = "italic" },
    heading = { color = "cyan", style = "bold" },
    link = { color = "red", style = "underline" },
  },
  diagnostic = {
    error = "red",
    warn = "yellow",
    info = "blue",
    hint = "teal",
    ok = "green",
  },
  git = {
    added = "green",
    modified = "blue",
    deleted = "red",
    untracked = "green",
    ignored = "fg_3",
    conflict = "orange",
  },
  ui = {
    accent = "teal",
    cursor = "gold",
    selection = "bg_4",
    cursorline = "bg_1",
    float_bg = "bg_1",
    popup_bg = "bg_2",
    match = "yellow",
  },
}

-- Variants: override only the background layers. Accents and roles stay the same.
M.variants = {
  black = {
    bg_dim = "#0A0A0A",
    bg = "#000000",
    bg_1 = "#0C0D0E",
    bg_2 = "#131416",
    bg_3 = "#1A1C1F",
    bg_4 = "#26292D",
    border = "#17181B",
    line_nr = "#34373C",
  },
}

return M
