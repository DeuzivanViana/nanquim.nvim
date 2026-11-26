local M = {}

local function rgb(hex)
  hex = hex:gsub("#", "")
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

--- Mix `fg` over `bg` with opacity `alpha` (0-1). Same result as an alpha color (#RRGGBBAA) in VS Code.
---@param fg string
---@param bg string
---@param alpha number
---@return string
function M.blend(fg, bg, alpha)
  local r1, g1, b1 = rgb(fg)
  local r2, g2, b2 = rgb(bg)
  local function ch(a, b)
    return math.floor(math.min(math.max(alpha * a + (1 - alpha) * b, 0), 255) + 0.5)
  end
  return string.format("#%02X%02X%02X", ch(r1, r2), ch(g1, g2), ch(b1, b2))
end

return M
