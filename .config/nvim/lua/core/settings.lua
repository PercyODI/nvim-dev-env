vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("NeoTreeAutoExit", { clear = true }),
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and vim.bo.filetype == "neo-tree" then
      vim.cmd("quit")
    end
  end,
})

