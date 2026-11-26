if vim.g.loaded_nanquim then
  return
end
vim.g.loaded_nanquim = true

vim.api.nvim_create_user_command("NanquimToggle", function()
  require("nanquim").toggle()
end, { desc = "Toggle Nanquim / Nanquim Black" })
