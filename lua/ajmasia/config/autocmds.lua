-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- style copilot icon
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("_colorscheme"),
  callback = function()
    ---@diagnostic disable-next-line: undefined-field
    local statusline_hl = vim.api.nvim_get_hl_by_name("StatusLine", true)

    vim.api.nvim_set_hl(0, "SLCopilot", { fg = "#6CC644", bg = statusline_hl.background })
  end,
})
