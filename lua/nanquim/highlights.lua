local blend = require("nanquim.util").blend

local M = {}

---@param c table palette colors
---@param roles table roles (palette.lua)
---@param opts NanquimConfig
function M.get(c, roles, opts)
  local st = opts.styles
  local bg = opts.transparent and "NONE" or c.bg
  local bg_side = opts.transparent and "NONE" or c.bg
  local bg_float = opts.transparent and "NONE" or c[roles.ui.float_bg]
  local bg_popup = c[roles.ui.popup_bg]
  local accent = c[roles.ui.accent]
  local sel = c[roles.ui.selection]
  local cursorline = c[roles.ui.cursorline]

  local d = {}
  for k, v in pairs(roles.diagnostic) do
    d[k] = c[v]
  end
  local g = {}
  for k, v in pairs(roles.git) do
    g[k] = c[v]
  end

  -- Syntax role -> highlight spec ({ fg, italic, bold, underline })
  local function S(role, extra)
    local r = roles.syntax[role]
    local spec = { fg = c[r.color] }
    for flag in r.style:gmatch("%S+") do
      spec[flag] = true
    end
    return vim.tbl_extend("force", spec, extra or {})
  end

  local function A(color, alpha, base)
    return blend(color, base or c.bg, alpha)
  end

  local hl = {}

  -- ===================================================================== Editor
  hl.Normal = { fg = c.fg, bg = bg }
  hl.NormalNC = { fg = c.fg, bg = opts.dim_inactive and c.bg_dim or bg }
  hl.NormalFloat = { fg = c.fg, bg = bg_float }
  hl.FloatBorder = { fg = c.bg_4, bg = bg_float }
  hl.FloatTitle = { fg = accent, bg = bg_float, bold = true }
  hl.FloatFooter = { fg = c.fg_2, bg = bg_float }
  hl.NormalSB = { fg = c.fg_2, bg = bg_side }
  hl.Cursor = { fg = c.bg, bg = c[roles.ui.cursor] }
  hl.lCursor = { link = "Cursor" }
  hl.CursorIM = { link = "Cursor" }
  hl.TermCursor = { link = "Cursor" }
  hl.CursorLine = { bg = cursorline }
  hl.CursorColumn = { bg = cursorline }
  hl.ColorColumn = { bg = c.bg_1 }
  hl.LineNr = { fg = c.line_nr }
  hl.LineNrAbove = { link = "LineNr" }
  hl.LineNrBelow = { link = "LineNr" }
  hl.CursorLineNr = { fg = c.fg_2, bold = true }
  hl.SignColumn = { fg = c.fg_3, bg = bg }
  hl.FoldColumn = { fg = c.fg_3, bg = bg }
  hl.Folded = { fg = c.fg_2, bg = c.bg_1 }
  hl.VertSplit = { fg = c.bg_4 }
  hl.WinSeparator = { fg = c.bg_4, bold = true }
  hl.Visual = { bg = sel }
  hl.VisualNOS = { bg = sel }
  hl.Search = { fg = c.fg, bg = A(c.yellow, 0.25) }
  hl.IncSearch = { fg = c.bg, bg = c.yellow }
  hl.CurSearch = { link = "IncSearch" }
  hl.Substitute = { fg = c.bg, bg = c.red }
  hl.MatchParen = { fg = accent, bg = A(accent, 0.15), bold = true }
  hl.NonText = { fg = c.line_nr }
  hl.Whitespace = { fg = c.bg_4 }
  hl.SpecialKey = { fg = c.bg_4 }
  hl.EndOfBuffer = { fg = c.bg }
  hl.Conceal = { fg = c.fg_3 }
  hl.Directory = { fg = c.blue }
  hl.Title = { fg = c.cyan, bold = true }
  hl.ErrorMsg = { fg = d.error }
  hl.WarningMsg = { fg = d.warn }
  hl.MoreMsg = { fg = accent }
  hl.ModeMsg = { fg = c.fg_1, bold = true }
  hl.Question = { fg = accent }
  hl.MsgArea = { fg = c.fg_1 }
  hl.MsgSeparator = { fg = c.border }
  hl.QuickFixLine = { bg = c.bg_2, bold = true }
  hl.WildMenu = { bg = sel }
  hl.WinBar = { fg = c.fg_2, bg = bg }
  hl.WinBarNC = { fg = c.fg_3, bg = bg }
  hl.StatusLine = { fg = c.fg_2, bg = bg }
  hl.StatusLineNC = { fg = c.fg_3, bg = bg }
  hl.TabLine = { fg = c.fg_3, bg = bg }
  hl.TabLineFill = { bg = bg }
  hl.TabLineSel = { fg = c.fg, bg = c.bg_2, bold = true }
  hl.Pmenu = { fg = c.fg_1, bg = bg_popup }
  hl.PmenuSel = { fg = c.fg, bg = c.bg_4 }
  hl.PmenuKind = { fg = c.purple, bg = bg_popup }
  hl.PmenuKindSel = { fg = c.purple, bg = c.bg_4 }
  hl.PmenuExtra = { fg = c.fg_3, bg = bg_popup }
  hl.PmenuExtraSel = { fg = c.fg_2, bg = c.bg_4 }
  hl.PmenuSbar = { bg = bg_popup }
  hl.PmenuThumb = { bg = c.bg_4 }
  hl.PmenuMatch = { fg = accent, bold = true }
  hl.PmenuMatchSel = { fg = accent, bold = true }
  hl.SpellBad = { sp = d.error, undercurl = true }
  hl.SpellCap = { sp = d.warn, undercurl = true }
  hl.SpellLocal = { sp = d.info, undercurl = true }
  hl.SpellRare = { sp = d.hint, undercurl = true }
  hl.DiffAdd = { bg = A(g.added, 0.12) }
  hl.DiffDelete = { bg = A(g.deleted, 0.14) }
  hl.DiffChange = { bg = A(g.modified, 0.10) }
  hl.DiffText = { bg = A(g.modified, 0.25) }
  hl.Added = { fg = g.added }
  hl.Changed = { fg = g.modified }
  hl.Removed = { fg = g.deleted }
  hl.diffAdded = { fg = g.added }
  hl.diffRemoved = { fg = g.deleted }
  hl.diffChanged = { fg = g.modified }
  hl.diffLine = { fg = c.purple }
  hl.diffFile = { fg = c.yellow }
  hl.healthError = { fg = d.error }
  hl.healthSuccess = { fg = d.ok }
  hl.healthWarning = { fg = d.warn }

  -- ===================================================================== Syntax (legacy :syntax groups)
  hl.Comment = vim.tbl_extend("force", { fg = c[roles.syntax.comment.color] }, st.comments)
  hl.Constant = S("constant")
  hl.String = S("string")
  hl.Character = S("string")
  hl.Number = S("number")
  hl.Float = S("number")
  hl.Boolean = S("boolean")
  hl.Identifier = vim.tbl_extend("force", S("variable"), st.variables)
  hl.Function = vim.tbl_extend("force", S("function"), st.functions)
  hl.Statement = S("keyword")
  hl.Conditional = vim.tbl_extend("force", { fg = c[roles.syntax.control.color] }, st.control)
  hl.Repeat = { link = "Conditional" }
  hl.Label = S("keyword")
  hl.Operator = S("operator")
  hl.Keyword = vim.tbl_extend("force", { fg = c[roles.syntax.keyword.color] }, st.keywords)
  hl.Exception = { link = "Conditional" }
  hl.PreProc = S("decorator")
  hl.Include = { link = "Conditional" }
  hl.Define = S("storage")
  hl.Macro = S("decorator")
  hl.PreCondit = S("decorator")
  hl.Type = S("type")
  hl.StorageClass = S("storage")
  hl.Structure = S("type")
  hl.Typedef = S("storage")
  hl.Special = S("escape")
  hl.SpecialChar = S("escape")
  hl.Tag = S("tag")
  hl.Delimiter = S("punctuation")
  hl.SpecialComment = { fg = c.fg_2, italic = true }
  hl.Debug = { fg = c.orange }
  hl.Underlined = { underline = true }
  hl.Bold = { bold = true }
  hl.Italic = { italic = true }
  hl.Ignore = { fg = c.fg_3 }
  hl.Error = { fg = d.error }
  hl.Todo = { fg = c.bg, bg = c.yellow, bold = true }

  -- ===================================================================== Treesitter
  local ts = {
    ["@comment"] = { link = "Comment" },
    ["@comment.documentation"] = { link = "Comment" },
    ["@comment.error"] = { fg = c.bg, bg = d.error, bold = true },
    ["@comment.warning"] = { fg = c.bg, bg = d.warn, bold = true },
    ["@comment.todo"] = { fg = c.bg, bg = c.yellow, bold = true },
    ["@comment.note"] = { fg = c.bg, bg = d.info, bold = true },

    ["@string"] = S("string"),
    ["@string.documentation"] = S("string"),
    ["@string.escape"] = S("escape"),
    ["@string.regexp"] = S("regex"),
    ["@string.special"] = S("escape"),
    ["@string.special.symbol"] = S("enum_member"),
    ["@string.special.url"] = S("link"),
    ["@string.special.path"] = S("string"),
    ["@character"] = S("string"),
    ["@character.special"] = S("escape"),

    ["@number"] = S("number"),
    ["@number.float"] = S("number"),
    ["@boolean"] = S("boolean"),
    ["@constant"] = S("enum_member"),
    ["@constant.builtin"] = S("constant"),
    ["@constant.macro"] = S("decorator"),

    ["@keyword"] = { link = "Keyword" },
    ["@keyword.coroutine"] = { link = "Conditional" },
    ["@keyword.function"] = S("storage"),
    ["@keyword.type"] = S("storage"),
    ["@keyword.modifier"] = S("storage"),
    ["@keyword.operator"] = S("keyword"),
    ["@keyword.import"] = { link = "Conditional" },
    ["@keyword.repeat"] = { link = "Conditional" },
    ["@keyword.return"] = { link = "Conditional" },
    ["@keyword.exception"] = { link = "Conditional" },
    ["@keyword.conditional"] = { link = "Conditional" },
    ["@keyword.conditional.ternary"] = S("operator"),
    ["@keyword.directive"] = S("decorator"),
    ["@keyword.directive.define"] = S("decorator"),
    ["@keyword.debug"] = { fg = c.orange },
    ["@operator"] = S("operator"),
    ["@punctuation"] = S("punctuation"),
    ["@punctuation.bracket"] = S("punctuation"),
    ["@punctuation.delimiter"] = S("punctuation"),
    ["@punctuation.special"] = S("keyword"),
    ["@label"] = S("keyword"),

    ["@variable"] = vim.tbl_extend("force", S("variable"), st.variables),
    ["@variable.builtin"] = S("self"),
    ["@variable.parameter"] = vim.tbl_extend("force", { fg = c[roles.syntax.parameter.color] }, st.parameters),
    ["@variable.parameter.builtin"] = S("self"),
    ["@variable.member"] = S("property"),
    ["@property"] = S("property"),

    ["@function"] = { link = "Function" },
    ["@function.builtin"] = { link = "Function" },
    ["@function.call"] = { link = "Function" },
    ["@function.macro"] = S("decorator"),
    ["@function.method"] = { link = "Function" },
    ["@function.method.call"] = { link = "Function" },
    ["@constructor"] = S("type"),

    ["@type"] = S("type"),
    ["@type.builtin"] = S("type"),
    ["@type.definition"] = S("type"),
    ["@attribute"] = S("decorator"),
    ["@attribute.builtin"] = S("decorator"),
    ["@module"] = S("module"),
    ["@module.builtin"] = S("module"),

    ["@tag"] = S("tag"),
    ["@tag.builtin"] = S("tag"),
    ["@tag.attribute"] = S("attribute"),
    ["@tag.delimiter"] = S("punctuation"),

    ["@markup.heading"] = S("heading"),
    ["@markup.heading.1"] = { fg = c.teal, bold = true },
    ["@markup.heading.2"] = S("heading"),
    ["@markup.heading.3"] = { fg = c.blue, bold = true },
    ["@markup.heading.4"] = { fg = c.purple, bold = true },
    ["@markup.heading.5"] = { fg = c.yellow, bold = true },
    ["@markup.heading.6"] = { fg = c.orange, bold = true },
    ["@markup.strong"] = { fg = c.red, bold = true },
    ["@markup.italic"] = { fg = c.red, italic = true },
    ["@markup.strikethrough"] = { fg = c.fg_2, strikethrough = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.quote"] = { fg = c.fg_2, italic = true },
    ["@markup.math"] = S("number"),
    ["@markup.link"] = { fg = c.red },
    ["@markup.link.label"] = { fg = c.red },
    ["@markup.link.url"] = S("link"),
    ["@markup.raw"] = S("string"),
    ["@markup.raw.block"] = { fg = c.fg },
    ["@markup.list"] = S("punctuation"),
    ["@markup.list.checked"] = { fg = d.ok },
    ["@markup.list.unchecked"] = { fg = c.fg_3 },
    ["@diff.plus"] = { fg = g.added },
    ["@diff.minus"] = { fg = g.deleted },
    ["@diff.delta"] = { fg = g.modified },

    -- Language-specific tweaks (same rules as the VS Code theme)
    ["@property.json"] = S("key"),
    ["@property.yaml"] = S("key"),
    ["@property.toml"] = S("key"),
    ["@property.css"] = { fg = c.steel },
    ["@property.scss"] = { fg = c.steel },
    -- CSS: classes stay in @type (yellow, as in VS Code); ids are @constant (orange)
    ["@constant.css"] = S("number"),
    ["@keyword.directive.css"] = S("storage"),
    ["@keyword.import.css"] = S("storage"),
    -- JSX: nvim-treesitter captures components (Capitalized) as @tag and HTML tags as @tag.builtin.
    -- .jsx files use the "javascript" parser; .tsx files use "tsx".
    ["@tag.javascript"] = S("type"),
    ["@tag.tsx"] = S("type"),
    ["@tag.builtin.javascript"] = S("tag"),
    ["@tag.builtin.tsx"] = S("tag"),
    ["@variable.member.lua"] = S("property"),
    ["@constructor.lua"] = S("punctuation"),
  }
  for k, v in pairs(ts) do
    hl[k] = v
  end

  -- Old capture names (Neovim 0.9 / nvim-treesitter before 2024) -> current names
  local legacy = {
    ["@field"] = "@variable.member", ["@parameter"] = "@variable.parameter",
    ["@parameter.reference"] = "@variable.parameter", ["@method"] = "@function.method",
    ["@method.call"] = "@function.method.call", ["@namespace"] = "@module", ["@float"] = "@number.float",
    ["@symbol"] = "@string.special.symbol", ["@string.regex"] = "@string.regexp",
    ["@string.special.url"] = "@markup.link.url", ["@conditional"] = "@keyword.conditional",
    ["@conditional.ternary"] = "@keyword.conditional.ternary", ["@repeat"] = "@keyword.repeat",
    ["@exception"] = "@keyword.exception", ["@include"] = "@keyword.import",
    ["@storageclass"] = "@keyword.modifier", ["@define"] = "@keyword.directive.define",
    ["@preproc"] = "@keyword.directive", ["@debug"] = "@keyword.debug",
    ["@text.title"] = "@markup.heading", ["@text.literal"] = "@markup.raw", ["@text.uri"] = "@markup.link.url",
    ["@text.reference"] = "@markup.link", ["@text.emphasis"] = "@markup.italic", ["@text.strong"] = "@markup.strong",
    ["@text.strike"] = "@markup.strikethrough", ["@text.underline"] = "@markup.underline",
    ["@text.quote"] = "@markup.quote", ["@text.math"] = "@markup.math", ["@text.todo"] = "@comment.todo",
    ["@text.note"] = "@comment.note", ["@text.warning"] = "@comment.warning", ["@text.danger"] = "@comment.error",
    ["@text.diff.add"] = "@diff.plus", ["@text.diff.delete"] = "@diff.minus",
  }
  for old, new in pairs(legacy) do
    if hl[old] == nil then
      hl[old] = { link = new }
    end
  end

  -- ===================================================================== LSP semantic tokens
  local lsp = {
    ["@lsp.type.namespace"] = { link = "@module" },
    ["@lsp.type.class"] = { link = "@type" },
    ["@lsp.type.struct"] = { link = "@type" },
    ["@lsp.type.interface"] = { link = "@type" },
    ["@lsp.type.enum"] = { link = "@type" },
    ["@lsp.type.type"] = { link = "@type" },
    ["@lsp.type.typeParameter"] = S("type_param"),
    ["@lsp.type.builtinType"] = { link = "@type.builtin" },
    ["@lsp.type.function"] = { link = "@function" },
    ["@lsp.type.method"] = { link = "@function.method" },
    ["@lsp.type.macro"] = { link = "@function.macro" },
    ["@lsp.type.decorator"] = { link = "@attribute" },
    ["@lsp.type.variable"] = {}, -- let Treesitter decide
    ["@lsp.type.parameter"] = { link = "@variable.parameter" },
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.enumMember"] = S("enum_member"),
    ["@lsp.type.event"] = { fg = c.orange },
    ["@lsp.type.keyword"] = { link = "@keyword" },
    ["@lsp.type.comment"] = {}, -- do not override Treesitter comments (TODO etc.)
    ["@lsp.type.string"] = {},
    ["@lsp.type.number"] = { link = "@number" },
    ["@lsp.type.boolean"] = { link = "@boolean" },
    ["@lsp.type.operator"] = { link = "@operator" },
    ["@lsp.type.lifetime"] = S("type_param"),
    ["@lsp.type.selfKeyword"] = S("self"),
    ["@lsp.type.selfParameter"] = S("self"),
    ["@lsp.typemod.property.readonly"] = S("readonly"),
    ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
    ["@lsp.typemod.variable.global"] = S("variable"),
    ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.mod.deprecated"] = { strikethrough = true },
  }
  for k, v in pairs(lsp) do
    hl[k] = v
  end

  -- ===================================================================== Diagnostics / LSP UI
  for name, key in pairs({ Error = "error", Warn = "warn", Info = "info", Hint = "hint", Ok = "ok" }) do
    local col = d[key]
    hl["Diagnostic" .. name] = { fg = col }
    hl["DiagnosticVirtualText" .. name] = { fg = col, bg = A(col, 0.08) }
    hl["DiagnosticUnderline" .. name] = { sp = col, undercurl = true }
    hl["DiagnosticFloating" .. name] = { fg = col }
    hl["DiagnosticSign" .. name] = { fg = col }
    hl["DiagnosticVirtualLines" .. name] = { fg = col }
  end
  hl.DiagnosticUnnecessary = { fg = c.fg_3 }
  hl.DiagnosticDeprecated = { strikethrough = true }
  hl.LspReferenceText = { bg = A(c.fg, 0.08) }
  hl.LspReferenceRead = { bg = A(c.fg, 0.08) }
  hl.LspReferenceWrite = { bg = A(accent, 0.14) }
  hl.LspReferenceTarget = { link = "LspReferenceText" }
  hl.LspSignatureActiveParameter = { fg = accent, bold = true, underline = true }
  hl.LspCodeLens = { fg = c.fg_3 }
  hl.LspCodeLensSeparator = { fg = c.bg_4 }
  hl.LspInlayHint = { fg = c.fg_3, bg = A(c.bg_2, 0.8) }
  hl.LspInfoBorder = { link = "FloatBorder" }

  -- ===================================================================== Plugins
  -- gitsigns
  hl.GitSignsAdd = { fg = g.added }
  hl.GitSignsChange = { fg = g.modified }
  hl.GitSignsDelete = { fg = g.deleted }
  hl.GitSignsAddInline = { bg = A(g.added, 0.25) }
  hl.GitSignsDeleteInline = { bg = A(g.deleted, 0.25) }
  hl.GitSignsChangeInline = { bg = A(g.modified, 0.25) }
  hl.GitSignsCurrentLineBlame = { fg = c.fg_3, italic = true }
  -- mini.diff
  hl.MiniDiffSignAdd = { fg = g.added }
  hl.MiniDiffSignChange = { fg = g.modified }
  hl.MiniDiffSignDelete = { fg = g.deleted }

  -- telescope
  hl.TelescopeNormal = { link = "NormalFloat" }
  hl.TelescopeBorder = { link = "FloatBorder" }
  hl.TelescopeTitle = { link = "FloatTitle" }
  hl.TelescopePromptNormal = { fg = c.fg, bg = bg_float }
  hl.TelescopePromptBorder = { link = "FloatBorder" }
  hl.TelescopePromptPrefix = { fg = accent }
  hl.TelescopePromptCounter = { fg = c.fg_3 }
  hl.TelescopeSelection = { fg = c.fg, bg = c.bg_3 }
  hl.TelescopeSelectionCaret = { fg = accent, bg = c.bg_3 }
  hl.TelescopeMatching = { fg = accent, bold = true }
  hl.TelescopeResultsComment = { fg = c.fg_3 }

  -- fzf-lua
  hl.FzfLuaNormal = { link = "NormalFloat" }
  hl.FzfLuaBorder = { link = "FloatBorder" }
  hl.FzfLuaTitle = { link = "FloatTitle" }
  hl.FzfLuaCursorLine = { bg = c.bg_3 }
  hl.FzfLuaSearch = { fg = accent, bold = true }

  -- snacks.nvim
  hl.SnacksPickerMatch = { fg = accent, bold = true }
  hl.SnacksPickerPrompt = { fg = accent }
  hl.SnacksPickerDir = { fg = c.fg_3 }
  hl.SnacksPickerBorder = { link = "FloatBorder" }
  hl.SnacksPickerTitle = { link = "FloatTitle" }
  hl.SnacksIndent = { fg = c.bg_3, nocombine = true }
  hl.SnacksIndentScope = { fg = c.bg_4, nocombine = true }
  hl.SnacksDashboardHeader = { fg = accent }
  hl.SnacksDashboardIcon = { fg = c.cyan }
  hl.SnacksDashboardKey = { fg = c.orange }
  hl.SnacksDashboardDesc = { fg = c.fg_1 }
  hl.SnacksDashboardFooter = { fg = c.fg_3 }
  hl.SnacksNotifierBorderInfo = { fg = d.info }
  hl.SnacksNotifierBorderWarn = { fg = d.warn }
  hl.SnacksNotifierBorderError = { fg = d.error }

  -- nvim-cmp
  hl.CmpItemAbbr = { fg = c.fg_1 }
  hl.CmpItemAbbrDeprecated = { fg = c.fg_3, strikethrough = true }
  hl.CmpItemAbbrMatch = { fg = accent, bold = true }
  hl.CmpItemAbbrMatchFuzzy = { fg = accent }
  hl.CmpItemMenu = { fg = c.fg_3 }
  hl.CmpGhostText = { fg = c.fg_3 }
  -- blink.cmp
  hl.BlinkCmpMenu = { link = "Pmenu" }
  hl.BlinkCmpMenuBorder = { fg = c.bg_4, bg = bg_popup }
  hl.BlinkCmpMenuSelection = { link = "PmenuSel" }
  hl.BlinkCmpLabelMatch = { fg = accent, bold = true }
  hl.BlinkCmpLabelDeprecated = { fg = c.fg_3, strikethrough = true }
  hl.BlinkCmpLabelDetail = { fg = c.fg_3 }
  hl.BlinkCmpLabelDescription = { fg = c.fg_3 }
  hl.BlinkCmpSource = { fg = c.fg_3 }
  hl.BlinkCmpGhostText = { fg = c.fg_3 }
  hl.BlinkCmpDoc = { link = "NormalFloat" }
  hl.BlinkCmpDocBorder = { link = "FloatBorder" }
  hl.BlinkCmpSignatureHelp = { link = "NormalFloat" }
  hl.BlinkCmpSignatureHelpBorder = { link = "FloatBorder" }

  -- Completion/symbol "kind" icons (same colors as VS Code symbolIcon.*)
  local kinds = {
    Text = c.fg_1, Method = c.blue, Function = c.blue, Constructor = c.yellow, Field = c.red,
    Variable = c.fg, Class = c.yellow, Interface = c.yellow, Module = c.red, Property = c.red,
    Unit = c.orange, Value = c.orange, Enum = c.yellow, Keyword = c.cyan, Snippet = c.teal,
    Color = c.pink, File = c.fg_1, Reference = c.steel, Folder = c.fg_1, EnumMember = c.steel,
    Constant = c.pink, Struct = c.yellow, Event = c.orange, Operator = c.cyan, TypeParameter = c.orange,
    Namespace = c.red, Package = c.red, String = c.green, Number = c.orange, Boolean = c.pink,
    Array = c.orange, Object = c.yellow, Key = c.red, Null = c.pink, Copilot = c.teal,
  }
  for kind, col in pairs(kinds) do
    hl["CmpItemKind" .. kind] = { fg = col }
    hl["BlinkCmpKind" .. kind] = { fg = col }
    hl["NavicIcons" .. kind] = { fg = col }
    hl["Aerial" .. kind .. "Icon"] = { fg = col }
  end

  -- neo-tree / nvim-tree / oil
  hl.NeoTreeNormal = { fg = c.fg_2, bg = bg_side }
  hl.NeoTreeNormalNC = { fg = c.fg_2, bg = bg_side }
  hl.NeoTreeWinSeparator = { fg = c.bg_4, bg = bg_side }
  hl.NeoTreeRootName = { fg = c.fg_1, bold = true }
  hl.NeoTreeDirectoryName = { fg = c.fg_1 }
  hl.NeoTreeDirectoryIcon = { fg = c.fg_2 }
  hl.NeoTreeFileName = { fg = c.fg_2 }
  hl.NeoTreeFileNameOpened = { fg = c.fg }
  hl.NeoTreeIndentMarker = { fg = c.bg_4 }
  hl.NeoTreeExpander = { fg = c.fg_3 }
  hl.NeoTreeCursorLine = { bg = c.bg_2 }
  hl.NeoTreeDimText = { fg = c.fg_3 }
  hl.NeoTreeGitAdded = { fg = g.added }
  hl.NeoTreeGitModified = { fg = g.modified }
  hl.NeoTreeGitDeleted = { fg = g.deleted }
  hl.NeoTreeGitUntracked = { fg = g.untracked }
  hl.NeoTreeGitIgnored = { fg = g.ignored }
  hl.NeoTreeGitConflict = { fg = g.conflict }
  hl.NeoTreeTabActive = { fg = accent, bold = true }
  hl.NeoTreeTabInactive = { fg = c.fg_3 }
  hl.NvimTreeNormal = { fg = c.fg_2, bg = bg_side }
  hl.NvimTreeNormalNC = { link = "NvimTreeNormal" }
  hl.NvimTreeWinSeparator = { fg = c.bg_4, bg = bg_side }
  hl.NvimTreeRootFolder = { fg = c.fg_1, bold = true }
  hl.NvimTreeFolderName = { fg = c.fg_1 }
  hl.NvimTreeOpenedFolderName = { fg = c.fg }
  hl.NvimTreeFolderIcon = { fg = c.fg_2 }
  hl.NvimTreeIndentMarker = { fg = c.bg_4 }
  hl.NvimTreeCursorLine = { bg = c.bg_2 }
  hl.NvimTreeGitNew = { fg = g.added }
  hl.NvimTreeGitDirty = { fg = g.modified }
  hl.NvimTreeGitDeleted = { fg = g.deleted }
  hl.NvimTreeGitIgnored = { fg = g.ignored }
  hl.NvimTreeSpecialFile = { fg = c.yellow }
  hl.OilDir = { fg = c.blue }
  hl.OilFile = { fg = c.fg }

  -- indent-blankline / mini.indentscope
  hl.IblIndent = { fg = c.bg_3, nocombine = true }
  hl.IblWhitespace = { fg = c.bg_3, nocombine = true }
  hl.IblScope = { fg = c.bg_4, nocombine = true }
  hl.MiniIndentscopeSymbol = { fg = c.bg_4, nocombine = true }

  -- rainbow-delimiters (set its order to Yellow, Violet, Cyan to match VS Code bracket pairs)
  hl.RainbowDelimiterYellow = { fg = c.yellow }
  hl.RainbowDelimiterViolet = { fg = c.purple }
  hl.RainbowDelimiterCyan = { fg = c.cyan }
  hl.RainbowDelimiterBlue = { fg = c.blue }
  hl.RainbowDelimiterOrange = { fg = c.orange }
  hl.RainbowDelimiterGreen = { fg = c.green }
  hl.RainbowDelimiterRed = { fg = c.red }

  -- which-key
  hl.WhichKey = { fg = accent }
  hl.WhichKeyGroup = { fg = c.blue }
  hl.WhichKeyDesc = { fg = c.fg_1 }
  hl.WhichKeySeparator = { fg = c.fg_3 }
  hl.WhichKeyValue = { fg = c.fg_3 }
  hl.WhichKeyNormal = { link = "NormalFloat" }
  hl.WhichKeyBorder = { link = "FloatBorder" }
  hl.WhichKeyTitle = { link = "FloatTitle" }

  -- noice / notify
  hl.NoiceCmdlinePopup = { fg = c.fg, bg = bg_float }
  hl.NoiceCmdlinePopupBorder = { fg = c.bg_4 }
  hl.NoiceCmdlinePopupTitle = { fg = accent }
  hl.NoiceCmdlineIcon = { fg = accent }
  hl.NoiceCmdlinePopupBorderSearch = { fg = c.yellow }
  hl.NoiceCmdlineIconSearch = { fg = c.yellow }
  hl.NoiceConfirmBorder = { fg = c.bg_4 }
  hl.NoiceMini = { fg = c.fg_2, bg = bg_float }
  hl.NotifyBackground = { bg = c.bg_1 }
  hl.NotifyERRORBorder = { fg = A(d.error, 0.5) }
  hl.NotifyWARNBorder = { fg = A(d.warn, 0.5) }
  hl.NotifyINFOBorder = { fg = A(d.info, 0.5) }
  hl.NotifyDEBUGBorder = { fg = c.bg_4 }
  hl.NotifyTRACEBorder = { fg = A(c.purple, 0.5) }
  hl.NotifyERRORIcon = { fg = d.error }
  hl.NotifyWARNIcon = { fg = d.warn }
  hl.NotifyINFOIcon = { fg = d.info }
  hl.NotifyDEBUGIcon = { fg = c.fg_3 }
  hl.NotifyTRACEIcon = { fg = c.purple }
  hl.NotifyERRORTitle = { fg = d.error }
  hl.NotifyWARNTitle = { fg = d.warn }
  hl.NotifyINFOTitle = { fg = d.info }
  hl.NotifyDEBUGTitle = { fg = c.fg_3 }
  hl.NotifyTRACETitle = { fg = c.purple }

  -- bufferline
  hl.BufferLineFill = { bg = bg }
  hl.BufferLineIndicatorSelected = { fg = accent }
  hl.BufferLineBufferSelected = { fg = c.fg, bold = true }

  -- flash / leap / hop
  hl.FlashLabel = { fg = c.bg, bg = c.pink, bold = true }
  hl.FlashMatch = { fg = c.fg, bg = A(c.blue, 0.3) }
  hl.FlashCurrent = { fg = c.bg, bg = c.yellow }
  hl.FlashBackdrop = { fg = c.fg_3 }
  hl.LeapLabel = { fg = c.pink, bold = true }
  hl.HopNextKey = { fg = c.pink, bold = true }
  hl.HopNextKey1 = { fg = c.cyan, bold = true }
  hl.HopNextKey2 = { fg = c.blue }

  -- trouble
  hl.TroubleNormal = { fg = c.fg_1, bg = bg_side }
  hl.TroubleNormalNC = { fg = c.fg_1, bg = bg_side }
  hl.TroubleText = { fg = c.fg_1 }
  hl.TroubleCount = { fg = accent, bg = c.bg_3 }

  -- lazy / mason
  hl.LazyNormal = { link = "NormalFloat" }
  hl.LazyButton = { fg = c.fg_1, bg = c.bg_3 }
  hl.LazyButtonActive = { fg = c.bg, bg = accent, bold = true }
  hl.LazyH1 = { fg = c.bg, bg = accent, bold = true }
  hl.LazySpecial = { fg = c.cyan }
  hl.LazyProgressDone = { fg = accent }
  hl.LazyProgressTodo = { fg = c.bg_4 }
  hl.MasonNormal = { link = "NormalFloat" }
  hl.MasonHeader = { fg = c.bg, bg = accent, bold = true }
  hl.MasonHighlight = { fg = accent }
  hl.MasonHighlightBlock = { fg = c.bg, bg = accent }
  hl.MasonHighlightBlockBold = { fg = c.bg, bg = accent, bold = true }
  hl.MasonMuted = { fg = c.fg_3 }
  hl.MasonMutedBlock = { fg = c.fg_1, bg = c.bg_3 }

  -- dap
  hl.DapBreakpoint = { fg = c.red }
  hl.DapBreakpointCondition = { fg = c.orange }
  hl.DapLogPoint = { fg = c.blue }
  hl.DapStopped = { fg = c.gold }
  hl.DapStoppedLine = { bg = A(c.yellow, 0.10) }

  -- illuminate
  hl.IlluminatedWordText = { bg = A(c.fg, 0.08) }
  hl.IlluminatedWordRead = { bg = A(c.fg, 0.08) }
  hl.IlluminatedWordWrite = { bg = A(accent, 0.14) }

  -- treesitter-context
  hl.TreesitterContext = { bg = c.bg_1 }
  hl.TreesitterContextLineNumber = { fg = c.fg_3, bg = c.bg_1 }
  hl.TreesitterContextBottom = { sp = c.border, underline = true }

  -- mini.statusline / mini.tabline
  hl.MiniStatuslineModeNormal = { fg = c.bg, bg = accent, bold = true }
  hl.MiniStatuslineModeInsert = { fg = c.bg, bg = c.green, bold = true }
  hl.MiniStatuslineModeVisual = { fg = c.bg, bg = c.purple, bold = true }
  hl.MiniStatuslineModeReplace = { fg = c.bg, bg = c.red, bold = true }
  hl.MiniStatuslineModeCommand = { fg = c.bg, bg = c.yellow, bold = true }
  hl.MiniStatuslineModeOther = { fg = c.bg, bg = c.cyan, bold = true }
  hl.MiniStatuslineDevinfo = { fg = c.fg_1, bg = c.bg_2 }
  hl.MiniStatuslineFilename = { fg = c.fg_2, bg = c.bg_1 }
  hl.MiniStatuslineFileinfo = { fg = c.fg_1, bg = c.bg_2 }
  hl.MiniStatuslineInactive = { fg = c.fg_3, bg = c.bg }
  hl.MiniTablineCurrent = { fg = c.fg, bg = c.bg_2, bold = true }
  hl.MiniTablineVisible = { fg = c.fg_2, bg = c.bg }
  hl.MiniTablineHidden = { fg = c.fg_3, bg = c.bg }
  hl.MiniTablineModifiedCurrent = { fg = accent, bg = c.bg_2, bold = true }
  hl.MiniTablineModifiedVisible = { fg = accent, bg = c.bg }
  hl.MiniTablineModifiedHidden = { fg = A(accent, 0.6), bg = c.bg }
  hl.MiniTablineFill = { bg = bg }

  -- render-markdown
  for i, col in ipairs({ c.teal, c.cyan, c.blue, c.purple, c.yellow, c.orange }) do
    hl["RenderMarkdownH" .. i] = { fg = col, bold = true }
    hl["RenderMarkdownH" .. i .. "Bg"] = { bg = A(col, 0.10) }
  end
  hl.RenderMarkdownCode = { bg = c.bg_1 }
  hl.RenderMarkdownCodeInline = { fg = c.green, bg = c.bg_1 }
  hl.RenderMarkdownBullet = { fg = c.cyan }
  hl.RenderMarkdownQuote = { fg = c.pink }

  return hl
end

return M
