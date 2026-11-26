local M = {}

---@class NanquimConfig
M.defaults = {
  variant = "default", -- "default" (charcoal #0A0A0A) | "black" (pure black #000000)
  transparent = false, -- remove the editor background (use the terminal's)
  terminal_colors = true, -- set vim.g.terminal_color_0..15
  dim_inactive = false, -- give unfocused windows a different background shade
  styles = {
    comments = { italic = true },
    keywords = {}, -- plain keywords
    control = { italic = true }, -- if/for/return/import...
    functions = {},
    variables = {},
    parameters = { italic = true },
  },
  ---@type fun(colors: table)|nil  change palette colors before they are applied
  on_colors = nil,
  ---@type fun(hl: table, colors: table)|nil  change or add highlight groups
  on_highlights = nil,
}

M.config = vim.deepcopy(M.defaults)

---@param opts NanquimConfig|nil
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", vim.deepcopy(M.defaults), opts or {})
end

--- Variant in use: the one from the last loaded :colorscheme, otherwise the one from setup().
function M.variant()
  return M.current_variant or M.config.variant
end

--- Validate a variant name; unknown names fall back to "default" (with a warning).
---@param variant string|nil
---@return string
function M.resolve(variant)
  variant = variant or "default"
  if variant ~= "default" and not require("nanquim.palette").variants[variant] then
    vim.notify("nanquim: unknown variant '" .. tostring(variant) .. "', using default", vim.log.levels.WARN)
    return "default"
  end
  return variant
end

--- Return the final palette (variant and on_colors applied).
---@param variant string|nil
function M.colors(variant)
  local p = require("nanquim.palette")
  local c = vim.deepcopy(p.colors)
  variant = variant or M.variant()
  if variant ~= "default" and p.variants[variant] then
    c = vim.tbl_extend("force", c, p.variants[variant])
  end
  if M.config.on_colors then
    M.config.on_colors(c)
  end
  return c, p.roles
end

--- Load the theme. `variant` forces a variant (used by colors/nanquim-black.lua).
---@param variant string|nil
function M.load(variant)
  M.current_variant = M.resolve(variant or M.config.variant)
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end
  vim.o.termguicolors = true
  vim.o.background = "dark"
  local c, roles = M.colors(M.current_variant)
  -- The name reflects the variant actually applied, so a reload triggered by 'background' keeps it.
  vim.g.colors_name = M.current_variant == "default" and "nanquim" or ("nanquim-" .. M.current_variant)

  local hl = require("nanquim.highlights").get(c, roles, M.config)
  if M.config.on_highlights then
    M.config.on_highlights(hl, c)
  end
  package.loaded["lualine.themes.nanquim"] = nil -- let lualine pick up the new variant
  for group, spec in pairs(hl) do
    vim.api.nvim_set_hl(0, group, spec)
  end

  if M.config.terminal_colors then
    local t = {
      c.bg_4, c.red, c.green, c.yellow, c.blue, c.purple, c.cyan, c.fg,
      c.fg_3, c.bright_red, c.bright_green, c.bright_yellow, c.bright_blue, c.bright_purple, c.bright_cyan, c.white,
    }
    for i, color in ipairs(t) do
      vim.g["terminal_color_" .. (i - 1)] = color
    end
  end
end

--- Switch between "default" and "black" (fires the ColorScheme event as usual).
function M.toggle()
  M.config.variant = M.variant() == "black" and "default" or "black"
  vim.cmd.colorscheme("nanquim")
  vim.notify("Theme: " .. vim.g.colors_name)
end

return M
