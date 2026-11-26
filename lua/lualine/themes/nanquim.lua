local nanquim = require("nanquim")
local c = nanquim.colors()
local bg = nanquim.config.transparent and "NONE" or c.bg

local function mode(color)
  return {
    a = { fg = c.bg, bg = color, gui = "bold" },
    b = { fg = c.fg_1, bg = c.bg_2 },
    c = { fg = c.fg_2, bg = bg },
  }
end

return {
  normal = mode(c.teal),
  insert = mode(c.green),
  visual = mode(c.purple),
  replace = mode(c.red),
  command = mode(c.yellow),
  terminal = mode(c.cyan),
  inactive = {
    a = { fg = c.fg_3, bg = bg },
    b = { fg = c.fg_3, bg = bg },
    c = { fg = c.fg_3, bg = bg },
  },
}
