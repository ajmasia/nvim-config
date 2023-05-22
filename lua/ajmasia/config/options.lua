-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.swapfile = false
-- vim.opt.winbar = "%=%m %f"
vim.opt.showtabline = 1

vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
